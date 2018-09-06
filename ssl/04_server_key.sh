#!/bin/bash
###################################################################
# Last update: 21-OKT-2017
# Description:
#	Sign server and client certificates
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

ls -l $SERVER_CONFIG;

if [ ! -f ${SERVER_CONFIG} ]
then
	echo "$SCRIPTNAME ERROR: Server config file $SERVER_CONFIG missing (-c option) $!";
	exit 1
fi
. $HOME/${SERVER_CONFIG}

if [ ! -f $HOME/ca.config ]
then
	echo "$SCRIPTNAME ERROR: Config file ca.config not found"
	exit 2
fi


if [ -f $HOME/ca/server_certs/private/${SERVER_COMMON_NAME}.key.pem  ]
then
	echo "$SCRIPTNAME WARNING: File ca/server_certs/private/${SERVER_COMMON_NAME}.key.pem  already exists (skipping)"
	exit 3
fi

. $HOME/ca.config
cd $ROOTCA_DIR

echo "$SCRIPTNAME: Generate file server_certs/private/${SERVER_COMMON_NAME}.key.pem "

# NO PASSWORD: OMMIT -aes256
pwd
openssl genrsa  \
      -out server_certs/private/${SERVER_COMMON_NAME}.key.pem 2048
if [ $? -ne 0 ]
then
		"error genrsa "
fi
pwd

chmod 400 server_certs/private/${SERVER_COMMON_NAME}.key.pem
