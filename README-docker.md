# Apache SSL installion in Docker

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
