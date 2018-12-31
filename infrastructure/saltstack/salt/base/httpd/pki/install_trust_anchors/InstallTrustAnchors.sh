#!/bin/bash


certPath=""

function usage {
	clear
	echo "usage: bash InstallTrustAnchors.sh <path to certificate> <Trust Anchor Name (e.g DoD Root CA 2>"
	echo "done"
}

if [ "$#" -ne 2 ]; then
	usage
else
	certPath="$1"
    #echo "Please enter the name of the Trust Anchor you are installing (ie, DoD Root CA 2):"
    #read input
	certutil -A -n "$2" -i "$1" -t "CT,C,C" -d /etc/pki/nssdb
	echo "done"
fi
