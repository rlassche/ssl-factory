# Self signed Certificates

A big company in the Netherlands, with offices in several places, wants to create their own certificates for
their internal servers. 

The company will use the self signed certificates for https connections, email certificates for securing web server 
directories and single-sign on, document signing.

The head office in Amsterdam is responsible for setting up this certificate environment.

The following steps are required:

1. [Create the company "Certificate Authority"](#tit_1_1)
2. [Create server certificates](#tit_1_2)
3. [Create client-email certificates (todo)](#tit_1_3)
4. [Create a revoke list (todo)](#tit_1_4)
5. [CA adminstrator sends the certificates to the customer](#tit_1_5)

The creation of SSL certificates is done with `openssl`. Openssl depends on file `openssl.cnf` which is also supplied in this repository.

# <a name="tit_1_1"></a>Create the company Certificate Authority (CA)

The head office has to set this up only ONCE! All internal servers, browsers will trust this CA.

## Setup the CA 

The scripts are located in the `ssl` directory.

```
cd ssl
```

### Define the CA

The configurate for the Certificate Authority (file `ca.config`)


```
# certificate value: CN
CA_COMMON_NAME="The company Certficate Autority"

# certificate value: C
CA_COUNTRY_CODE="NL"

# certificate value: O
ORGANISATION="The OS Company"

# certificate value: OU
ORGANISATION_UNIT="Certificate Center"

# certificate value: S
ORGANISATION_STATE_OR_PROVINCE="NH"

# certificate value: L
ORGANISATION_CITY="Amsterdam"

# certificate value: ST
ORGANISATION_STREET="Kalverstraat 999228"
```

### Create the CA directory structure

Run script `01_ca_prep.sh`

```
ca
├── ca_certs
├── crl
├── index.txt
├── newcerts
├── openssl.cnf
├── private
├── serial
└── server_certs
    ├── certs
    ├── csr
    └── private
```

### Create the CA key

Run script `02_ca_key.sh`  

The private key of the CA is **ca.key.pem**.

Result:

```
ca
├── ca_certs
├── crl
├── index.txt
├── newcerts
├── openssl.cnf
├── private
│   └── ca.key.pem
├── serial
└── server_certs
    └── private
``` 

### Create the CA certificate

Run script  `03_ca_cert.sh`. This will create the CA certificate file **ca.cert.pem**

The directory overview 

```
ca
├── ca_certs
│   └── ca.cert.pem
├── crl
├── index.txt
├── newcerts
├── openssl.cnf
├── private
│   └── ca.key.pem
├── serial
└── server_certs
    └── private
```


The CA certificate looks like this:

```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 10141305789793967104 (0x8cbd27e287481c00)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=The company Certficate Autority, O=The OS Company, OU=Certificate Center, C=NL, L=Amsterdam, ST=Kalverstraat 999228
        Validity
            Not Before: Sep  6 11:11:06 2018 GMT
            Not After : Sep  1 11:11:06 2038 GMT
        Subject: CN=The company Certficate Autority, O=The OS Company, OU=Certificate Center, C=NL, L=Amsterdam, ST=Kalverstraat 999228
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (4096 bit)
                Modulus:
                    00:ab:a4:89:25:ce:96:46:ac:c8:24:e9:3c:fa:06:
                    5b:e8:8f:92:b1:ef:4b:a7:75:4a:d2:7f:01:6a:2c:
                    b8:20:9a:56:fb:49:03:f2:1c:52:a9:c4:c3:ff:e1:
					....
                    2c:6f:f4:a2:0d:8a:68:69:e9:79:d0:15:b1:25:6e:
                    3e:51:45
                Exponent: 65537 (0x10001)
X509v3 extensions:
            X509v3 Subject Key Identifier: 
                F8:F4:4D:61:D6:A9:90:46:B1:EF:F5:B9:13:90:CD:72:26:6C:F4:18
            X509v3 Authority Key Identifier: 
                keyid:F8:F4:4D:61:D6:A9:90:46:B1:EF:F5:B9:13:90:CD:72:26:6C:F4:18

            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Key Usage: critical
                Digital Signature, Certificate Sign, CRL Sign
    Signature Algorithm: sha256WithRSAEncryption
         26:f0:f2:d1:ba:77:f9:0d:d9:00:8b:6b:03:ed:6d:13:a9:a0:
         fd:65:4b:82:59:24:4b:ed:1d:dd:56:b6:5c:6b:34:51:d9:c3:
		 ....
         91:e7:a6:ca:90:04:b2:95:22:cf:59:9e:b6:ae:cc:9a:ad:22:
         1d:a1:d6:c0:63:af:df:ab


```
The Certificate Authority is setup now!

# <a name="tit_1_2">Create the server certificate

## Setup a Server certicate

The system adminstrator in the Rotterdam office defines the server SSL requirements for a new Docker image.

Based on the server config, the CA will create the server certificate files:

1. Public certificate file
2. Private server key file

The CA will send the two files and the CA-public certificate to the system adminstrator in Rotterdam.


The system administrator in Rotterdam will install the certicate in the Apache server, running in the new Docker image.

### Define the server ssl requirements

The system administrator creates the following server ssl requirement in a config file (`srv_rotterdam.config`):

```
# CN
SERVER_COMMON_NAME=srv_rotteram01.local

# certificate value: C
SERVER_COUNTRY_CODE="NL"

# certificate value: O
ORGANISATION="The OS Company"

# certificate value: OU
ORGANISATION_UNIT="Rotterdam Office"

# certificate value: S
ORGANISATION_STATE_OR_PROVINCE="ZH"

# certificate value: L
ORGANISATION_CITY="Rotterdam"

# certificate value: ST
ORGANISATION_STREET="Blaak 45679"

```

### Create the server key 

Run script `04_server_key -c srv_rotterdam.config`.  The server key file **srv_rotterdam01.local.key.pem** is created.

```
ca
├── ca_certs
│   └── ca.cert.pem
├── crl
├── index.txt
├── newcerts
├── openssl.cnf
├── private
│   └── ca.key.pem
├── serial
└── server_certs
    ├── certs
    ├── csr
    └── private
        └── srv_rotteram01.local.key.pem
```


### Create the server sign request


Run script `05_server_sign_request.sh -c srv_rotterdam.config`. Signing request file **srv_rotterdam01.csr.pem** is created.


```
ca
├── ca_certs
│   └── ca.cert.pem
├── crl
├── index.txt
├── newcerts
├── openssl.cnf
├── private
│   └── ca.key.pem
├── serial
└── server_certs
    ├── certs
    ├── csr
    │   └── srv_rotteram01.local.csr.pem
    └── private
        └── srv_rotteram01.local.key.pem

```



### The CA signs the server sign request


Run script `06_ca_signs_server_sign_request.sh -c srv_rotterdam.config`. Server certificate file **srv_rotterdam01.cert.pem** is created.

The directory structure in the CA:

``` 
ca
├── ca_certs
│   └── ca.cert.pem
├── crl
├── index.txt
├── index.txt.attr
├── index.txt.old
├── newcerts
│   └── 1000.pem
├── openssl.cnf
├── private
│   └── ca.key.pem
├── serial
├── serial.old
└── server_certs
    ├── certs
    │   └── srv_rotteram01.local.cert.pem
    ├── csr
    │   └── srv_rotteram01.local.csr.pem
    └── private
        └── srv_rotteram01.local.key.pem
``` 

The server certificate looks like this:

```
Certificate Details:
        Serial Number: 4096 (0x1000)
        Validity
            Not Before: Sep  6 11:26:37 2018 GMT
            Not After : Sep 16 11:26:37 2019 GMT
        Subject:
            countryName               = NL
            stateOrProvinceName       = Blaak 45679
            organizationName          = The OS Company
            organizationalUnitName    = Rotterdam Office
            commonName                = srv_rotteram01.local
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            Netscape Cert Type: 
                SSL Server
            Netscape Comment: 
                OpenSSL Generated Server Certificate
            X509v3 Subject Key Identifier: 
                29:E6:16:ED:D6:09:22:E3:D3:9D:2B:17:AA:E6:FF:DF:41:B1:B6:C8
            X509v3 Authority Key Identifier: 
                keyid:F8:F4:4D:61:D6:A9:90:46:B1:EF:F5:B9:13:90:CD:72:26:6C:F4:18
                DirName:/CN=The company Certficate Autority/O=The OS Company/OU=Certificate Center/C=NL/L=Amsterdam/ST=Kalverstraat 999228
                serial:8C:BD:27:E2:87:48:1C:00

            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment
            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
Certificate is to be certified until Sep 16 11:26:37 2019 GMT (375 days)
```



# <a name="tit_1_3"></a>Create client-email certificates

TODO.

# <a name="tit_1_4"></a>Create a revoke list

TODO.

# <a name="tit_1_5"></a>CA administrator sends the certificates to the customer

The customer in this case, is the devop in the Rotterdam office.

The customer will receive the following files:

1. Server key file  
   srv_rotterdam01.key.pem
2. Server certificate file  
   srv_rotterdam01.cert.pem
3. Certificate Authority (root) certificate  
   ca.cert.pem


Now, it is upto the Rotterdam devop to install the files in his new Docker image.

[README-docker.md](README-docker.md)
