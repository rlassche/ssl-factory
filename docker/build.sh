./checkCerts.sh -c ../ssl/srv_rotterdam.config  

if [ ! -d apache2/discount-2.2.4 ]
then
	cp -r /opt/discount-2.2.4 apache2/discount-2.2.4
fi
if [ ! -d apache2/apache-mod-markdown ]
then
	cp -r /opt/apache-mod-markdown apache2/apache-mod-markdown
fi

docker ps | grep srv_rotterdam01 | \
	docker kill srv_rotterdam01

docker ps -a | grep srv_rotterdam01 | \
	docker rm srv_rotterdam01

docker build --tag srv_rotterdam:v1 -f df_srv_rotterdam .

docker run -d -h srv_rotterdam01.local -p 9443:443 -p 9080:80 -v /tmp/share:/mnt --name srv_rotterdam01 srv_rotterdam:v1
