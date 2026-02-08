#!/bin/bash

# Directory path
VAULT_DIR="$HOME/secure_vault"

# 1. Display a header with the current date
echo "--- VAULT MONITORING REPORT ---"
echo "Date: $(date)"
echo "-------------------------------"

# Check if the vault exists
if [ ! -d "$VAULT_DIR" ]; then
    echo "Error: secure_vault directory not found."
    exit 1
fi

# 2. For each file in secure_vault, display its details
for file in "$VAULT_DIR"/*; do
    # basename extracts only the filename without the path
    echo "Checking file: $(basename "$file")"
    
    # ls -l shows the permissions and owner
    ls -l "$file"
    echo "-------------------------------"
done
