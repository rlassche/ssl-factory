#!/bin/bash
####################################################################
# Last update: 07-SEP-2018
# Description:
# create PRIMARY root key ca.key.pem
#
# ca
# ├── ca_certs
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
#     └── private
# 
####################################################################
SCRIPTNAME=`basename $0`;
SCRIPTDIR=`dirname $0` ;
HOME=`pwd`
ROOTCA_DIR=ca;
if [ ! -f $HOME/ca.config ]
then
	echo "$SCRIPTNAME: Config file $HOME/ssl.config not found"
	exit 1
fi
. $HOME/ca.config

cd $ROOTCA_DIR

if [ -f private/ca.key.pem ]
then
	echo "$SCRIPTNAME WARNING: private/ca.key.pem for PRIMARY ROOT CA already exists"
	exit 0
fi

# Generate the key
openssl genrsa -out private/ca.key.pem 4096
if [ $? -ne 0 ]
then
	"$SCRIPTNAME: error openssl genrsa"
fi
chmod 400 private/ca.key.pem
