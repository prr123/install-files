#!/bin/bash
# Usage: cambio file
# Author: PRR
# Date: 17/5/2020
#-------------------------------------------------

# check whether there is a file
filnam=$1
if [ -z $filnam ];  then
	echo "error: no file specified!"
	exit 1
fi
if [[ !$filnam == "*.sh" ]]; then
	echo "not a shell file: $filnam"
	exit 1
fi 
if [[ -f $filnam ]]; then
	sed -i -e 's/\r$//' $filnam
	chmod +x $filnam
	echo "file $filnam modified!"
	else echo "file $filnam does not exist!";
fi
