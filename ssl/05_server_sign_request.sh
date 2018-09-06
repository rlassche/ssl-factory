#!/bin/bash
###################################################################
# Last update: 06-SEP-2018
# Description:
#	Sign server and client certificates
###################################################################
SCRIPTNAME=`basename $0`;
SCRIPTDIR=`dirname $0` ;
HOME=`pwd`
ROOTCA_DIR=ca;

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
. $HOME/${SERVER_CONFIG}

cd $ROOTCA_DIR



if [ -f server_certs/csr/${SERVER_COMMON_NAME}.csr.pem ]
then
	echo "$SCRIPTNAME WARNING: File server_certs/csr/${SERVER_COMMON_NAME}.csr.pem already exists"
	exit 3;
fi

# add altnames 
cp $HOME/openssl.cnf $HOME/opensslSRV.cnf
cat <<! >> $HOME/opensslSRV.cnf

[alt_names]
DNS.1=$SERVER_COMMON_NAME
DNS.2=www.$SERVER_COMMON_NAME
!

#subjSERVER="/C=NL/ST=Haverstraat 2/L=Nieuw-Vennep/O=Snoeks/OU=IT Department/CN=linux.snoeksautomotive.com"

#subjSERVER="/C=NL/ST=Haverstraat 2/L=Nieuw-Vennep/O=Snoeks/OU=IT Department/CN=linux.snoeksautomotive.com"
subjSERVER="/C=$SERVER_COUNTRY_CODE/ST=$ORGANISATION_STREET/L=$ORGANISATION_CITY/O=$ORGANISATION/OU=$ORGANISATION_UNIT/CN=$SERVER_COMMON_NAME";
echo "Subject: $subjSERVER";

echo "Generate file server_certs/csr/${SERVER_COMMON_NAME}.csr.pem "
openssl req -config "${HOME}/opensslSRV.cnf" \
      -key server_certs/private/${SERVER_COMMON_NAME}.key.pem \
	  -subj "$subjSERVER" \
	  -out server_certs/csr/${SERVER_COMMON_NAME}.csr.pem \
      -new -sha256 
if [ $? -ne 0 ]
then
		"error genrsa "
fi
