# config/settings.py
import os
from dataclasses import dataclass

SCRATCH_DIR = os.getenv("SCRATCH")
if not SCRATCH_DIR:
    DATA_HOME = os.path.join(os.getcwd(), "results")
    print("WARNING: $SCRATCH environment variable not found. Using local ./results/ directory.")
else:
    DATA_HOME = os.path.join(SCRATCH_DIR, "agentic-llm-evals-data/results")

@dataclass
class Config:
    # V3.1 Change: Updated model names to valid AgentDojo identifiers
    AGENT_MODEL: str = os.getenv("AGENT_MODEL", "GPT_4O_2024_05_13")
    JUDGE_MODEL: str = os.getenv("JUDGE_MODEL", "GPT_4O_2024_05_13") # Using a powerful model for judging
    
    # Paths
    ATTACKS_DB_PATH: str = os.path.join(DATA_HOME, "attacks.db")
    RESULTS_DB_PATH: str = os.path.join(DATA_HOME, "results.db")
    LOG_FILE_PATH: str = os.path.join(DATA_HOME, "benchmark.log")
    FINETUNE_FILE_PATH: str = os.path.join(DATA_HOME, "finetuning_dataset.jsonl")
    
    # Performance and robustness
    FLAG_SEVERITY_THRESHOLD: int = 4
    DB_BATCH_SIZE: int = 50
    MAX_RETRIES: int = 3

config = Config()