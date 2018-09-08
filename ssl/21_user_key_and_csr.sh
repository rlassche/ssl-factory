#!/bin/bash
###################################################################
# Last update: 21-OKT-2017
# Description:
###################################################################
SCRIPTNAME=`basename $0`;
SCRIPTDIR=`dirname $0` ;
ROOTCA_DIR="ca"
HOME=`pwd`

if [ ! -f $HOME/ca.config ]
then
	echo "$SCRIPTNAME ERROR: Config file ca.config not found"
	exit 1
fi
. $HOME/ca.config
while getopts "e:c:" opt; do
	case $opt in
	e) EMAIL_CONFIG=$OPTARG ;;
	c) SERVER_CONFIG=$OPTARG ;;
	\?) echo "$SCRIPTNAME ERROR: Invalid option: -$OPTARG"
	;;
	esac
done

if [ ! -f "${EMAIL_CONFIG}" ]
then
	echo "$SCRIPTNAME ERROR: Email config file $EMAIL_CONFIG missing (-e option) $!";
	exit 2
fi
if [ ! -f "${SERVER_CONFIG}" ]
then
	echo "$SCRIPTNAME ERROR: Server config file $SERVER_CONFIG missing (-c option) $!";
	exit 2
fi

echo -e "***************"
pwd
ls -l ${EMAIL_CONFIG};
. $HOME/${EMAIL_CONFIG}
. $HOME/${SERVER_CONFIG}

echo "XX: $SERVER_COMMON_NAME";

if [ ! -f "ca/server_certs/openssl.${SERVER_COMMON_NAME}.cnf" ]
then
	echo "ERROR: Openssl config file (ca/server_certs/openssl.${SERVER_COMMON_NAME}.cnf) not found. "
fi


cd $ROOTCA_DIR

if [ ! -d email_certs/${SERVER_COMMON_NAME} ]
then
pwd
	echo "Create email_certs/${SERVER_COMMON_NAME}"
	mkdir "email_certs/${SERVER_COMMON_NAME}"
fi

if [ -f email_certs/${SERVER_COMMON_NAME}/${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}.key.pem ]
then
	echo "WARNING: Client Key already exists (email_certs/${SERVER_COMMON_NAME}/${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}.key.pem)"
	exit 0;
fi

subj="/CN=${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}/C=${SERVER_COUNTRY_CODE}/ST=$ORGANISATION_STREET/O=${ORGANISATION}/OU=${ORGANISATION_UNIT}/SN=${SURNAME}/GN=${GIVEN_NAME}/title=Programmer/initials=R.E."
echo -e "subj: $subj\n";


openssl genrsa  \
		-out "email_certs/${SERVER_COMMON_NAME}/${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}.key.pem" 2048

openssl req -new -config server_certs/openssl.${SERVER_COMMON_NAME}.cnf \
	-key email_certs/${SERVER_COMMON_NAME}/${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}.key.pem \
	  -subj "$subj" \
      -out email_certs/${SERVER_COMMON_NAME}/${EMAIL_USER_NAME}@${SERVER_COMMON_NAME}.csr.pem

