#!/bin/bash
# download code and to make whole project
# Information of checkout will save to "co_info". 
# If make is need, the information of that will save to "mk_info".
#
# file name: checkout.sh 
# Usage: 
#   1. $./checkout.sh    # run file directly without parameter, you need set the value in the file.
#   2. $./checkout.sh address_of_code   # use new address of code and don't make.
#   3. $./checkout.sh address_of_code project_name yes  # use new address of code, project of name and make whole project 
#  

# default address of code 
codeAddress="svn://172.16.70.210/MT6582/KK1/V2.11/alps"

# set new address of code to first para in command
[ $# -ge 1 ] && codeAddress=$1 

# default project name 
projectName="allview82_3821"

# set new project name to second para in command
[ $# -ge 2 ] && projectName=$2 

# default don't make
domake="no"

# set domake to third para in command
[ $# -ge 3 ] && domake=$3 

echo 'Start to checkout' >> co_info
date >> co_info
echo "Address of code is ${codeAddress}." >> co_info
svn co ${codeAddress}  --username miki  --password miki123 --no-auth-cache --non-interactive  >> co_info  2>&1 

# if svn error, then exit
if [ $? != 0 ] 
then 
  echo >> co_info
  echo "process exit" >> co_info
  exit 1 
fi

date >> co_info 
echo >> co_info 
echo 'Checkout Succeed.' >> co_info
echo "Project is ${projectName}." >> co_info
echo >> co_info

if [ -d "alps" ] 
then 
  cd alps
  date >> mk_info

  if [ "${domake}" == "yes" ] 
  then
    ./mk ${projectName} n >> mk_info 2>&1 
  else
	echo "Don't make anything." >> mk_info
  fi
else 
  echo "the directory 'alps' not exist." >> co_info
  exit 2
fi 
