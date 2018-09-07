checkCerts.sh -c ../ssl/srv_rotterdam.config

#docker kill srv_rotterdam01
#
#docker rm srv_rotterdam01
#
docker build --tag srv_rotterdam:v1 -f df_srv_rotterdam .

#docker run -d -h srv_rotterdam01.local -p 9443:443 -p 9080:80 -v /tmp/share:/mnt --name srv_rotterdam01 srv_rotterdam:v1
