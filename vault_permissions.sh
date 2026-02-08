#!/bin/bash
update_permission() {
    local file=$1
    local default_perm=$2
    local path="$HOME/secure_vault/$file"
    echo "Current permissions for $file:"
    ls -l "$path"
    read -p "Update $file? (yes/no): " choice
    if [ "$choice" == "yes" ]; then
        read -p "Enter permission or press Enter for default ($default_perm): " new_perm
        if [ -z "$new_perm" ]; then
            chmod "$default_perm" "$path"
        else
            chmod "$new_perm" "$path"
        fi
    fi
}
update_permission "keys.txt" "600"
update_permission "secrets.txt" "640"
update_permission "logs.txt" "644"
