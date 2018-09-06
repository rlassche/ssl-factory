# SSL Factory

A big company in the Netherlands, with offices in several places, wants to create their own certificates for
their internal servers. 

The company will use the self signed certificates for https connections, email certificates for securing web server 
directories and single-sign on, document signing.

The head office in Amsterdam is responsible for setting up this certificate environment.

This github repository supplies the required script for implementing a ssl-factory.

# Setup the SSL factory

In this setup the Certificate Authority (CA) and a server certificate is created.

[README-ssl.md](README-ssl.md)

# Use the SSL certifcates

The next step demonstrates how the server certificate can be installed in Apache, running in a Docker image.

[README-docker.md](README-docker.md)


