#!/bin/bash -eux

#PROFILE_FILE="/home/aemdesign/.bash_profile"
#VIRTUALENV_HOME="/home/aemdesign/.virtualenvs"

#touch $PROFILE_FILE

#sudo su -
#yum -y install epel-release python-setuptools python-pip
#
#echo "Curl status:"
#curl -V
#
#pip install --upgrade pip
#
#echo "Install pycurl with openssl using libcurl with openssl"
#export PYCURL_SSL_LIBRARY=openssl
#pip install pycurl
#
#echo "Pycurl status"
#python -c 'import pycurl; print(pycurl.version)'


#python -m easy_install virtualenv virtualenvwrapper workon
#
#
#WHICH_PYTHON="$(which python 2>/dev/null)"
#DEFAULT_VIRTUALENV="$(which virtualenv 2>/dev/null)"
#DEFAULT_VIRTUALENVWRAPPER="$(find /usr -name virtualenvwrapper.sh | head -n 1)"
#WHICH_VIRTUALENV="$(which virtualenv 2>/dev/null)"
#WHICH_PROFILE="$PROFILE_FILE"
#WHICH_VIRTUALENVWRAPPER="$(find /usr -name virtualenvwrapper.sh | head -n 1)"
#WHICH_VIRTUALENV_HOME="$VIRTUALENV_HOME"
#
#echo "export WORKON_HOME=$WHICH_VIRTUALENV_HOME">>$WHICH_PROFILE
#echo "export VIRTUALENVWRAPPER_PYTHON=$WHICH_PYTHON">>$WHICH_PROFILE
#echo "export VIRTUALENVWRAPPER_VIRTUALENV=$WHICH_VIRTUALENV">>$WHICH_PROFILE
#echo "export VIRTUALENVWRAPPER=$WHICH_VIRTUALENVWRAPPER">>$WHICH_PROFILE
#echo "source \$VIRTUALENVWRAPPER">>$WHICH_PROFILE

##INSTALL PYTHON 3.6
#
## Compilers and related tools:
#yum groupinstall -y "development tools"
## Libraries needed during compilation to enable all features of Python:
#yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel expat-devel
## If you are on a clean "minimal" install of CentOS you also need the wget tool:
#yum install -y wget
#
#PYSHORT=3.6 # The Python short version, e.g. easy_install-${PYSHORT} = easy_install-3.6
#PYTHONVER=3.6.1 # The actual version of python that you want to download from python.org
#
#wget http://python.org/ftp/python/${PYTHONVER}/Python-${PYTHONVER}.tar.xz
#tar xf Python-${PYTHONVER}.tar.xz
#cd Python-${PYTHONVER}
#./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
#make && make altinstall
#
## First get the script:
#wget https://bootstrap.pypa.io/get-pip.py
#
#python3.6 get-pip.py
