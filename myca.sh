#!/bin/bash
# Usage: myca cmd
# Purpose: install files for a local ca
# Author: PRR
# Date 17/3/2021
#
#----------------------------------------------------------------------------
cmd=$1
if [ -z $cmd ]; then
	echo "error no command provided!"
	echo "usage: myca command ca_directory_name!"
	echo "commands are: create, delete!"
	exit 1
fi
if [[ "$cmd" != "create" && "$cmd" != "delete" ]]; then
	echo "invalid command!"
	echo "valid commands are: create and delete!"
	exit 1
fi
dirnam=$2
if [ -z $dirnam ]; then
	echo "error no ca directory name provided!"
	echo "usage: myca command ca_directory_name!"
	echo "commands are: create, delete!"
	exit 1
fi
# change directory
cd ~/
if [[ "$cmd" == "delete" ]]; then

	if [[ ! -d "$dirnam" ]]; then
		echo "cannot delete direectory: $dirnam"
		echo "directory $dirnam does not exist!"
		exit 1
	fi
	if [[ ! -d "$dirnam/signedcerts" ]]; then
		echo "cannot delete $dirnam"
		echo "directory $dirnam does not contain subdirectories!"
		exit 1
	fi
	while true; do
    	read -p "Are you sure that you want to delete the directory $dirnam? " yn
    	case $yn in
        	[Y]* ) break;;
        	[Nn]* ) exit;;
        	* ) echo "Please answer yes or no.";;
    	esac
	done
	echo "deleting $dirnam"
	rm -r $dirnam
	exit 0
fi

if [[ -d $dirname && "$cmd" == "create" ]]; then
	echo "$dirname alredy exists!"
	echo "cannot create directory that already exists!"
	exit 1
fi

cd ~/ && mkdir $dirnam && mkdir -p $dirnam/signedcerts && mkdir $dirnam/private && mkdir $dirnam/db

cd ~/$dirnam/db
echo '01' > serial && touch index.txt
cd ~/$dirnam
touch sample_caconfig.cnf
# create the file
echo "#Sample caconfig.cnf file" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "[ ca ]" >> sample_caconfig.cnf
#sed -i '$ a default_ca = local_ca' sample_caconfig.cnf
echo "default_ca = local_ca" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "# Default location of directories and files" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "[ local_ca ]" >> sample_caconfig.cnf
echo "dir = $HOME/$dirnam" >> sample_caconfig.cnf
echo "certificate = \$dir/cacert.pem" >> sample_caconfig.cnf
echo "database = \$dir/db/index.txt" >> sample_caconfig.cnf
echo "new_certs_dir = \$dir/signedcerts" >> sample_caconfig.cnf
echo "private_key = \$dir/private/cakey.pem" >> sample_caconfig.cnf
echo "serial = \$dir/db/serial" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "# Default expiration" >> sample_caconfig.cnf
echo "default_crl_days = 365" >> sample_caconfig.cnf
echo "default_days = 1825" >> sample_caconfig.cnf
echo "default_md = sha256" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "policy = local_ca_policy" >> sample_caconfig.cnf
echo "x509_extensions = local_ca_extensions" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "# Copy extensions specified in the certificate request" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "copy_extensions = copy" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "unique_subject = no" >> sample_caconfig.cnf
echo "email_in_dn = no" >> sample_caconfig.cnf
echo "rand_serial = no" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "# Default Policy to use when generating server certificates." >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "[ local_ca_policy ]" >> sample_caconfig.cnf
echo "commonName = supplied" >> sample_caconfig.cnf
echo "stateOrProvinceName = supplied" >> sample_caconfig.cnf
echo "countryName = supplied" >> sample_caconfig.cnf
echo "emailAddress = supplied" >> sample_caconfig.cnf
echo "organizationName = supplied" >> sample_caconfig.cnf
echo "organizationalUnitName = supplied" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "# x509 extensions to use when generating server certificates" >> sample_caconfig.cnf
echo "[ local_c_extensions ]" >> sample_caconfig.cnf
echo "basicConstraints = CA:false" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "# The default root certificate generation policy" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "[ req ]" >> sample_caconfig.cnf
echo "default_bits = 2048" >> sample_caconfig.cnf
echo "default_keyfile = $HOME/$dirnam/private/cakey.pem" >> sample_caconfig.cnf
echo "default_md = sha256" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "prompt = no" >> sample_caconfig.cnf
echo "distinguished_name = root_ca_distinguished_name" >> sample_caconfig.cnf
echo "x509_extensions = root_ca_extensions" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "# Root Certificate Authority distinguished name" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "[ root_ca_distinguished_name ]" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "commonName = Azul Root Certificate Authority" >> sample_caconfig.cnf
echo "stateOrProvinceName = Va" >> sample_caconfig.cnf
echo "countryName = ES" >> sample_caconfig.cnf
echo "emailAddress = priemen@gmail.com" >> sample_caconfig.cnf
echo "organizationName = Azul Software" >> sample_caconfig.cnf
echo "organizationalUnitName = Development" >> sample_caconfig.cnf
echo "#" >> sample_caconfig.cnf
echo "[ root_ca_extensions ]" >> sample_caconfig.cnf
echo "basicConstraints = CA:true" >> sample_caconfig.cnf
#echo "#" >> sample_caconfig.cnf
echo "***************************************************************"
echo  "created sample_caconfig.cnf file!"
echo "***************************************************************"
#
touch gencert.sh
echo "#!/bin/bash" >> gencert.sh
echo "# Purpose: install files for a local ca" >> gencert.sh
echo "# Author: PRR" >> gencert.sh
echo "# Date 17/3/2021" >> gencert.sh
echo "#" >> gencert.sh
echo "#----------------------------------------------------------------------" >> gencert.sh
wdir=${PWD##*/}
echo "working directory: $wdir"
echo "export OPENSSL_CONF=$wdir/caconfig.cnf" >> gencert.sh
echo "openssl req -x509 -newkey rsa:2048 -out cacert.pem -outform PEM -days 1825" >> gencert.sh
echo "#" >> gencert.sh
echo "openssl x509 -in cacert.pem -out cacert.crt"  >> gencert.sh
#
touch localhost.cnf
echo "#" >> localhost.cnf
echo "# localhost.cnf" >> localhost.cnf
echo "#" >> localhost.cnf
echo "[ req ]" >> localhost.cnf
echo "prompt = no" >> localhost.cnf
echo "distinguished_name = server_distinguished_name" >> localhost.cnf
echo "req_extensions = v3_req" >> localhost.cnf
echo "" >> localhost.cnf
echo "[ server_distinguished_name ]" >> localhost.cnf
echo "commonName = localhost" >> localhost.cnf
echo "stateOrProvinceName = Valencia" >> localhost.cnf
echo "countryName = ES" >> localhost.cnf
echo "emailAddress = priemen@gmail.com" >> localhost.cnf
echo "organizationName = Azul" >> localhost.cnf
echo "organizationalUnitName = Development" >> localhost.cnf
echo "" >> localhost.cnf
echo "[ v3_req ]" >> localhost.cnf
echo "basicConstraints = CA:false" >> localhost.cnf
echo "keyUsage = nonRepudiation, digitalSignature, keyEncipherment" >> localhost.cnf
echo "subjectAltName = @alt_names" >> localhost.cnf
echo "" >> localhost.cnf
echo "[ alt_names ]" >> localhost.cnf
echo "DNS.0 = localhost" >> localhost.cnf
echo "DNS.1 = 127.0.0.1" >> localhost.cnf

exit 0

