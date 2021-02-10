#!/bin/bash
# Usage: install_hugo version
# Purpose: install the hugo package
# Author: PRR
# Date: 10/2/2021
# derived from install_go.sh
#
#
#----------------------------------------------------------

function hugoinstall() {
cd /usr/app/go/hugo/$ver

echo "distribution file: $1"

distfil="hugo_${ver}_Linux-64bit.deb"
if [[ -f $distfil ]]; then
	echo "file $1 already downloaded"
else
#	echo "downloading file: $1"
#	DL="https://golang.org/dl/go$ver.linux-amd64.tar.gz"
#	echo "downloading $DL"
	sudo wget $1
	if [ $? -ne 0 ]; then
		echo "error retrieving hugo file!"
		exit 1
	fi
fi

#extract
echo "*******************************************************************************"
echo "extracting go files!"
sudo dpkg -i hugo*.deb
if [ $? -ne 0 ]; then
	echo "error extracting go files!"
	exit 1
fi
sudo mv /usr/local/bin/hugo /usr/app/go/hugo/$ver/
echo "*******************************************************************************"

# create logical link to new go installation
echo "*******************************************************************************"
linkfil="/usr/local/bin/hugo"
echo "creating symbolic link: $linkfil"
if [[ -L $linkfil ]]; then
    echo "hugo link exists! updating"
	sudo rm $linkfil
else
    echo "no link exists!"
fi
sudo ln -s /usr/app/go/hugo/$ver/hugo $linkfil
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
	echo "usage: install_hugo version!"
	exit 1
fi

subver=${ver##*.}
mver=${ver%.*}

echo "attempting to install hugo version $ver [$mver $subver]"

DLF="https://github.com/gohugoio/hugo/releases/download/v$ver/hugo_${ver}_Linux-64bit.deb"
# DLF="https://dl.google.com/go/go$ver.linux-amd64.tar.gz"

echo "check whether go distribution file exists: $DLF"
wgetout=$(wget -S --spider $DLF  2>&1)
# echo $wgetout

if [[ "$wgetout" != *"200 OK"* ]]; then
	echo "file not found exiting!"
	exit 1
fi

echo "distribution file exists; proceeding!"


echo "*******************************************************************************"
echo "creating directories for hugo $ver"

# check existing versions

if [ ! -d /usr/local/bin ]; then
	echo "*******************************************************************************"
	echo "directory /usr/local/bin does not exist. Exiting!"
echo "*******************************************************************************"
fi

link="/usr/local/bin/hugo"
tarstr="/usr/app/go/hugo/$ver"
# echo "target: $tarstr"

#	if [ -f /usr/lang/go/$ver/go$ver.linux-amd64.tar.gz ]; then

if [ -d /usr/app/go/hugo/$ver ]; then
	echo "found existing directory for go version $ver!"
	if [[ -L $link ]]; then
#		echo "link exists: $link"
		linkfil=$(readlink -f $link)
	fi
	echo "link $link points to: $linkfil"
	if [[ $linkfil = $tarstr ]]; then
		echo "*******************************************************************************"
		echo "hugo $ver is already installed! "
		echo "exiting installation!"
		echo "*******************************************************************************"
		exit 0
	fi
else
	echo "*******************************************************************************"
	echo "directory /usr/app/go/hugo/$ver does not exist. creating dir"
	sudo mkdir /usr/app/go/hugo/$ver
	if [ $? -ne 0 ]; then
		echo "error could not create directory /usr/app/go/hugo/$ver! exiting"
		echo "*******************************************************************************"
		exit 1
	fi
	echo "successfully created directory /usr/app/go/hugo/$ver"
	echo "*******************************************************************************"
fi

echo "proceeding with installing hugo version $ver [$mver $subver]"
echo "*******************************************************************************"

hugoinstall $DLF
if [ $? -eq 0 ]; then
	echo "successfully installed hugo version $ver"
else
	echo "error could not install hugo version $ver"
fi
