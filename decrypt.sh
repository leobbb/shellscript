#!/bin/bash

if [ -z "$1" ] ;then
    #echo hello1
    DIRT="/home"
else
    #echo hello2
    DIRT="$1"
fi

echo
echo "To decrypt : ${DIRT}"
date

# You can change file type to be decrypted. 
find $DIRT -type f -name '*.sh' -exec file {} \; | grep 'data' | awk -F: '{print $1}' > /tmp/$$.templist

while read line ; do
    cp -a $line ${line}.bbk
    rm $line
    mv ${line}.bbk ${line}
done < /tmp/$$.templist

rm -rf /tmp/$$.templist

echo
echo "Decrypt End !"
date
echo
