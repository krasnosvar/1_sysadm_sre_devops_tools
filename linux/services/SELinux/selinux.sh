
#проверить в какой SElinux-группе файлы rsyslog( на эти же правила настроим bashrc)
ls -Z /etc/rsyslog.d/
#настройка bash_history- открыть доступ на чтение для rsyslog 
chcon -t syslog_conf_t /home/local/.bash_history

#allow Apache to connect to a database(MySQL) through SELinux, run the following command:
sudo setsebool -P httpd_can_network_connect_db 1

#Разрешить SELinux пускать извне на nginx с proxy-pass
#https://serverfault.com/questions/858454/nginx-proxy-pass-to-localhost-gunicorn-returns-50x-error-unexpectedly
setsebool -P httpd_can_network_connect 1

#allow nginx in centos8
semanage permissive -a httpd_t
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --reload
