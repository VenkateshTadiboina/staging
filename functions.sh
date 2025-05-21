#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\[33m"
N="\[0m"

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\[33m"
N="\[0m"
LOGS_DIR="/var/log/shellscript-log"
SCRIPTNAME=$(basename "$0" | cut -d "." -f1)
LOG_FILE="$LOGS_DIR/$SCRIPTNAME.log"

# Create directory for logs
mkdir  -p $LOGS_DIR
 echo "Script start time: $(date)"   |tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
  echo  -e " $R ERROR:: $N Please run this script with root access"  |tee -a $LOG_FILE
  exit 1 # give other than 0 upto 127
else
  echo "You are running with root access"  |tee -a $LOG_FILE
fi

# validate function takes input as exit status, and the command they tried to install
VALIDATE(){
  if [ $1 -eq 0 ]
  then
    echo -e "Installing $2 is ... $G SUCCESS $N "  |tee -a $LOG_FILE
  else
    echo -e "Installing $2 is ... $R FAILURE $N "  |tee -a $LOG_FILE
    exit 1
  fi
}

dnf list installed mysql  |tee -a $LOG_FILE
if [ $? -ne 0 ]
then
  echo "MySQL is not installed... going to install it"  |tee -a $LOG_FILE
  dnf install mysql -y
  VALIDATE $? "MySQL"
else
  echo -e " $Y MySQL is already installed...Nothing to do $N "  |tee -a $LOG_FILE
fi

dnf list installed python3  |tee -a $LOG_FILE
if [ $? -ne 0 ]
then
  echo "python3 is not installed... going to install it"  |tee -a $LOG_FILE
  dnf install python3 -y
  VALIDATE $? "python3"
else
  echo -e " $Y python3 is already installed...Nothing to do $N"  |tee -a $LOG_FILE
fi

dnf list installed nginx  |tee -a $LOG_FILE
if [ $? -ne 0 ]
then
  echo "nginx is not installed... going to install it"  |tee -a $LOG_FILE
  dnf install nginx -y
  VALIDATE $? "nginx"
else
  echo -e " $Y nginx is already installed...Nothing to do $N"  |tee -a $LOG_FILE
fi