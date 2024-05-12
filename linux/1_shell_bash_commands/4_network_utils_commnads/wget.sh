#Узнать внешний ip
wget -q -O - checkip.dyndns.org \
> | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'

#extract tar from link
sudo wget -c https://github.com/fullstorydev/grpcurl/releases/download/v1.8.0/grpcurl_1.8.0_linux_x86_64.tar.gz -O - | sudo tar -xz -C /usr/local/bin/

#wget file to specific dir
wget https://raw.githubusercontent.com/nicolargo/glances/develop/conf/glances.conf -P /etc/glances/
