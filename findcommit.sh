#!/bin/bash
#
# 查找修改文件中字符串的提交
#
# ./findcommit.sh param1  param2
# param1: directory of file 
# param2: string
#


if [ "-$2" = "-" ]; then
    echo "[01] Error: need two parameters"
    exit 1
fi

DIR=$PWD
FILE=$1
STR=$2

if [ ! -f "$FILE" ]; then
    echo "[02] Error: first parameter wrong"
    echo "     Please input whole directory of file"
    exit 2
fi

git log -1 &> /dev/null
if [ $? != 0 ]; then
    echo "    Error: Not a git repository (or any parent up to mount parent )"
    exit 3
fi

git log --oneline $FILE | while read line
do
    CIID=`echo $line|awk -F ' ' '{print $1}'`
    git show $CIID | grep -i $STR | grep "^[-+]" > /dev/null
    if [ $? == 0 ]; then
	git lg -1 $CIID
	#echo $line
    fi
done 

