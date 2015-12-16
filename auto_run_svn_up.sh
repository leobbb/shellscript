#!/bin/bash
##########################################################
# Use to update svn directory in present work directory. 
# Author: yanzhenxing
# Date: 20151214
# Usage: run directly
##########################################################

HOMEPATH=$PWD
FILENAME=$HOMEPATH"/"update_info

function func()
{
  cd $1
  # echo "Now in $PWD" >> $FILENAME
  svn info > /dev/null 2>&1
  if [ 0 == $? ] 
  then
    echo "$PWD is a svn directory." >> $FILENAME
    svn up >> $FILENAME 2>&1  
    echo "Result: $PWD had updated." >> $FILENAME
    echo "" >> $FILENAME 
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

echo `date` >> $FILENAME
echo "Start to update..." >> $FILENAME
echo "HOMEPATH = $HOMEPATH" >> $FILENAME

func $HOMEPATH

cd $HOMEPATH
echo  >> $FILENAME
echo "Everything is done." >> $FILENAME

