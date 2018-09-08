#!/bin/bash
###################################################################
# Last update: 29-JUL-2018
# Description:
###################################################################
SCRIPTNAME=`basename $0`;
SCRIPTDIR=`dirname $0` ;
ROOTCA_DIR="ca"
HOME=`pwd`

EMAIL_CONFIG='email_rob@srv_rotterdam01.local.config';
SERVER_CONFIG=srv_rotterdam.config

. $HOME/${EMAIL_CONFIG}
. $HOME/${SERVER_CONFIG}

cd $ROOTCA_DIR

#if [ -f ${INTERMEDIATE}/email_certs/${EMAIL}/${EMAIL}.cert.pem ]
#then
#	echo "$SCRIPTNAME WARNING: File ${INTERMEDIATE}/email_certs/${EMAIL}/${EMAIL}.cert.pem already exists"
#	exit 0
#fi
#
#echo "$SCRIPTNAME: Sign user certificate\n"
## Alice then signs it.
openssl ca -config server_certs/openssl.${SERVER_COMMON_NAME}.cnf \
      -extensions usr_cert -notext -md sha256 \
      -in  "email_certs/${SERVER_COMMON_NAME}/${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}.csr.pem" \
      -out "email_certs/${SERVER_COMMON_NAME}/${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}.cert.pem" \
	  -batch || echo -e "ERROR: openssl signing failed\n";


echo "$SCRIPTNAME: Convert pcs12"


openssl pkcs12 -export  \
		-in    email_certs/${SERVER_COMMON_NAME}/${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}.cert.pem \
		-inkey email_certs/${SERVER_COMMON_NAME}/${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}.key.pem \
		-out   email_certs/${SERVER_COMMON_NAME}/${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}.pfx \
        -password pass:geheim || echo "ERROR: openssl pkcs12 failed\n";
if [ $? != 0 ]
then
	echo "#############################################################"
	echo "SEVERE ERROR!!! Check file index.txt!!!! ENTRY ALREADY EXISTS!"
	echo "#############################################################"
	exit;
fi
