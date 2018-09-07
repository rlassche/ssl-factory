#!/bin/bash
###################################################################
# Last update: 07-SEP-2018
# Description:
#	Create a certificate with the intermediate CA
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
cd $ROOTCA_DIR

# add altnames 
#cp $HOME/openssl.cnf $HOME/opensslSRV.cnf
#cat <<! >> $HOME/opensslSRV.cnf
#
#[alt_names]
#DNS.1=$SERVER_COMMON_NAME
#DNS.2=www.$SERVER_COMMON_NAME
#!

openssl ca -config $HOME/openssl.cnf \
      -extensions server_cert -days 375 -notext -md sha256 \
      -in server_certs/csr/${SERVER_COMMON_NAME}.csr.pem \
      -out server_certs/certs/${SERVER_COMMON_NAME}.cert.pem \
	  -batch
if [ $? -ne 0 ]
then
	rm server_certs/certs/${SERVER_COMMON_NAME}.cert.pem
	error "error: ca ... "
fi

# Convert PEM to CRT format
openssl x509 -in server_certs/certs/${SERVER_COMMON_NAME}.cert.pem  -out server_certs/certs/${SERVER_COMMON_NAME}.cert.crt

chmod 444 server_certs/certs/${SERVER_COMMON_NAME}.cert.pem
