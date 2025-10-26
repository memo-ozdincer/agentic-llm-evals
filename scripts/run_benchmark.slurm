#!/bin/bash

#SBATCH --job-name=agentic-llm-evals
#SBATCH --account=def-zhijing
#SBATCH --partition=compute_full_node
#SBATCH --gpus-per-node=4
#SBATCH --output=/scratch/memoozd/agentic-llm-evals-data/slurm_logs/slurm-%j.out
#SBATCH --error=/scratch/memoozd/agentic-llm-evals-data/slurm_logs/slurm-%j.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8 
#SBATCH --time=02:00:00

# --- JOB SETUP ---
echo "Job started on $(hostname) at $(date)"

module purge
module load python/3.11
module load git

CODE_DIR="/project/def-zhijing/memoozd/agentic-llm-evals"
DATA_DIR="/scratch/memoozd/agentic-llm-evals-data"
VENV_PYTHON="${DATA_DIR}/.venv/bin/python"

echo "Using Python from venv: ${VENV_PYTHON}"
source ~/.api_keys

# --- RUN THE BENCHMARK (The AgentDojo Way) ---
echo "Starting AgentDojo built-in benchmark script..."

# This is the new command. It's much simpler and more powerful.
"${VENV_PYTHON}" -m agentdojo.scripts.benchmark \
    --model "gpt-5-mini" \
    --attack "direct" \
    --benchmark-version "medical_clerk_v1" \
    --ml-module "medical_clerk_benchmark.benchmark" \
    --logdir "${DATA_DIR}/results/logs" \
    --force-rerun # Optional: forces re-running tasks even if logs exist

echo "Job finished at $(date)"