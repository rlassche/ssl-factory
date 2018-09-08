#!/bin/bash

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
	exit 1
fi
. $SERVER_CONFIG

MD5_CERT=`openssl x509 -noout -modulus -in certs/srv_rotterdam01.local.cert.pem | openssl md5`

MD5_KEY=`openssl rsa -noout -modulus -in certs/srv_rotterdam01.local.key.pem | openssl md5`

if [ "$MD5_CERT" != "$MD5_KEY" ]
then
	echo "Certificate and Key do NOT match!"
	echo "MD5 certificate: $MD5_CERT"
	echo "MD5 key        : $MD5_KEY\n"
else
	echo "Certificate and Key match"
fi

# Check for class3 extension
openssl x509 -in certs/${SERVER_COMMON_NAME}.cert.pem -text | grep -q "DNS:${SERVER_COMMON_NAME}" \
	|| echo "Server name '${SERVER_COMMON_NAME}' not found in class3 extension (DNS:...)"
