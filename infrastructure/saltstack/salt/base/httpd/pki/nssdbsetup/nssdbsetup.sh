#!/bin/bash
#
# SYSTEM:
#   CSE Demo
#
# FILE:
#   nssdbsetup.sh
#
# DESCRIPTION:
#   Script to install Apache HTTPD PKI settings
#
#
# OS:
#   Red Hat Enterprise Linux 7.x
#

###########################################################################

#TODO: Need to salt this file

# Set Variables

TIMESTAMP=`date -u +%Y%m%d`
HOSTNAME_SHORT=`hostname -s`
HOSTNAME_FULL=`hostname -f`
DOMAINNAME=`domainname -d`
INSTALL_LOG="/var/log/httpd/nssdb_install/nssdb_install.log"
CURRENTDIR=`dirname $0`
CONFIG=$CURRENTDIR/../../CONFIG
PKI=$CURRENTDIR/../../PKI
#TODO: Need to change this to variable to come from Pillar
NSSDB_PASS='IloveDIA1212'

# Text Color Variables
TXTBLD=$(tput bold)    # Bold
TXTRED=$(tput setaf 1) # Red
TXTGRN=$(tput setaf 2) # Green
TXTBRN=$(tput setaf 3) # Brown
TXTBLU=$(tput setaf 4) # Blue
TXTMAG=$(tput setaf 5) # Magenta
TXTCYN=$(tput setaf 6) # Cyan
TXTGRY=$(tput setaf 7) # Gray
TXTRST=$(tput sgr0)    # Text Reset
TXTHDR=$(tput setaf 2)$(tput setab 4)$(tput bold)  # Header


###########################################################################
# Check to ensure root is executing this script
if [ ! `/usr/bin/whoami` = "root" ]
then
	echo "${TXTRED}You must log in as root before executing this script${TXTRST}"
	exit 1
fi
###########################################################################

echo "${TXTRED}Setting up NSSDB${TXTRST}"

if [ -d  /etc/pki/nssdb/ ]; then
  echo "/etc/pki/nssdb/ exists"
else
	mkdir /etc/pki/nssdb/
fi

if [[ $(modutil -force -create -dbdir /etc/pki/nssdb/ | grep exists) ]]; then
		echo "/etc/pki/nssdb/ exists"
else
    echo "creating nssdb folder "
		modutil -force -create -dbdir /etc/pki/nssdb/
    echo "Forcing FIPS mode "
		modutil -force -fips true -dbdir /etc/pki/nssdb
fi

# Change password. By Default when NSSDB was created the password was not set
# When operating in FIPS enforement mode the NSSDB password must be set
# echo "" > /tmp/oldpwd is used to capture the emtpy password in a temp file and then using the modutil command below we set the new password
# If you run this script more than once you may get an error because the NSSDB password was set already to the value of "$NSSDB_PASS".
# So if you see a "ERROR: Incorrect password." after the first time you run this script this is normal
echo "" > /tmp/oldpwd
#FIPS compliant password must be 14 charaters long, upper and lower case and special characters
echo "$NSSDB_PASS" > /tmp/newpwd
modutil -force -changepw "NSS FIPS 140-2 Certificate DB" -pwfile /tmp/oldpwd -newpwfile /tmp/newpwd -dbdir /etc/pki/nssdb

# setting permissions and ownership
chmod 770 /etc/pki/nssdb
chmod 660 /etc/pki/nssdb/*
chgrp apache /etc/pki/nssdb
chgrp apache /etc/pki/nssdb/*

echo "${TXTRED}Setting up NSSDB complete${TXTRST}"
