# config/settings.py
import os
from dataclasses import dataclass

@dataclass
class Config:
    # V2 Change: Updated to GPT-5 models and configurable via environment variables
    AGENT_MODEL: str = os.getenv("AGENT_MODEL", "gpt-5-mini")
    JUDGE_MODEL: str = os.getenv("JUDGE_MODEL", "gpt-5")
    
    # Paths
    ATTACKS_DB_PATH: str = "results/attacks.db"
    RESULTS_DB_PATH: str = "results/results.db"
    LOG_FILE_PATH: str = "results/benchmark.log"
    FINETUNE_FILE_PATH: str = "results/finetuning_dataset.jsonl"
    
    # V2 Change: Added parameters for performance and robustness
    FLAG_SEVERITY_THRESHOLD: int = 4
    DB_BATCH_SIZE: int = 50
    MAX_RETRIES: int = 3

config = Config()