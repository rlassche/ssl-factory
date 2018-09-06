#!/bin/bash
####################################################################
# Last update: 06-SEP-2018
# Description:
#	Setup the CA directory structure
####################################################################
SCRIPTNAME=`basename $0`;
ROOTCA_DIR=ca;
#SCRIPTDIR=`dirname $0` ;
HOME=`pwd`
#echo "SCRIPTDIR=$SCRIPTDIR"
#echo "HOME=$HOME"

#https://jamielinux.com/docs/openssl-certificate-authority/create-the-root-pair.html

echo "$HOME/ca.config";

if [ ! -f $HOME/ca.config ]
then
	echo "$SCRIPTNAME: Config file $HOME/ca.config not found"
	exit 1
fi

. $HOME/ca.config

echo "ROOTCA_DIR: $ROOTCA_DIR"
if [ -d "$ROOTCA_DIR" ]
then
	echo "$SCRIPTNAME WARNING: ROOTCA_DIR $ROOTCA_DIR already exists. Preperation setup already done."
	exit 0
else
	echo mkdir -p `dirname $HOME/$ROOTCA_DIR`
	mkdir -p $HOME/$ROOTCA_DIR
	mkdir -p $HOME/$ROOTCA_DIR/server_certs/private
	mkdir -p $HOME/$ROOTCA_DIR/server_certs/csr
	mkdir -p $HOME/$ROOTCA_DIR/server_certs/certs
fi

#Prepare directory structure in $ROOTCA_DIR/ca
#=============================================
#
#$ROOTCA_DIR/ca/openssl.cnf:
#apply policy_strict for all root CA signatures, as the root CA is only being 
#used to create intermediate CAs.
#!


#echo "Create NEW and EMPTY dir structure in $ROOTCA_DIR"
mkdir -p $ROOTCA_DIR \
	&& echo "Create NEW and EMPTY dir structure in $ROOTCA_DIR"

cd $HOME/$ROOTCA_DIR
pwd
echo "Create dirs: ca_certs crl newcerts private"
mkdir ca_certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
cp $HOME/openssl.cnf $HOME/$ROOTCA_DIR

