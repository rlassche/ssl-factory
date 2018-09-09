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
. $SERVER_CONFIG;

ping -q -c 1 ${SERVER_COMMON_NAME} \
	|| ( echo -e "Cannot ping to ${SERVER_COMMON_NAME}\n"; exit 1 ) \
	&& echo -e "\nOK: Server is pingable\n";

curl -I http://${SERVER_COMMON_NAME}:9080 \
	&& echo -e "OK: Test HTTP on port 9080\n";

curl -k -I https://${SERVER_COMMON_NAME}:9443 \
	&& echo -e "OK: Test HTTPS on port 9443 (ignore SSL errors)\n";

curl --cacert certs/ca.cert.pem -I https://${SERVER_COMMON_NAME}:9443 \
	&& echo -e "OK: Test HTTPS on port 9443 and validate hostname against the certificate with CA\n";


#openssl s_client -connect ${SERVER_COMMON_NAME}:9443 2>&1 | openssl x509 -noout -serial
##openssl x509 -in certs/${SERVER_COMMON_NAME}.cert.pem -text

echo -e "\nCertificate dates:\n"
echo | openssl s_client -servername ${COMMON_SERVER_NAME} \
	-connect ${SERVER_COMMON_NAME}:9443 2> /dev/null | \
	openssl x509 -noout -dates

echo -e "#####################################################\n";
# checkend of certificate: 
if openssl x509 -checkend 864000 -noout -in certs/${SERVER_COMMON_NAME}.cert.pem
then
  echo "Certificate is good for another 10 days!"
else
  echo "Certificate has expired or will do so within 10 days!"
  echo "(or is invalid/not found)"
fi

echo -e "\nWho is the issuer of this certificate (CA):\n"
echo | openssl s_client -servername ${SERVER_COMMON_NAME} \
			-connect ${SERVER_COMMON_NAME}:9443 2>/dev/null | \
		openssl x509 -noout -issuer

echo -e "\nWho is the owner of the certificate (ussued to, Subject: /CN):\n"

echo | openssl s_client -servername ${SERVER_COMMON_NAME} \
	-connect ${SERVER_COMMON_NAME}:9443 2>/dev/null | \
	openssl x509 -noout -subject


echo -e "\n\nALL IN ONCE:\n";

echo | openssl s_client -servername ${SERVER_COMMON_NAME} \
	-connect ${SERVER_COMMON_NAME}:9443 2>/dev/null | \
	openssl x509 -noout -issuer -subject -dates


echo -e "\nFinger print ${SERVER_COMMON_NAME}\n";
echo | openssl s_client -servername ${SERVER_COMMON_NAME} \
	-connect ${SERVER_COMMON_NAME}:9443 2>/dev/null | \
	openssl x509 -noout -fingerprint


echo -e "\nFinger print CA\n";
openssl x509 -in certs/ca.cert.pem -noout -fingerprint

echo -e "Now, you can install the client certificate and ca-root certificate in the browser(s)\n"

echo -e "Print env. \n"
curl http://${SERVER_COMMON_NAME}:9080/cgi-bin/printenv.pl | grep SERVER_NAME
curl https://${SERVER_COMMON_NAME}:9443/cgi-bin/printenv.pl | grep SSL_SERVER_M_SERIAL

curl https://${SERVER_COMMON_NAME}:9443/secure/index.html || \
	echo -e "\nOK: curl failed (no client certifcate passed to server)\n"

curl --cert certs/rob@srv_rotterdam01.local.cert.pem \
	 --key  certs/rob@srv_rotterdam01.local.key.pem \
	 https://${SERVER_COMMON_NAME}:9443/secure/index.html  && \
	echo "OK: Pass a valid client certificate" 
