#!/bin/bash
###################################################################
# Last update: 07-SEP-2018
# Description:
#	Clean server certificates. (and then re-create them)
# 	Leave the CA info as it is!
###################################################################
#
# ca
# ├── ca_certs
# │   ├── ca.cert.crt
# │   └── ca.cert.pem
# ├── crl
# ├── index.txt
# ├── index.txt.attr
# ├── index.txt.old
# ├── newcerts
# │   └── 1000.pem
# ├── openssl.cnf
# ├── private
# │   └── ca.key.pem
# ├── serial
# ├── serial.old
# └── server_certs
#     ├── certs
#     │   ├── srv_rotterdam01.local.cert.crt
#     │   └── srv_rotterdam01.local.cert.pem
#     ├── csr
#     │   └── srv_rotterdam01.local.csr.pem
#     └── private
#         └── srv_rotterdam01.local.key.pem
# 
####################################################################################
SCRIPTNAME=`basename $0`;
SCRIPTDIR=`dirname $0` ;
HOME=`pwd`
ROOTCA_DIR=ca;

while getopts "c:" opt; do
	case $opt in
	c) 
		SERVER_CONFIG=$OPTARG
		;;
	\?) echo "$SCRIPTNAME ERROR: Invalid option: -$OPTARG"
		;;
	esac
done


if [ ! -f "${SERVER_CONFIG}" ]
then
	echo "$SCRIPTNAME ERROR: Server config file $SERVER_CONFIG missing (-c option) $!";
	exit 2
fi

. $HOME/${SERVER_CONFIG}

if [ ! -f $HOME/ca.config ]
then
	echo "Config file ca.config not found"
	exit 1
fi
. $HOME/ca.config

if [ ! -d ca ]
then
	echo "ssl-factory needs to be setup"
	exit 2
fi

# Remove cert in the newcerts directory from index.txt file
CERT_ID=`grep "/CN=${SERVER_COMMON_NAME}" ca/index.txt | awk '{ print $3 }'`
rm -f ca/newcerts/${CERT_ID}.pem

# Remove client email certificates
sed -e "/CN=.*@${SERVER_COMMON_NAME}/d" ca/index.txt > /tmp/$$

rm -f ca/email_certs/${SERVER_COMMON_NAME}/*

# Remove server from index.txt file
sed -e "/CN=${SERVER_COMMON_NAME}/d" /tmp/$$  > ca/index.txt

rm -f ca/server_certs/certs/${SERVER_COMMON_NAME}*
rm -f ca/server_certs/private/${SERVER_COMMON_NAME}*
rm -f ca/server_certs/csr/${SERVER_COMMON_NAME}*

rm -f ca/server_certs/openssl.${SERVER_COMMON_NAME}.cnf


echo "Removed certificates for ${SERVER_COMMON_NAME}";
exit 0;
