#!/bin/bash -eux

sudo su -

#install python tools
yum -y install epel-release python-setuptools python-devel python-pip libffi libffi-devel

#install pip
pip install --upgrade pip

#reinstall curl and libcurl from source

#install dev tools
yum -y groupinstall development

echo "Downloading curl"
wget -O curl.tar.gz http://curl.haxx.se/download/curl-7.54.1.tar.gz && tar -xvzf curl.tar.gz

echo "Installing curl"
cd curl-* && ./configure && make && make install && cd -

echo "Removing old curl and curl-config"
rm -rf /usr/bin/curl /usr/bin/curl-config

echo "Creating links to new curl and curl-config"
ln -s /usr/local/bin/curl /usr/bin/curl
ln -s /usr/local/bin/curl-config /usr/bin/curl-config

echo "Removing old libcurl link"
rm -rf /usr/lib64/libcurl.so /usr/lib64/libcurl.so.4

echo "Creating new libcurl links"
cd /usr/lib64 && \
ln -s /usr/local/lib/libcurl.so libcurl.so && \
ln -s /usr/local/lib/libcurl.so.4 libcurl.so.4 && \
cd -

echo "Removing curl sources"
rm -rf curl*

echo "Upgrade packages dependant on pycurl"
pip install --upgrade --ignore-installed pyudev rtslib-fb

echo "Installing pycurl with openssl"
export PYCURL_SSL_LIBRARY=openssl
pip install --ignore-installed pycurl  #force install latest

echo "Pycurl status"
python -c 'import pycurl; print(pycurl.version)'


echo "Installing ansible and modules" #force install latest
pip install --upgrade --ignore-installed setuptools pycrypto BeautifulSoup4 xmltodict paramiko PyYAML Jinja2 httplib2 boto xmltodict six requests python-consul passlib cryptography appdirs packaging boto ansible 'docker-compose<1.20.0' 'docker<3.0'

echo "Pycurl status"
python -c 'import pycurl; print(pycurl.version)'


echo "Installing pyaem2"
pip install pyaem2

echo "Curl status:"
curl -V

echo "Pycurl status"
python -c 'import pycurl; print(pycurl.version)'

echo "PyAEM2 status"
python -c 'import pyaem2; print(pyaem2.__version__)'
