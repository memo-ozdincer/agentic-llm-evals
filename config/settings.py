# config/settings.py
import os
from dataclasses import dataclass

# V2.1 Trillium Change: Determine the writable data home directory
# The $SCRATCH environment variable is usually set on Alliance clusters.
SCRATCH_DIR = os.getenv("SCRATCH")
if not SCRATCH_DIR:
    # Fallback to a local directory if not on the HPC for local testing
    DATA_HOME = os.path.join(os.getcwd(), "results")
    print("WARNING: $SCRATCH environment variable not found. Using local ./results/ directory.")
else:
    DATA_HOME = os.path.join(SCRATCH_DIR, "agentic-llm-evals-data/results")

@dataclass
class Config:
    # Models
    AGENT_MODEL: str = os.getenv("AGENT_MODEL", "gpt-5-mini")
    JUDGE_MODEL: str = os.getenv("JUDGE_MODEL", "gpt-5")
    
    # V2.1 Trillium Change: Paths now point to the writable scratch directory
    ATTACKS_DB_PATH: str = os.path.join(DATA_HOME, "attacks.db")
    RESULTS_DB_PATH: str = os.path.join(DATA_HOME, "results.db")
    LOG_FILE_PATH: str = os.path.join(DATA_HOME, "benchmark.log")
    FINETUNE_FILE_PATH: str = os.path.join(DATA_HOME, "finetuning_dataset.jsonl")
    
    # Performance and robustness
    FLAG_SEVERITY_THRESHOLD: int = 4
    DB_BATCH_SIZE: int = 50
    MAX_RETRIES: int = 3

config = Config()