# Self signed Certificates

A big company in the Netherlands, with offices in several places, wants to create their own certificates for
their internal servers. 

The company will use the self signed certificates for https connections, email certificates for securing web server 
directories and single-sign on, document signing.

The head office in Amsterdam is responsible for setting up this certificate environment.

The following steps are required:

1. Create the company "Certificate Authority".
2. Create server certificates 
3. Create client-email certificates

# Create the company Certificate Authority (CA)

The head office has to set this up only ONCE! All internal servers, browsers will trust this CA.

## Setup the CA 

### Define the CA

The configurate for the Certificate Authority


```
CA_COMMON_NAME="The company Certficate Autority
CA_COUNTRY="Nederland"
ORGANISATION="The company"
ORGANISATION_UNIT="Certificate Center"
```

### Create the CA directory structure

Run script 01_ca_prep.sh

### Create the CA key

Run script 02_ca_key.sh

The private key of the CA is ca.key.pem.

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

Run script 03_ca_cert.sh. This will create the CA key file (ca.key.pem)

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

The Certificate Authority is setup now!

## Setup a Server certicate

The system adminstrator in the Rotterdam office defines the server SSL requirements for a new Docker image.

Based on the server config, the CA will create the server certificate files:

1. Public certificate file
2. Private server key file

The CA will send the two files and the CA-public certicate to the system adminstrator in Rotterdam.


The system administrator in Rotterdam will install the certicate in the Apache server, running in the new Docker image.

The CA-public certicate is trusted and is required for the Docker image and all browsers who will access the Docker webserver.


### Define the server ssl requirements

The system administrator creates the following server ssl requirement in a config file (`srv_rotterdam.config`):

```
# CN
SERVER_COMMON_NAME="srv_rotteram01.local"

# certificate value: C
CA_COUNTRY_CODE="NL"

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

Run script `04_server_key -f srv_rotterdam.config`

```
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
        └── srv_rotteram01.local.key.pem
```


### Create the server sign certicate 


Run script `05_server_sign_request.sh -c srv_rotterdam.config


```
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
    ├── csr
    │   └── srv_rotteram01.local.csr.pem
    └── private
        └── srv_rotteram01.local.key.pem

```



### The CA signs the server sign request


This will create the server certificate.




