#!/bin/bash

#SBATCH --job-name=agentdojo-benchmark
#SBATCH --output=/project/def-zhijing/memoozd/agentdojo_benchmark/slurm_logs/slurm-%j.out   # %j is job ID
#SBATCH --error=/project/def-zhijing/memoozd/agentdojo_benchmark/slurm_logs/slurm-%j.err
#SBATCH --account=def-zhijing                   # Charge this job to the Jin group RAP
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4                       # Request 4 CPUs
#SBATCH --mem=16G                               # Request 16 GB of memory
#SBATCH --time=01:00:00                         # 1 hour wall time

# --- JOB SETUP ---
echo "Job started on $(hostname) at $(date)"

# Purge modules and load Python
module purge
module load python/3.11

# Go to project directory
cd /project/def-zhijing/memoozd/agentdojo_benchmark

# Activate uv (or venv) virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate    # Update if uv puts the venv somewhere else

# Load API keys if needed
echo "Loading API keys..."
source ~/.api_keys

# --- RUN THE BENCHMARK ---
echo "Starting benchmark script..."
python scripts/run_benchmark.py

# --- JOB CLEANUP ---
deactivate
echo "Job finished at $(date)"

