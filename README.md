# install-files
some bash files to facilitate upgrading and installing compilers under Ubuntu (or other debian distributions)

# install directories
This repository was created to aleviate my frustrations with compiler distributions. Rather than searching various directories, these install files move the compiler distributions into the directory /usr/lang.

In the same vain I created a directory tree /usr/app/
apps written in go should be strored in /usr/app/go/application/version

In /usr/lang there will be subdirectories for go, gcc, tinygo etc. 
In /usr/app/go there should be all the golang apps

In each subdirectory there will be version directories

The install file will create symbolic links to the directories where the distribution expects the file to be.

# install_go
The usage is: ./install_go.sh *version*. For example: ./install_go.sh 1.15.7

# install_hugo
The usage is: ./install_hugo.sh *version*. For example: ./install_hugo.sh 0.80.0

# install_musl
install the staticly typed library musl, a version of libc

# cambio 
converts the endings of text files from windows to linux

# myca
a bash file to create a local certificate authority, the ca and localhost certificate and key files, and finally an install file
still need to test the procedure.
also need to add test programs. testing is each step is super important, since the error messages from openssl are sometimes obtuse. 
