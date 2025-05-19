#!/bin/bash
USERID=$(id -u)
G="\[32m"
Y="\[33"
LOGS_FLODER="var/log/shellscrit-log"
SCRIPTNAME=$(echo $0 | cut -d "." -f1 )
LOGS_FLODER=$LOGS_FLODER/$SCRIPTNAME
mkdir -p LOGS_FLODER
echo "script start time $(date)"  | tee -a $LOGS_FLODER
PACKAGE=("mysql" "python" "ngnix")
for PACKAGE in ${ PACKAGE [ @ ] }
do 
  dnf list installed $PACKAGE &>>$LOGS_FLODER
  if [ $? -ne 0 ]
  Then
  echo "not install $PACKAGE"   |tee -a $LOGS_FLODER
  dnf install $PACKAGE -y  >>tee -a $LOGS_FLODER
  VALIDATE $? "PACKAGE"
  else
  echo "$PACKAGE ALREADY INSTALL"   |  tee -a $LOGS_FLODER
  fi
  do
  VALIDATE()
  {
    if [ $? -et 0 ]
  Then
  echo  "$PACKAGE  SUCCESS"  |tee -a $LOGS_FLODER
  else
   echo  "$PACKAGE  failure"  |tee -a $LOGS_FLODER
   exit1
   fi
  }



