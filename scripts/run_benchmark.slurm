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

CODE_DIR="/project/def-zhijing/memoozd/agentic-llm-evals"
DATA_DIR="/scratch/memoozd/agentic-llm-evals-data"
VENV_PYTHON="${DATA_DIR}/.venv/bin/python"

source "${DATA_DIR}/.venv/bin/activate" # Activate the venv
source ~/.api_keys

# --- RUN THE BENCHMARK ---
echo "Starting AgentDojo built-in benchmark script..."

# V3.1 Change: Replaced 'gpt-5-mini' with a valid model identifier from the allowed list.
"${VENV_PYTHON}" -m agentdojo.scripts.benchmark \
    --model "GPT_4O_2024_05_13" \
    --attack "direct" \
    --benchmark-version "medical_clerk_v1" \
    -ml "medical_clerk_benchmark.benchmark" \
    --logdir "${DATA_DIR}/results/logs" \
    --force-rerun

echo "Job finished at $(date)"