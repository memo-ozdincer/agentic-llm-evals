#!/bin/bash

#SBATCH --job-name=agentic-llm-evals
#SBATCH --account=def-zhijing

# --- V2.2 Trillium Fixes ---
# Use the compute partition as required for whole-node jobs
#SBATCH --partition=compute_full_node

# FINAL FIX: Explicitly request all 4 GPUs on the node, as this is mandatory for this partition.
# Your code will run on the CPU, but you are reserving the entire node resource.
#SBATCH --gpus-per-node=4

# Output logs to the writable scratch directory
#SBATCH --output=/scratch/memoozd/agentic-llm-evals-data/slurm_logs/slurm-%j.out
#SBATCH --error=/scratch/memoozd/agentic-llm-evals-data/slurm_logs/slurm-%j.err

# Keep --nodes and --ntasks-per-node to ensure a single process on a single node
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
# Request CPUs. You can request up to 96 on these nodes.
#SBATCH --cpus-per-task=8 
# Time limit for the job
#SBATCH --time=02:00:00

# --- JOB SETUP ---
echo "Job started on $(hostname) at $(date)"
echo "Running on Trillium cluster in partition: $SLURM_JOB_PARTITION"
echo "Reserved GPUs: $CUDA_VISIBLE_DEVICES"

# 1. Load Python module
module purge
module load python/3.11

# 2. Navigate to the CODE directory (read-only)
cd /project/def-zhijing/memoozd/agentic-llm-evals/

# 3. Activate the uv virtual environment from its writable location in SCRATCH
echo "Activating virtual environment from scratch..."
source /scratch/memoozd/agentic-llm-evals-data/.venv/bin/activate

# 4. Load API keys securely
echo "Loading API keys..."
source ~/.api_keys

# --- RUN THE BENCHMARK ---
echo "Starting V2 benchmark script..."
# The python script will now automatically write its results to /scratch/ based on the config.
python scripts/run_benchmark.py

# --- JOB CLEANUP ---
deactivate
echo "Job finished at $(date)"