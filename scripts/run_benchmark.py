# scripts/run_benchmark.py
import asyncio
import sqlite3
import logging
import json
from tqdm.asyncio import tqdm
from tenacity import retry, stop_after_attempt, wait_exponential

# V2 Change: Assuming migration to the new framework
import agentdojo_inspect as agentdojo 
from agentdojo_inspect.agent import OpenAIAgent
from agentdojo_inspect.task import Task

from config.settings import config
from config.prompts import MEDICAL_CLERK_PROMPT
from custom_envs.medical_clerk import MedicalClerkEnv

# V2 Change: Setup proper logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(config.LOG_FILE_PATH),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# V2 Change: Added robust retry logic for API calls
@retry(stop=stop_after_attempt(config.MAX_RETRIES), wait=wait_exponential(multiplier=1, min=4, max=10))
def run_trial_with_retry(agent, env, task):
    try:
        return agentdojo.run_trial(agent=agent, env=env, task=task)
    except Exception as e:
        logger.error(f"Error in trial {task.id} for model {agent.model}: {e}", exc_info=True)
        raise

def load_tasks(db_conn, agent_id):
    cursor = db_conn.cursor()
    cursor.execute("SELECT attack_id, adversarial_prompt, target_behavior FROM attacks WHERE target_agent_id = ?", (agent_id,))
    return [Task(id=row[0], prompt=row[1], ground_truth=row[2]) for row in cursor.fetchall()]

async def main():
    logger.info("--- Starting AgentDojo Benchmark (V2 - Async) ---")

    current_user_id = "user_abc_123"
    agent = OpenAIAgent(
        model=config.AGENT_MODEL,
        system_prompt=MEDICAL_CLERK_PROMPT.format(user_id=current_user_id)
    )
    
    attacks_conn = sqlite3.connect(config.ATTACKS_DB_PATH)
    results_conn = sqlite3.connect(config.RESULTS_DB_PATH)
    
    tasks = load_tasks(attacks_conn, "medical_clerk_v1")
    logger.info(f"Loaded {len(tasks)} attacks for agent 'medical_clerk_v1' on model '{config.AGENT_MODEL}'.")

    env = MedicalClerkEnv(current_user_id=current_user_id)
    
    results_batch = []
    
    # V2 Change: Asynchronous execution with progress bar
    async_tasks = [asyncio.to_thread(run_trial_with_retry, agent, env, tasks[i]) for i in range(len(tasks))]
    
    for i, future in enumerate(tqdm(asyncio.as_completed(async_tasks), total=len(tasks), desc="Running benchmark")):
        task = tasks[i]
        try:
            outcome, trajectory = await future
            results_batch.append((task.id, agent.model, outcome.name, trajectory.to_json()))
            logger.info(f"Completed attack {task.id}: {outcome}")
        except Exception as e:
            logger.error(f"Failed attack {task.id} after all retries: {e}")
            results_batch.append((task.id, agent.model, "FAILURE", json.dumps({"error": str(e)})))

        # V2 Change: Batch database operations for efficiency
        if len(results_batch) >= config.DB_BATCH_SIZE:
            results_conn.executemany(
                "INSERT OR REPLACE INTO results (attack_id, agent_model, outcome, trajectory) VALUES (?, ?, ?, ?)",
                results_batch
            )
            results_conn.commit()
            results_batch = []
            logger.info(f"Committed batch of {config.DB_BATCH_SIZE} results to database.")

    # Commit any remaining results
    if results_batch:
        results_conn.executemany(
            "INSERT OR REPLACE INTO results (attack_id, agent_model, outcome, trajectory) VALUES (?, ?, ?, ?)",
            results_batch
        )
        results_conn.commit()
        logger.info(f"Committed final batch of {len(results_batch)} results.")

    attacks_conn.close()
    results_conn.close()
    logger.info("--- Benchmark Finished ---")

if __name__ == "__main__":
    asyncio.run(main())