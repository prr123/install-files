# install-files
some bash files to facilitate upgrading and installing compilers under Ubuntu (or other debian distributions)

# install directories
This repository was created to aleviate my frustrations with compiler distributions. Rather than searching various directories, these install files move the compiler distributions into the directory /usr/lang.

In /user/lang there will be subdirectories for go, gcc, tinygo etc. 

In each subdirectory there will be version directories

The install file will create symbolic links to the directories where the distribution expects the file to be.

# install_go
The usage is: ./install_go.sh *version*. For example: ./install_go.sh 1.15.7
