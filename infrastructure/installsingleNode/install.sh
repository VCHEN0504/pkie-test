#!/bin/bash
# DESCRIPTION:
#   Installs salt master and salt minion in an Internet-facing node

###########################################################################

# Set Variables
SALT_MASTER=`hostname`

# Text Color Constants
TXTBLD=$(tput bold)    # Bold
TXTRED=$(tput setaf 1) # Red
TXTGRN=$(tput setaf 2) # Green
TXTBLU=$(tput setaf 4) # Blue
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

echo "${TXTBLU}Installing Salt ${TXTRST}"

# Install salt repo from saltstack
yum -y install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
# Install salt master
yum -y install salt-master

#TODO: Create the GPG key for encrypting Pillar elements

# Enable service to start automatically after a node reboot
systemctl enable salt-master

# Install salt-minion
yum -y install salt-minion

# Tell the minion where the salt master is.
sed -i "s/^#*master:.*$/master: $SALT_MASTER/" /etc/salt/minion

# Auto accept minion keys
sed -i "s/^#*auto_accept:.*$/auto_accept: True/" /etc/salt/master

# Uncomment pillar roots section
# This section is commented out because we need to find a better way to uncomment the
# sections relevant to the pillar section. Each salt update the row numbers change.
#sed -i '694 s/^#//g' /etc/salt/master
#sed -i '695 s/^#//g' /etc/salt/master
#sed -i '696 s/^#//g' /etc/salt/master

# Enable service to start automatically after a node reboot
systemctl enable salt-minion

# Start salt-master service
service salt-master start

# Start salt-minion
service salt-minion start

echo "${TXTBLU}Installing Salt Complete${TXTRST}"
