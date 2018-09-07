#!/bin/bash
###################################################################
# Last update: 07-SEP-2018
# Description:
#	Ship the certificates to the customer
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

# Create a temp-dir
TMP_DIR=`mktemp -d -p $HOME`
if [ ! "$TMP_DIR" ] 
then
	echo "Cannot create temp-dir"
	exit 1;
fi

# Remove the temp-dir 
function cleanup {      
  echo "Deleted temp working directory $TMP_DIR"
  rm -rf "$TMP_DIR"
}

# trap exit, and cleanup the tmp dir
trap cleanup EXIT


# Copy customer certificates to TMP_DIR, tar them
cp ca/ca_certs/* $TMP_DIR
cp ca/server_certs/certs/${SERVER_COMMON_NAME}* $TMP_DIR
cp ca/server_certs/private/${SERVER_COMMON_NAME}* $TMP_DIR

cd $TMP_DIR \
	&& tar cvf /tmp/${SERVER_COMMON_NAME}.tar .

echo "Certificates are in /tmp/${SERVER_COMMON_NAME}.tar"
