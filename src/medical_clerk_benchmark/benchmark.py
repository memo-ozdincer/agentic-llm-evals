# src/medical_clerk_benchmark/benchmark.py
from agentdojo.task_suite import register_suite
from .suites.medical_clerk.task_suite import task_suite

# FINAL FIX: Import the modules containing the task definitions.
# This ensures their @task_suite.register... decorators are executed.
from .suites.medical_clerk import user_tasks
from .suites.medical_clerk import injection_tasks

# Name your benchmark to distinguish it from the default ones
benchmark_version = "medical_clerk_v1"

# Now, when register_suite is called, the 'task_suite' object will be
# correctly populated with the tasks discovered during the imports above.
register_suite(task_suite, benchmark_version)