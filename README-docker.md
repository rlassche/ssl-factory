# Apache SSL installion in Docker

## Certificates for the web server

The system administrator received three files from the Certificate Authority. The files are located in `docker/srv_certs`:

1. Server key file  
   srv_rotterdam01.key.pem
2. Server certificate file  
   srv_rotterdam01.cert.pem
3. Certificate Authority (root) certificate  
   ca.cert.pem


### Inspect the files

* Server key file: **srv_rotterdam01.key.pem**  

Open the file and look at the first line.
```  
    -----BEGIN RSA PRIVATE KEY-----
```  

This is the private key.


* Server certificate file: **srv_rotterdam01.cert.pem**  

Open the file and look at the first line.

```  
    -----BEGIN CERTIFICATE-----
```  

This is a certificate file.

* CA root certificate: **ca.cert.pem**

Open the file and look at the first line.

```  
    -----BEGIN CERTIFICATE-----
```  

This is a certificate file.

* Display the _server sertificate_ in text format

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
    					....
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

 
<!-- switch from ordered list to bullet list-->     

* Display the server key file 

```
    $ openssl rsa -in srv_rotterdam01.local.key.pem 
    writing RSA key
    -----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEAsO48sj9bXfQz3W2N944xic7lKf1gqhw5mXBtXrXpjLsnSB3U
    z/D0bgRjp1M+yyKxc8NMCf2DYPOpS9Ldhp2KmO+R9DFM9OfBdOs2/EDSmjdh5FlP
    ...
    kOr0PgbmYoiiOFpCqYGiNpVOCEppcArjg4zAIBGgiSazWlRqTVQ3
    -----END RSA PRIVATE KEY-----
```

The key file consistant.

* Display the _CA root certificate_ in text format

```
    openssl x509 -in ca.cert.pem -text
```

```
    Certificate:
        Data:
            Version: 3 (0x2)
            Serial Number: 12748897067277901274 (0xb0ed2e560d1e5dda)
        Signature Algorithm: sha256WithRSAEncryption
            Issuer: CN=The company Certficate Autority, O=The OS Company, OU=Certificate Center, C=NL, L=Amsterdam, ST=Kalverstraat 999228
            Validity
                Not Before: Sep  6 13:01:54 2018 GMT
                Not After : Sep  1 13:01:54 2038 GMT
            Subject: CN=The company Certficate Autority, O=The OS Company, OU=Certificate Center, C=NL, L=Amsterdam, ST=Kalverstraat 999228
            Subject Public Key Info:
                Public Key Algorithm: rsaEncryption
                    Public-Key: (4096 bit)
                    Modulus:
                        00:d5:bc:d2:f9:08:d9:dc:79:e9:b7:02:e0:76:90:
                        c1:15:45:ed:9d:47:ce:34:74:20:bd:c7:38:4a:ae:
                        ...
                        09:0c:4e:b4:5e:08:6f:54:99:2e:97:b8:65:be:57:
                        45:87:9d
                    Exponent: 65537 (0x10001)
            X509v3 extensions:
                X509v3 Subject Key Identifier: 
                    F8:1E:12:51:1F:0B:F0:D7:CA:CA:D8:FB:8B:6B:A8:36:C9:A5:DE:91
                X509v3 Authority Key Identifier: 
                    keyid:F8:1E:12:51:1F:0B:F0:D7:CA:CA:D8:FB:8B:6B:A8:36:C9:A5:DE:91
    
                X509v3 Basic Constraints: critical
                    CA:TRUE
                X509v3 Key Usage: critical
                    Digital Signature, Certificate Sign, CRL Sign
        Signature Algorithm: sha256WithRSAEncryption
             24:00:aa:8f:7c:ed:25:ea:ee:18:cc:f0:29:cd:bc:ff:33:75:
             0d:88:32:8b:e1:bb:71:20:19:af:4a:a6:5e:15:03:c2:8f:58:
             ...
             03:6f:05:3a:12:ba:a0:20:55:75:ed:47:98:ca:6c:bd:ee:f8:
             b0:fd:38:87:27:63:ea:32
    
```

* Check if the server certificate and the server key file match


```
    # The certificate file is in x509 format
    $ openssl x509 -noout -modulus -in srv_rotterdam01.local.cert.pem | openssl md5
    (stdin)= 0c8bf743722b4e8e4440d501e390edb0
    # The key file is in rsa format
    $ openssl rsa -noout -modulus -in srv_rotterdam01.local.key.pem | openssl md5
    (stdin)= 0c8bf743722b4e8e4440d501e390edb0
```

The md5 values are the same, so the key and certificate match!



## Docker

* Docker should be installed on your linux server.

```
    $ docker -v
    Docker version 18.06.1-ce, build e68fc7a
```

### Build the docker image

```
    cd ~/ssl-factory/docker
    docker build --tag srv_rotterdam:v1 -f df_srv_rotterdam .
```

* Check the images in the repository

```
    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    srv_rotterdam       v1                  0c4ae7155efc        2 minutes ago       405MB

```

* Run the docker image and start a bash shell

```
    docker run -d -p 9443:443 -p 9080:80 -v /tmp/share:/mnt --name srv_rotterdam_01 srv_rotterdam:v1
```

* Connect to the running image

```
    docker exec -it srv_rotterdam_01 /bin/bash
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

# ISSUES

## Docker with ubuntu 18.04

Apache2 start, but cannot connect to it. Network is different. So, I stay with ubuntu 16.04!
