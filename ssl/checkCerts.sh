. srv_rotterdam.config

MD5_CERT=`openssl x509 -noout -modulus -in ca/server_certs/certs/${SERVER_COMMON_NAME}.cert.pem | openssl md5`

MD5_KEY=`openssl rsa -noout -modulus -in ca/server_certs/private/${SERVER_COMMON_NAME}.key.pem | openssl md5`

if [ "$MD5_CERT" != "$MD5_KEY" ]
then
	echo "Certificate and Key do NOT match!"
	echo "MD5 certificate: $MD5_CERT"
	echo "MD5 key        : $MD5_KEY\n"
fi
	echo "MD5 certificate: $MD5_CERT"
	echo "MD5 key        : $MD5_KEY"
