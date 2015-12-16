#!/bin/bash
#
# start ssh-agent and use ssh-add to  add my rsa 
#
# Usage:  source  sshconfig.sh   
# It's will run in current shell.
#

echo "Start ssh agent..."
eval `ssh-agent -s`
echo 
echo "add my rsa..."
ssh-add ~/.ssh/*_rsa
echo

ssh-add -l 
echo "It's done."

