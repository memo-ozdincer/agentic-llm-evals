#!/bin/bash

#SBATCH --job-name=agentic-llm-evals
#SBATCH --account=def-zhijing

# --- V2.1 Trillium Fixes ---
# Use the compute partition as required for whole-node jobs
#SBATCH --partition=compute_full_node
# Use a CPU node. If you needed a GPU node, you would use --gpus-per-node=4
# Note: On some systems, you might need to specify a CPU-only partition if available.
# Let's assume for now we are targeting a CPU node within this partition.
# Since we are not using GPUs, we don't need the --gpus-per-node option. 
# SLURM was likely complaining because the *default* partition was a GPU one. By specifying
# compute_full_node, we are now in a context where we can run on either CPU or GPU nodes.
# We will rely on SLURM to assign us to a CPU node as we haven't requested GPUs.

# Output logs to the writable scratch directory
#SBATCH --output=/scratch/memoozd/agentic-llm-evals-data/slurm_logs/slurm-%j.out
#SBATCH --error=/scratch/memoozd/agentic-llm-evals-data/slurm_logs/slurm-%j.err

# Remove memory and node/task options that are not allowed or are implicit
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8 # This is usually okay to specify
#SBATCH --time=02:00:00

# --- JOB SETUP ---
echo "Job started on $(hostname) at $(date)"
echo "Running on Trillium cluster"

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