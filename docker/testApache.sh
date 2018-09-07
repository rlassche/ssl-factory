#!/bin/bash
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
	exit 1
fi
. ../ssl/${SERVER_CONFIG}

ping -q -c 1 ${SERVER_COMMON_NAME} \
	|| ( echo -e "Cannot ping to ${SERVER_COMMON_NAME}\n"; exit 1 ) \
	&& echo -e "\nOK: Server is pingable\n";

curl -I http://${SERVER_COMMON_NAME}:9080 \
	&& echo -e "OK: Test HTTP on port 9080\n";

curl -k -I https://${SERVER_COMMON_NAME}:9443 \
	&& echo -e "OK: Test HTTPS on port 9443 (ignore SSL errors)\n";

curl --cacert certs/ca.cert.pem -I https://${SERVER_COMMON_NAME}:9443 \
	&& echo -e "OK: Test HTTPS on port 9443 and validate hostname against the certificate with CA\n";

openssl s_client -connect ${SERVER_COMMON_NAME}:9443 2>&1 | openssl x509 -noout -serial
#openssl x509 -in certs/${SERVER_COMMON_NAME}.cert.pem -text
