#!/bin/bash
# Usage: install_go version
# Purpose: install the go language
# Author: PRR
# Date: 1/7/2020
# 4/2/2021  add version majojor version categegory
# added check to see the file exists
#
#----------------------------------------------------------

function goinstall() {
cd /usr/lang/go/$ver

echo "distribution file: $1"

distfil="go$ver.linux-amd64.tar.gz"
if [[ -f $distfil ]]; then
	echo "file $1 already downloaded"
else
	echo "downloading file: $1"
	DL="https://golang.org/dl/go$ver.linux-amd64.tar.gz"
	echo "downloading $DL"
	sudo wget $1
	if [ $? -ne 0 ]; then
		echo "error retrieving go files!"
		exit 1
	fi
fi

#extract
echo "*******************************************************************************"
echo "extracting go files!"
sudo tar -xvzf go$ver.linux-amd64.tar.gz
if [ $? -ne 0 ]; then
	echo "error extracting go files!"
	exit 1
fi

echo "*******************************************************************************"
echo " moving go files!"
sudo mv /usr/lang/go/$ver/go/* /usr/lang/go/$ver/
if [ $? -ne 0 ]; then
	echo "error moving go files!"
	exit 1
fi

sudo rmdir /usr/lang/go/$ver/go
if [ $? -ne 0 ]; then
	echo "error could not remove go subdirectory from /usr/lang/go/$ver!"
	exit 1
fi

# create logical link to new go installation
echo "*******************************************************************************"
linkfil="/usr/local/bin/go"
echo "creating symbolic link: $linkfil"
if [[ -L $linkfil ]]; then
    echo "go link exists! updating"
	sudo rm $linkfil
else
    echo "no link exists!"
fi
sudo ln -s /usr/lang/go/$ver/bin/go $linkfil
if [ $? -ne 0 ]; then
	echo "error creating logical link!"
	exit 1
fi
echo "created link successfull!"
echo "*******************************************************************************"
}

function check_go_files() {

#config files
echo "*******************************************************************************"
echo "config files:"
ls -l /etc/postgresql/10/main

#scripts & executables
echo "*******************************************************************************"
echo "scripts & executables"
ls -l /usr/lib/postgresql/10/bin

echo "*******************************************************************************"
echo "temporary files"
ls -l /var/run/postgresql

echo "*******************************************************************************"
echo "folders"
ls -l /var/lib/postgresql/10/main
}

function get_version() {
echo "*******************************************************************************"
}


# main program

ver=$1
if [ -z $ver ]; then
	echo "error missing version!"
	echo "usage: install_go version!"
	exit 1
fi

subver=${ver##*.}
mver=${ver%.*}

echo "attempting to install go version $mver $subver"

DLF="https://dl.google.com/go/go$ver.linux-amd64.tar.gz"

echo "check whether go distribution file exists: $DLF"
wgetout=$(wget -S --spider $DLF  2>&1)
# echo $wgetout

if [[ "$wgetout" != *"200 OK"* ]]; then
	echo "file not found exiting!"
	exit 1
fi

echo "distribution file exists; proceeding!"


echo "*******************************************************************************"
echo "creating directories for go $ver"

# check existing versions

if [ ! -d /usr/lang ]; then
	echo "*******************************************************************************"
	echo "directory /usr/lang does not exist. creating dir"
	sudo mkdir /usr/lang
	if [ $? -ne 0 ]; then
		echo "error could not create directory /usr/lang! exiting"
		echo "*******************************************************************************"
		exit 1
	fi
	echo "successfully created directory /usr/lang"
echo "*******************************************************************************"
fi

if [ ! -d /usr/lang/go ]; then
	echo "*******************************************************************************"
	echo "directory /usr/lang/go does not exist. creating dir"
	sudo mkdir /usr/lang/go
	if [ $? -ne 0 ]; then
		echo "error could not create directory /usr/lang/go! exiting"
		echo "*******************************************************************************"
		exit 1
	fi
	echo "successfully created directory /usr/lang/go"
echo "*******************************************************************************"
fi

link="/usr/local/bin/go"
tarstr="/usr/lang/go/$ver/bin/go"
# echo "target: $tarstr"

#	if [ -f /usr/lang/go/$ver/go$ver.linux-amd64.tar.gz ]; then

if [ -d /usr/lang/go/$ver ]; then
	echo "found existing directory for go version $ver!"
	if [[ -L $link ]]; then
#		echo "link exists: $link"
		linkfil=$(readlink -f $link)
	fi
	echo "link $link points to: $linkfil"
	if [[ $linkfil = $tarstr ]]; then
		echo "*******************************************************************************"
		echo "go $ver is already installed! "
		echo "exiting installation!"
		echo "*******************************************************************************"
		exit 0
	fi
else
	echo "*******************************************************************************"
	echo "directory /usr/lang/go/$ver does not exist. creating dir"
	sudo mkdir /usr/lang/go/$ver
	if [ $? -ne 0 ]; then
		echo "error could not create directory /usr/lang/go/$ver! exiting"
		echo "*******************************************************************************"
		exit 1
	fi
	echo "successfully created directory /usr/lang/go/$ver"
	echo "*******************************************************************************"
fi

echo "proceeding with installing go version $mver $subver"
echo "*******************************************************************************"

goinstall $DLF
if [ $? -eq 0 ]; then
	echo "successfully installed go version $ver"
else
	echo "error could not install go version $ver"
fi
