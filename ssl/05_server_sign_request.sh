#!/bin/bash
###################################################################
# Last update: 07-SEP-2018
# Description:
#	Sign server and client certificates
###################################################################
# ca
# ├── ca_certs
# │   ├── ca.cert.crt
# │   └── ca.cert.pem
# ├── crl
# ├── index.txt
# ├── newcerts
# ├── openssl.cnf
# ├── private
# │   └── ca.key.pem
# ├── serial
# └── server_certs
#     ├── certs
#     ├── csr
#     │   └── srv_rotterdam01.local.csr.pem
#     └── private
#         └── srv_rotterdam01.local.key.pem
# 
###################################################################
SCRIPTNAME=`basename $0`;
SCRIPTDIR=`dirname $0` ;
HOME=`pwd`
ROOTCA_DIR=ca;

echo -e "######## $SCRIPTNAME started...\n";

if [ ! -f $HOME/ca.config ]
then
	echo "$SCRIPTNAME ERROR: Config file ssl.config not found"
	exit 1
fi
. $HOME/ca.config

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

cd $ROOTCA_DIR

if [ -f server_certs/csr/${SERVER_COMMON_NAME}.csr.pem ]
then
	echo "$SCRIPTNAME WARNING: File server_certs/csr/${SERVER_COMMON_NAME}.csr.pem already exists"
	exit 0;
fi

cat openssl.cnf | sed -e "/^DNS.1=/ s/=\(.*\)/=${SERVER_COMMON_NAME}/" \
					  -e "/^DNS.2=/ s/=\(.*\)/=www.${SERVER_COMMON_NAME}/" \
			> server_certs/openssl.${SERVER_COMMON_NAME}.cnf

subjSERVER="/C=$SERVER_COUNTRY_CODE/ST=$ORGANISATION_STREET/L=$ORGANISATION_CITY/O=$ORGANISATION/OU=$ORGANISATION_UNIT/CN=$SERVER_COMMON_NAME";
echo "Subject: $subjSERVER";

openssl req -config "server_certs/openssl.${SERVER_COMMON_NAME}.cnf" \
      -key server_certs/private/${SERVER_COMMON_NAME}.key.pem \
	  -subj "$subjSERVER" \
	  -out server_certs/csr/${SERVER_COMMON_NAME}.csr.pem \
      -new -sha256 
if [ $? -ne 0 ]
then
		"error genrsa "
fi
