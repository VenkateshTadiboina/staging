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
 echo "Script start time: $(date)"   &>>$LOGS_DIR

# List of packages to install
PACKAGE_LIST=("mysql" "python3" "nginx") &>>$LOGS_DIR

# Function to validate package installation
VALIDATE() 
{
    if [ $? -eq 0 ]; then

        echo "$1 SUCCESS" &>>$LOGS_DIR
    else
        echo "$1 FAILURE" &>>$LOGS_DIR
        exit 1
    fi
}

# Loop through package list
for PACKAGE in "${PACKAGE_LIST[@]}";
do 
    dnf list installed "$PACKAGE"
    
    if [ $? -ne 0 ]; then
        echo "$PACKAGE not installed, attempting to install..." &>>$LOGS_DIR
        dnf install "$PACKAGE" -y 
        VALIDATE "$PACKAGE"
    else
        echo "$PACKAGE is already installed" &>>$LOGS_DIR
    fi
done
