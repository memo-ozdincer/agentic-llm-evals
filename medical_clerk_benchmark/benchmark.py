# medical_clerk_benchmark/benchmark.py
from agentdojo.task_suite import register_suite
from .suites.medical_clerk.task_suite import task_suite

# Name your benchmark to distinguish it from the default ones
benchmark_version = "medical_clerk_v1"
register_suite(task_suite, benchmark_version)