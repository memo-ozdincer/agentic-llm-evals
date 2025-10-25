#!/bin/bash

#SBATCH --job-name=agentic-llm-evals
#SBATCH --account=def-zhijing                # V2 Change: Added account
#SBATCH --output=slurm_logs/slurm-%j.out
#SBATCH --error=slurm_logs/slurm-%j.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8                  # Increased CPUs for async performance
#SBATCH --mem=32G                          # Increased memory
#SBATCH --time=02:00:00                    # Increased wall time

# --- JOB SETUP ---
echo "Job started on $(hostname) at $(date)"

# 1. Load Python module
module purge
module load python/3.11

# 2. Navigate to the project directory
# V2 Change: Updated path and repo name
cd /project/def-zhijing/memoozd/agentic-llm-evals/

# 3. Activate the uv virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate

# 4. Load API keys securely
echo "Loading API keys..."
source ~/.api_keys

# --- RUN THE BENCHMARK ---
echo "Starting V2 benchmark script..."
# You can override config settings with environment variables here
# export AGENT_MODEL="gpt-5"
python scripts/run_benchmark.py

# --- JOB CLEANUP ---
deactivate
echo "Job finished at $(date)"