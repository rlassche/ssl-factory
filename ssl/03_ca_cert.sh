#!/bin/bash
###################################################################
# Last update: 21-OKT-2017
# Description:
# use root key (ca.key.pem) to create root cert. (ca.cert.pem)
###################################################################
SCRIPTNAME=`basename $0`;
SCRIPTDIR=`dirname $0` ;
HOME=`pwd`
ROOTCA_DIR=ca;
if [ ! -f $HOME/ca.config ]
then
	echo "$SCRIPTNAME: Config file ca.config not found"
	exit 1
fi
. $HOME/ca.config
#while getopts ":h::s:" opt; do
#	case $opt in
#	s) 
#		SUBJ=$OPTARG
#		#echo "SUBJ $SUBJ" 
#	;;
#	\?) echo "$SCRIPTNAME: Invalid option: -$OPTARG"
#	;;
#	esac
#done

cd $ROOTCA_DIR

if [ -f certs/ca.cert.pem ]
then
	echo "$SCRIPTNAME WARNING: $ROOTCA_DIR/certs/ca.cert.pem already exists"
	exit 0
fi

#subjROOTCA="/CN=Alice Ltd Root CA/C=GB/ST=England";
#subjROOTCA+="/O=Alice Ltd/OU=Alice Ltd Certificate Authority"
subjROOTCA="/CN=$CA_COMMON_NAME/O=$ORGANISATION/OU=$ORGANISATION_UNIT/C=$CA_COUNTRY_CODE/L=$ORGANISATION_CITY/ST=$ORGANISATION_STREET";

echo "$subjROOTCA\n";

echo "Generate ca_certs/ca.cert.pem"
pwd

openssl req -config $HOME/openssl.cnf \
      -key private/ca.key.pem \
	  -subj "$subjROOTCA" \
      -new -x509 -days 7300 -sha256 -extensions v3_ca \
      -out ca_certs/ca.cert.pem
if [ $? -ne 0 ]
then
	"$SCRIPTNAME: error openssl req"
fi
chmod 444 ca_certs/ca.cert.pem

openssl x509 -noout -text -in ca_certs/ca.cert.pem
