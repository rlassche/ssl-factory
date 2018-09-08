#!/bin/bash
####################################################################
# Last update: 07-SEP-2018
# Description:
#	Geneate the CA directory structure
#
# ca
# ├── ca_certs
# ├── crl
# ├── index.txt
# ├── newcerts
# ├── openssl.cnf
# ├── private
# ├── serial
# └── server_certs
#     ├── certs
#     ├── csr
#     └── private
# 
####################################################################
SCRIPTNAME=`basename $0`;
ROOTCA_DIR=ca;
HOME=`pwd`

echo "$HOME/ca.config";

if [ ! -f $HOME/ca.config ]
then
	echo "$SCRIPTNAME: Config file $HOME/ca.config not found"
	exit 1
fi

. $HOME/ca.config

if [ -d "$ROOTCA_DIR" ]
then
	echo "$SCRIPTNAME WARNING: ROOTCA_DIR $ROOTCA_DIR already exists. Preperation setup already done."
	exit 0;
else
	echo mkdir -p `dirname $HOME/$ROOTCA_DIR`
	mkdir -p $HOME/$ROOTCA_DIR
	mkdir -p $HOME/$ROOTCA_DIR/server_certs/private
	mkdir -p $HOME/$ROOTCA_DIR/server_certs/csr
	mkdir -p $HOME/$ROOTCA_DIR/server_certs/certs
	mkdir -p $HOME/$ROOTCA_DIR/server_certs/crl
fi

mkdir -p $ROOTCA_DIR \
	&& echo "Create NEW and EMPTY dir structure in $ROOTCA_DIR"

cd $HOME/$ROOTCA_DIR

mkdir ca_certs crl newcerts private
chmod 700 private

touch index.txt
echo 1000 > serial

# Certificate Revoke List
touch crlnumber
echo 1000 > clrnumber

cp $HOME/openssl.cnf $HOME/$ROOTCA_DIR
