#!/bin/bash
##########################################################
# Use to update svn directory in present work directory. 
# Author: yanzhenxing
# Date: 20151214
# Usage: run directly
##########################################################

HOMEPATH=$PWD
FILENAME=$HOMEPATH"/"update_info_$(date '+%Y-%m-%d_%H-%M')

function func()
{
  cd $1
  # echo "Now in $PWD" >> $FILENAME
  svn info > /dev/null 2>&1
  if [ 0 == $? ] 
  then
    echo "$PWD is a svn directory." | tee -a $FILENAME
    svn up 2>&1 | tee -a $FILENAME
    echo "Result: $PWD had updated." | tee -a $FILENAME
    echo "" | tee -a $FILENAME
  else 
    #echo "This is not a svn directory."
    for file in `ls $1`
    do
      if [ -d $1"/"$file ]
      then
        func $1"/"$file
      fi
    done 
  fi
}

echo `date` | tee -a $FILENAME
echo "Start to update..." | tee -a $FILENAME
echo "HOMEPATH = $HOMEPATH" | tee -a $FILENAME

func $HOMEPATH

cd $HOMEPATH
echo `date` | tee -a $FILENAME
echo "Everything is done." | tee -a $FILENAME

