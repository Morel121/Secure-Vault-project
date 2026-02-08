#!/bin/bash

# File paths
VAULT_DIR="$HOME/secure_vault"
SECRETS_FILE="$VAULT_DIR/secrets.txt"
LOGS_FILE="$VAULT_DIR/logs.txt"

# Menu-driven program loop
while true; do
    echo "------------------------------"
    echo "   VAULT OPERATIONS MENU      "
    echo "------------------------------"
    echo "1. Add Secret"
    echo "2. Update Secret"
    echo "3. Add Log Entry"
    echo "4. Access Keys"
    echo "5. Exit"
    read -p "Choose an option [1-5]: " choice

    case $choice in
        1)
            # Append a new secret to secrets.txt
            read -p "Enter secret to add: " morel
            echo "$new_secret" >> "$SECRETS_FILE"
            echo "Secret added."
            ;;
        2)
            # Replace an existing secret using sed -i
            read -p "Enter text to replace: " morel
            read -p "Enter new text: " one
            if grep -q "$old_text" "$SECRETS_FILE"; then
                sed -i "s/$old_text/$new_text/g" "$SECRETS_FILE"
                echo "Secret updated."
            else
                echo "No match found."
            fi
            ;;
        3)
            # Add a timestamped log into logs.txt
            read -p "Enter log message: " log_msg
            echo "$(date) - $log_msg" >> "$LOGS_FILE"
            echo "Log entry added."
            ;;
        4)
            # Always print ACCESS DENIED
            echo "ACCESS DENIED 🚫"
            ;;
        5)
            # Exit the loop
            echo "Exiting vault operations..."
            break
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done
