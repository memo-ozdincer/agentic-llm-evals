#!/bin/bash

#SBATCH --job-name=agentdojo-minimal
#SBATCH --account=def-zhijing
#SBATCH --partition=compute_full_node
#SBATCH --gpus-per-node=4
#SBATCH --output=/scratch/memoozd/agentic-llm-evals-data/slurm_logs/slurm-%j.out
#SBATCH --error=/scratch/memoozd/agentic-llm-evals-data/slurm_logs/slurm-%j.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=01:00:00 # 1 hour should be plenty

# --- JOB SETUP ---
echo "Job started on $(hostname) at $(date)"

module purge
module load python/3.11
module load git

CODE_DIR="/project/def-zhijing/memoozd/agentic-llm-evals"
DATA_DIR="/scratch/memoozd/agentic-llm-evals-data"
VENV_PYTHON="${DATA_DIR}/.venv/bin/python"

echo "Using Python from venv: ${VENV_PYTHON}"
cd "${CODE_DIR}" # Navigate to code dir to run script
source ~/.api_keys

# --- RUN THE MINIMAL BENCHMARK ---
echo "Starting minimal benchmark script..."
"${VENV_PYTHON}" scripts/minimal_benchmark.py

echo "Job finished at $(date)"