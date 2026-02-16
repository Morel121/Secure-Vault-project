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
