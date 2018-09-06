#!/bin/bash
./01_ca_prep.sh
./02_ca_key.sh
./03_ca_cert.sh
./04_server_key.sh -c srv_rotterdam.config
./05_server_sign_request.sh -c srv_rotterdam.config
./06_ca_signs_server_sign_request.sh -c srv_rotterdam.config
