#!/bin/bash

#TODO: Need to salt this file
#TODO: Need to change this to variable comming from Pillar
NSSDB_PASS='IloveSPS1212'

###########################################################################

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


echo "${TXTRED}Installing TestCA${TXTRST}"

echo "$NSSDB_PASS" > /tmp/newpwd

certutil -A -n "IC DIA CA3" -i "/srv/salt/admin/pki/installTestTrustAnchors/testCA/IC_DIA_CA3.cer" -t "CT,C,C" -d /etc/pki/nssdb -f /tmp/newpwd > /dev/null
certutil -A -n "IC PKI ROOT 2" -i "/srv/salt/admin/pki/installTestTrustAnchors/testCA/IC_PKI_ROOT_2.cer" -t "CT,C,C" -d /etc/pki/nssdb -f /tmp/newpwd > /dev/null

echo "${TXTRED}Installing TestCA complete${TXTRST}"

# creating seed file which is used by the nssdb when generating the self-signed certificate. Don't change the 55 value.
openssl rand -base64 55 > /tmp/noise

#generating self signed ssl cert so httpd starts
if [[ $(certutil -L -d /etc/pki/nssdb | grep cseweb) ]]; then
    echo "cseweb installed"
else
    echo "installing cseweb self-signed cert"
		certutil -S -k rsa -n cseweb  -t "u,u,u" -x -s "CN=localhost, OU=MYOU, O=MYORG, L=MYCITY, ST=MYSTATE, C=MY" -d /etc/pki/nssdb -f /tmp/newpwd -z /tmp/noise
fi
