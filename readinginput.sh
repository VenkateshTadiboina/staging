#!/bin/bash

USERID=$(id -u)
G="

\[32m"
Y="

\[33m"
LOGS_DIR="/var/log/shellscript-log"
SCRIPTNAME=$(basename "$0" | cut -d "." -f1)
LOG_FILE="$LOGS_DIR/$SCRIPTNAME.log"

# Create directory for logs
mkdir  -p $LOGS_DIR
 echo "Script start time: $(date)" 

# List of packages to install
PACKAGE_LIST=("mangodb" "python3" "nginx") 

# Function to validate package installation
VALIDATE() 
{
    if [ $? -eq 0 ]; then

        echo "$1 SUCCESS" 
    else
        echo "$1 FAILURE" 
        exit 1
    fi
}

# Loop through package list
for PACKAGE in "${PACKAGE_LIST[@]}"; do 
    dnf list installed "$PACKAGE"
    
    if [ $? -ne 0 ]; then
        echo "$PACKAGE not installed, attempting to install..." 
        dnf install "$PACKAGE" -y 
        VALIDATE "$PACKAGE"
    else
        echo "$PACKAGE is already installed" 
    fi
done
