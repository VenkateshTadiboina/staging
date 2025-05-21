#!/bin/bash

# Define colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

USERID=$(id -u)
LOGS_DIR="/var/log/shellscript-log"
SCRIPTNAME=$(basename "$0" | cut -d "." -f1)
LOG_FILE="$LOGS_DIR/$SCRIPTNAME.log"

# Create directory for logs
mkdir -p "$LOGS_DIR"
echo "Script start time: $(date)" | tee -a "$LOG_FILE"

if [ "$USERID" -ne 0 ]; then
  echo -e " ${R}ERROR::${N} Please run this script with root access" | tee -a "$LOG_FILE"
  exit 1
else
  echo "You are running with root access" | tee -a "$LOG_FILE"
fi

# Function to validate package installation
VALIDATE(){
  if [ "$1" -eq 0 ]; then
    echo -e "Installing $2 is... ${G}SUCCESS${N}" | tee -a "$LOG_FILE"
  else
    echo -e "Installing $2 is... ${R}FAILURE${N}" | tee -a "$LOG_FILE"
    exit 1
  fi
}

# Install required packages
for package in mysql python3 nginx; do
  if ! rpm -q "$package" &>/dev/null; then
    echo "$package is not installed... going to install it" | tee -a "$LOG_FILE"
    dnf install "$package" -y
    VALIDATE $? "$package"
  else
    echo -e "${Y}$package is already installed... Nothing to do${N}" | tee -a "$LOG_FILE"
  fi
done
