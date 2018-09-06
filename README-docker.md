# Apache SSL installion in Docker

## Certificates for the web server

The system administrator received three files from the Certificate Authority. The files are located in `docker/srv_certs`:

1. Server key file  
   srv_rotterdam01.key.pem
2. Server certificate file  
   srv_rotterdam01.cert.pem
3. Certificate Authority (root) certificate  
   ca.cert.pem


===Inspect the files===

**srv_rotterdam01.key.pem**  

Open the file and look at the first line.
```  
-----BEGIN RSA PRIVATE KEY-----
```  

This is the private key.


**srv_rotterdam01.cert.pem**  

Open the file and look at the first line.

```  
-----BEGIN CERTIFICATE-----
```  

This is a certificate file.

**ca.cert.pem**

Open the file and look at the first line.

```  
-----BEGIN CERTIFICATE-----
```  

This is a certificate file.

Display the server sertificate in text format

`openssl x509 -in srv_rotterdam01.local.cert.pem -text`

```  
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 4096 (0x1000)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=The company Certficate Autority, O=The OS Company, OU=Certificate Center, C=NL, L=Amsterdam, ST=Kalverstraat 999228
        Validity
            Not Before: Sep  6 13:01:54 2018 GMT
            Not After : Sep 16 13:01:54 2019 GMT
        Subject: C=NL, ST=Blaak 45679, O=The OS Company, OU=Rotterdam Office, CN=srv_rotterdam01.local
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:b0:ee:3c:b2:3f:5b:5d:f4:33:dd:6d:8d:f7:8e:
                    31:89:ce:e5:29:fd:60:aa:1c:39:99:70:6d:5e:b5:
                    e9:8c:bb:27:48:1d:d4:cf:f0:f4:6e:04:63:a7:53:
                    3e:cb:22:b1:73:c3:4c:09:fd:83:60:f3:a9:4b:d2:
                    dd:86:9d:8a:98:ef:91:f4:31:4c:f4:e7:c1:74:eb:
                    36:fc:40:d2:9a:37:61:e4:59:4f:84:f9:40:7d:14:
                    75:ed:dd:79:d8:c4:c8:6b:5f:52:ed:68:27:b3:4f:
                    b1:01:62:c9:5e:79:44:6e:cc:0a:24:53:e8:bc:46:
                    de:a0:1a:f6:b8:db:d1:92:f6:34:82:cb:f5:8e:8c:
                    16:08:22:5f:39:42:0a:db:1b:bb:3d:31:1f:4e:78:
                    d6:51:65:08:f0:48:0c:33:4c:85:7b:71:87:9a:67:
                    f8:65:92:fe:2c:78:3c:31:f5:8d:8c:de:10:0f:b9:
                    2e:80:b3:c3:89:ed:4e:6a:0a:38:a6:76:f8:ea:15:
                    26:c5:36:99:b0:d0:bc:d6:08:e8:58:69:d1:be:2e:
                    85:bb:bd:9c:78:fc:88:fb:a3:b8:22:8e:c5:57:6e:
                    52:95:d7:67:b1:48:c9:35:da:2c:5d:a2:5f:30:9f:
                    fa:10:51:97:b6:8c:6b:0b:b6:c5:4c:9f:98:7b:56:
                    bb:61
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            Netscape Cert Type: 
                SSL Server
            Netscape Comment: 
                OpenSSL Generated Server Certificate
            X509v3 Subject Key Identifier: 
                50:57:A3:11:05:BB:2A:D8:CE:85:CC:F3:8E:CF:2A:70:D1:F1:23:AF
            X509v3 Authority Key Identifier: 
                keyid:F8:1E:12:51:1F:0B:F0:D7:CA:CA:D8:FB:8B:6B:A8:36:C9:A5:DE:91
                DirName:/CN=The company Certficate Autority/O=The OS Company/OU=Certificate Center/C=NL/L=Amsterdam/ST=Kalverstraat 999228
                serial:B0:ED:2E:56:0D:1E:5D:DA

            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
    Signature Algorithm: sha256WithRSAEncryption
         c8:6c:70:ee:5b:81:b1:9e:e4:99:be:ba:be:b8:9f:18:a4:be:
         6c:90:be:e8:9e:71:ba:8f:38:9c:99:ab:79:5b:6a:e6:65:9a:
		 ...
         ab:de:6f:2d:64:b5:a8:0a:ae:c2:b6:32:3d:c8:42:bb:a3:66:
         36:f0:3c:64:8b:08:cd:de
-----BEGIN CERTIFICATE-----
MIIGBzCCA++gAwIBAgICEAAwDQYJKoZIhvcNAQELBQAwgZ8xKDAmBgNVBAMMH1Ro
ZSBjb21wYW55IENlcnRmaWNhdGUgQXV0b3JpdHkxFzAVBgNVBAoMDlRoZSBPUyBD
...
gySjwx7afRcr2By4mVjFQa1hyoacnBq26C3e2RwClSrDq95vLWS1qAquwrYyPchC
u6NmNvA8ZIsIzd4=
-----END CERTIFICATE-----


```  
The server certificate looks fine:

1. Class 3 certificate  
   Version: 3 (0x2)
2. Our Certificate Autoriser (The company Certificate Authority) created this certificate  
   Issuer: CN=The company Certficate Autority, O=The OS Company, OU=Certificate Center, C=NL, L=Amsterdam, ST=Kalverstraat 999228
3. The certificate can be used by Docker apache server with server name 'srv_rotterdam01.local'  (=CN)
   C=NL, ST=Blaak 45679, O=The OS Company, OU=Rotterdam Office, CN=srv_rotterdam01.local




## Docker

* Docker should be installed on your linux server.

```
$ docker -v
Docker version 18.06.1-ce, build e68fc7a
```

### Build the initial docker image

Use the docker scripts in docker directory.

Example: Create the docker step 1 image (ssl-factory:v1)

```
cd ~/ssl-factory/docker
docker build --tag ssl-factory:v1 -f dockerfile_01 .
```

* Check the images in the repository

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ssl_factory         v1                  214a40fe1a9c        6 minutes ago        140MB
```

* Run the docker image and start a bash shell

```
docker run -it ssl-factory:v1 -d ssl-factory bash
```

In the shell, check that apache is not installed.

```
# apachectl
bash: apachectl: command not found
```
==Install Apache==

Docker file dockerfile_02 will install apache2 and start it as soon as the image is running.
```
cd ~/ssl-factory/docker
docker build --tag ssl-factory:v1 -f dockerfile_02 .
```

* Run the docker image

```
docker run --hostname example.local --name example --detach ssl-factory:v1
```

* Connect to the running image

```
docker exec -it example /bin/bash
```

* Check that web server is started and the hostname of the image

```
# ps -ef | grep apache
root         1     0  0 22:38 ?        00:00:00 /bin/sh /usr/sbin/apachectl -D FOREGROUND
root        15     1  0 22:38 ?        00:00:00 /usr/sbin/apache2 -D FOREGROUND
www-data    16    15  0 22:38 ?        00:00:00 /usr/sbin/apache2 -D FOREGROUND
www-data    17    15  0 22:38 ?        00:00:00 /usr/sbin/apache2 -D FOREGROUND
root       102    90  0 22:40 pts/0    00:00:00 grep --color=auto apache

# hostname
example.local

```

# SSL installation 

## Enable site default-ssl.conf

```
a2enmod ssl
a2ensite default-ssl.conf
apachectl restart
```
