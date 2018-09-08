#!/bin/bash
###################################################################
# Last update: 21-OKT-2017
# Description:
#	Verify the certificate
###################################################################
SCRIPTNAME=`basename $0`;
SCRIPTDIR=`dirname $0` ;
ROOTCA_DIR=ca;
HOME=`pwd`
# A certificate revocation list (CRL) provides a list of certificates that 
# have been revoked. A client application, such as a web browser, can use 
# a CRL to check a server’s authenticity. A server application, such as 
# Apache or OpenVPN, can use a CRL to deny access to clients that are no 
# longer trusted.

# Publish the CRL at a publicly accessible location (eg, 
# http://example.com/intermediate.crl.pem). Third-parties can fetch the 
# CRL from this location to check whether any certificates they rely on 
# have been revoked.
if [ ! -f $HOME/ca.config ]
then
	echo "$SCRIPTNAME ERROR: Config file ssl.config not found"
	exit 1
fi
. $HOME/ca.config
while getopts "e:" opt; do
	case $opt in
	e) 
		EMAIL_CONFIG=$OPTARG
		;;
	\?) echo "$SCRIPTNAME ERROR: Invalid option: -$OPTARG"
	;;
	esac
done

if [ ! -f "${EMAIL_CONFIG}" ]
then
	echo "$SCRIPTNAME ERROR: Email config file $EMAIL_CONFIG missing (-e option) $!";
	exit 2
fi

. ${EMAIL_CONFIG}
echo SERVER_COMMON_NAME=srv_rotterdam01.local

if [ ! -f "ca/server_certs/openssl.${SERVER_COMMON_NAME}.cnf" ]
then
	echo "ERROR: Openssl config file (ca/server_certs/openssl.${SERVER_COMMON_NAME}.cnf) not found. "
fi
echo "ROOTCA_DIR  : $ROOTCA_DIR"

cd $ROOTCA_DIR
pwd
if [ -f server_certs/crl/${SERVER_COMMON_NAME}.crl.pem ]
then
	echo "Server revoke list already exist. (server_certs/crl/crl/${SERVER_COMMON_NAME}.crl.pem)"
	exit 0;
fi

ls -l crlnumber
cat crlnumber
echo -e "************************\n"
pwd
echo -e "************************\n"
openssl ca -config server_certs/openssl.${SERVER_COMMON_NAME}.cnf \
      -gencrl -out server_certs/crl/${SERVER_COMMON_NAME}.crl.pem

# check the contents of the CRL with the crl tool.
openssl crl -in server_certs/crl/${SERVER_COMMON_NAME}.crl.pem -noout -text

# You should re-create the CRL at regular intervals. 
# By default, the CRL expires after 30 days. This is controlled by the 
# default_crl_days option in the [ CA_default ] section.
