#!/bin/bash
###################################################################
# Last update: 21-OKT-2017
# Description:
# use ca-root key (ca.key.pem) to create root cert. (ca.cert.pem)
#
#ca
#├── ca_certs
#│   ├── ca.cert.crt
#│   └── ca.cert.pem
#├── crl
#├── index.txt
#├── newcerts
#├── openssl.cnf
#├── private
#│   └── ca.key.pem
#├── serial
#└── server_certs
#    ├── certs
#    ├── csr
#    └── private
###################################################################
SCRIPTNAME=`basename $0`;
SCRIPTDIR=`dirname $0` ;
HOME=`pwd`
ROOTCA_DIR=ca;

echo -e "######## $SCRIPTNAME started...\n";

if [ ! -f $HOME/ca.config ]
then
	echo "$SCRIPTNAME: Config file ca.config not found"
	exit 1
fi
. $HOME/ca.config

cd $ROOTCA_DIR

if [ -f "ca_certs/ca.cert.pem" ]
then
	echo "$SCRIPTNAME WARNING: $ROOTCA_DIR/certs/ca.cert.pem already exists"
	exit 0
fi

subjROOTCA="/CN=$CA_COMMON_NAME/O=$ORGANISATION/OU=$ORGANISATION_UNIT/C=$CA_COUNTRY_CODE/L=$ORGANISATION_CITY/ST=$ORGANISATION_STREET";

openssl req -config $HOME/openssl.cnf \
      -key private/ca.key.pem \
	  -subj "$subjROOTCA" \
      -new -x509 -days 7300 -sha256 -extensions v3_ca \
      -out ca_certs/ca.cert.pem
if [ $? -ne 0 ]
then
	"$SCRIPTNAME: error openssl req"
fi


# Convert PEM to CRT format (required for ca-certificates update in Ubuntu)
openssl x509 -in ca_certs/ca.cert.pem  -out ca_certs/ca.cert.crt

chmod 444 ca_certs/ca.cert.pem ca_certs/ca.cert.crt

# Print the certificate
openssl x509 -noout -text -in ca_certs/ca.cert.pem
