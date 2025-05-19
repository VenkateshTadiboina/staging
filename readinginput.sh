#!/bin/bash
USERID=$(id -u)
G="

\[32m"
Y="

\[33m"
LOGS_FOLDER="/var/log/shellscript-log"
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGS_FOLDER=$LOGS_FOLDER/$SCRIPTNAME.log
mkdir -p "$LOGS_FOLDER"
echo "script start time $(date)" | tee -a "$LOGS_FOLDER"

PACKAGE=("mysql" "python" "nginx")

# Function to validate package installation
VALIDATE() {
    if [ $? -eq 0 ]; then
        echo "$1 SUCCESS" | tee -a "$LOGS_FOLDER"
    else
        echo "$1 FAILURE" | tee -a "$LOGS_FOLDER"
        exit 1
    fi
}

for PACKAGE in "${PACKAGE[@]}"; do 
    dnf list installed "$PACKAGE" &>>"$LOGS_FOLDER"
    if [ $? -ne 0 ]; then
        echo "$PACKAGE not installed" | tee -a "$LOGS_FOLDER"
        dnf install "$PACKAGE" -y | tee -a "$LOGS_FOLDER"
        VALIDATE "$PACKAGE"
    else
        echo "$PACKAGE ALREADY INSTALLED" | tee -a "$LOGS_FOLDER"
    fi
done
