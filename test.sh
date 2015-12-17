#!/bin/bash

myName="leo"

function func()
{
  if [ ! "" == "$1" ] 
  then 
    echo "\$1 is $1" 
  else 
    echo "value is null"
  fi
}

echo "Start to test" 
echo "func "
func 

echo ""
echo "func haha"
func haha

echo "Test is end"
