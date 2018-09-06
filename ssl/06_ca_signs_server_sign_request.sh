#!/bin/bash
###################################################################
# Last update: 21-OKT-2017
# Description:
#	Create a certificate with the intermediate CA
###################################################################
SCRIPTNAME=`basename $0`;
SCRIPTDIR=`dirname $0` ;
HOME=`pwd`
ROOTCA_DIR=ca;

while getopts "c:" opt; do
	case $opt in
	c) 
		SERVER_CONFIG=$OPTARG
		echo "SERVER_CONFIG $SERVER_CONFIG" 
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
echo "1. SERVER_CONFIG=$SERVER_CONFIG";

. $HOME/${SERVER_CONFIG}
echo "SERVER_COMMON_NAME: $SERVER_COMMON_NAME"

if [ ! -f $HOME/ca.config ]
then
	echo "Config file ca.config not found"
	exit 1
fi
. $HOME/ca.config
cd $ROOTCA_DIR
pwd
# add altnames 
cp $HOME/openssl.cnf $HOME/opensslSRV.cnf
cat <<! >> $HOME/opensslSRV.cnf

[alt_names]
DNS.1=$SERVER_COMMON_NAME
DNS.2=www.$SERVER_COMMON_NAME
!

openssl ca -config $HOME/opensslSRV.cnf \
      -extensions server_cert -days 375 -notext -md sha256 \
      -in server_certs/csr/${SERVER_COMMON_NAME}.csr.pem \
      -out server_certs/certs/${SERVER_COMMON_NAME}.cert.pem \
	  -batch
if [ $? -ne 0 ]
then
	rm server_certs/certs/${SERVER_COMMON_NAME}.cert.pem
	error "error: ca ... "
fi

chmod 444 server_certs/certs/${SERVER_COMMON_NAME}.cert.pem


