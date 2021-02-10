#!/bin/bash
# Usage: install_musl version
# Purpose: download hugo
# Author: PRR
#
#----------------------------------------------------------


ver=$1
if [ -z $ver ]; then
    echo "error missing version!"
    echo "usage: install_musl version!"
    exit 1
fi


echo "attempting to install musl $ver"

DLF="https://git.musl-libc.org/cgit/musl/snapshot/musl-$ver.tar.gz"

echo "check whether go distribution file exists: $DLF"

wgetout=$(wget -S --spider $DLF  2>&1)
# echo $wgetout

if [[ "$wgetout" != *"200 OK"* ]]; then
    echo "file not found exiting!"
    exit 1
fi

echo "distribution file exists; proceeding!"

# check whether file already has been downloaded

dfil="musl-${ver}.tar.gz"

if [[ -f $dfil ]]; then
	echo "MUSL library $ver already exists!"
	exit 1
fi

wget $DLF


