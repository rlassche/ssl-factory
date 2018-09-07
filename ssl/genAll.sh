#!/bin/bash
#########################################################################################
# Last update: 07-SEP-2018
#
# All steps.
#########################################################################################
./00_clean_server_certs.sh -c srv_rotterdam.config
./01_ca_prep.sh
./02_ca_key.sh
./03_ca_cert.sh
./04_server_key.sh -c srv_rotterdam.config
./05_server_sign_request.sh -c srv_rotterdam.config
./06_ca_signs_server_sign_request.sh -c srv_rotterdam.config
./07_ship_certificates.sh -c srv_rotterdam.config
