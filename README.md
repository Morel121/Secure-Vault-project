The  Student Attendance Tracker project is designed to automate and manage the environment setup for a python based attendance monitoring system.
The primary goal is to ensure that the application, specifically attendance-checker.py, is deployed in structured directory with configurable parameters and robuts error handling.
File Organizations and the Deployment, The project bagan with restructuring the workspace. 
Original files from attendance_tracker_V1 were migrated into a specialized deployment directory, deploy_agent_Morel121. 
Dynamic configuration and Stream Editing, A core feature of the agent is the Dynamic configuration module. Using the read command the agent prompts the user input custom thresholds for "warning" (default 75%) and "Failure"(default 50%).
These values are then injected into the config.json file using the sed command, which perfoms an "in-place" edit to update the system settings without requiring manual file intervention.
Process Manangement and signal   Handling, To ensure system stability, the project implements Process Management Via a "Signal Trap". If a user attempts to interrupt the script (using SIGINITor CTRL+C), the agent catches the signal and executesa cleanup routine:
The current state of the project directory is bundled into a compresed archive named attendance_tracker_{Morel121}_archive.
The incompleteor temporary directories are deleted to maintain a clean worksplace.
Finally, the agent performs a "Health check" by validating the local environment. it verifies if python3 is installed on the local system, ensuring that the attendance checker has the necessary runtime environment to execute successfully.




https://drive.google.com/file/d/1sFbpJtD_0i6yDMYpaQdz5r3d2W2FhyBk/view?usp=sharing
