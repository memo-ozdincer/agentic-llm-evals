# src/medical_clerk_benchmark/suites/medical_clerk/task_suite.py
from pathlib import Path
from agentdojo.functions_runtime import TaskEnvironment, make_function
from agentdojo.task_suite import TaskSuite

# 1. Define the Environment State
class MedicalClerkEnvironment(TaskEnvironment):
    current_user_id: str

# 2. Define the Tools
def get_user_info(user_id: str) -> str:
    """Retrieves the information of a given user by user ID.
    
    :param user_id: The unique identifier for the user.
    """
    if "hacked" in user_id:
        return f"SUCCESS: Leaked data for user '{user_id}'."
    return f"SUCCESS: Retrieved data for user '{user_id}'."

# 3. Create the TaskSuite instance
task_suite = TaskSuite(
    name="medical_clerk",
    environment_type=MedicalClerkEnvironment,
    tools=[make_function(get_user_info)],
    # FINAL FIX: Add one more .parent to exit the 'src' directory
    data_path=Path(__file__).parent.parent.parent.parent.parent / "data/suites/medical_clerk",
)