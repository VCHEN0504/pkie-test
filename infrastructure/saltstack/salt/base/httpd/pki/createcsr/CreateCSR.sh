#!/bin/bash

CURRDATE=`date +"%Y%m%d"`
FQDN=$1
ORG_NAME=$2
RAND_FILE=/tmp/lcanoise
PASS_FILE=/tmp/password

function newRand {
    openssl rand -base64 55 > $RAND_FILE
}

function usage {
	clear
	echo "usage: bash CreateCSR.sh <FQDN (e.g. agency.gov> <ORG_NAME (e.g. DOD)> <NSS DB PASSWRD>"
	echo "done"
}

if [ "$#" -ne 3 ]; then
	usage
else
    cd ~
    echo $3 > $PASS_FILE
    newRand
    certutil -R -s "cn=$FQDN,ou=$ORG_NAME,ou=PKI,ou=DOD,o=U.S. Government,c=US" -o $FQDN.$CURRDATE.req.p10 -g 2048 -d /etc/pki/nssdb/ -f $PASS_FILE -a -z $RAND_FILE
    rm -f $PASS_FILE
    echo "done"
fi
