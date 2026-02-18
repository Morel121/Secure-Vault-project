#!/bin/bash

# --- STEP 3: PROCESS MANAGEMENT (THE TRAP) ---
# This function runs if you press Ctrl+C
cleanup() {
    echo -e "\n\n[!] Interrupt detected. Archiving current state..."
    # Bundles the project into an archive in the parent directory
    tar -czf "../attendance_tracker_archive.tar.gz" .
    echo "Archive created. Cleaning up workspace..."
    # Deletes the directory to keep the workspace clean
    cd .. && rm -rf "Secure-Vault-project"
    exit 1
}

# Link the cleanup function to the SIGINT signal (Ctrl+C)
trap cleanup SIGINT

# --- STEP 2: DYNAMIC CONFIGURATION ---
echo "--- Project Configuration ---"
read -rp "Enter new Warning threshold (default 75): " new_warning
read -rp "Enter new Failure threshold (default 50): " new_failure

# Set default values if input is empty
new_warning=${new_warning:-75}
new_failure=${new_failure:-50}

# Update the config.json file using sed
sed -i "s/\(\"warning_threshold\": \)[0-9]*/\1$new_warning/" Helpers/config.json
sed -i "s/\(\"failure_threshold\": \)[0-9]*/\1$new_failure/" Helpers/config.json

# --- STEP 4: ENVIRONMENT VALIDATION (HEALTH CHECK) ---
echo -e "\n--- Running Health Check ---"

# 1. Verify if python3 is installed
if python3 --version > /dev/null 2>&1; then
    echo "Success: $(python3 --version) is installed."
else
    echo "Warning: Python 3 is missing!"
fi

# 2. Ensure application directory structure is followed
if [ -d "Helpers" ] && [ -f "Helpers/config.json" ]; then
    echo "Directory structure: [OK]"
else
    echo "Directory structure: [ERROR] Required files or folders missing."
fi

echo -e "\nSetup Complete. Current config:"
cat Helpers/config.json 



# --- 1. DIRECTORY ARCHITECTURE ---
# Prompt the user for a version name (e.g., Morel121)
echo "Enter the version or identifier (e.g., Morel121):"
read input_val

main="attendance_tracker_${input_val}"

# Create the tree structure immediately to avoid "No such file" errors
echo "Creating directory structure in $..."
mkdir -p "$main/Helpers"
mkdir -p "$main/reports"

# --- 2. FILE CREATION & POPULATION ---
echo "Populating files..."

# Create the Python logic file based on your source code image
cat <<EOF > "$main/attendance_checker.py"
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    # 1. Load Config
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)

    # 2. Archive old reports.log if it exists
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    # 3. Process Data
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        
        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])
            
            # Percentage Calculation
            attendance_pct = (attended / total_sessions) * 100
            
            message = ""
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."
            
            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if _name_ == "_main_":
    run_attendance_check()
EOF

# Create the assets.csv with the specific data from your image
cat <<EOF > "$main/Helpers/assets.csv"
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
EOF

# Create the initial config.json
echo '{"total_sessions": 15, "run_mode": "live", "thresholds": {"warning": 75, "failure": 50}}' > "$main/Helpers/config.json"

# Create an empty log file
touch "$main/reports/reports.log"

# --- 3. DYNAMIC CONFIGURATION (STREAM EDITING) ---
echo "--- Project Configuration ---"
echo "Enter new Warning threshold (default 75):"
read new_warning
echo "Enter new Failure threshold (default 50):"
read new_failure

# Use 'sed' to update the config file inside the newly created directory
# This fixes the "No such file or directory" error by using the $PARENT_DIR variable
sed -i "s/\"warning\": [0-9]*/\"warning\": $new_warning/" "$main/Helpers/config.json"
sed -i "s/\"failure\": [0-9]*/\"failure\": $new_failure/" "$main/Helpers/config.json"

echo "------------------------------------------------"
echo "SETUP SUCCESSFUL!"
echo "Architecture created for: $main"
echo "To run the checker: cd $main && python3 attendance_checker.py"
