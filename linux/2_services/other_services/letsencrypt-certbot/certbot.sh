#install on ubuntu
apt install certbot -y

#install on centos
yum install letsencrypt -y

#one-liner command to get certs(nginx must be on, certbot place file to check in "webroot-path")
#centos
certbot certonly --agree-tos --email blabla@mail.com --webroot --webroot-path /usr/share/nginx/html -n -d krasnosvar.devops.rebrain.srwx.net
#ubuntu
certbot certonly --agree-tos --email blabla@mail.com --webroot --webroot-path /var/www/html -n -d krasnosvar.devops.rebrain.srwx.net
#fetch certs from dummy FQDN provided by nip.io
certbot certonly --agree-tos --email krasnosvar@gmail.com --webroot --webroot-path /var/www/html -n -d traefik-ex37.142.93.109.117.nip.io
#certs will be in: /etc/letsencrypt/live/
