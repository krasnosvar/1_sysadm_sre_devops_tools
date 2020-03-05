



#через rsyslog на удаленный сервер отправлять введенные команды(то есть rsyslog должен логировать  ~/user/.bashrc)
#с включенным SELinux
#Настройка rsyslog
vi  /etc/rsyslog.d/bash.conf
#################################################
$ModLoad imfile
$InputFileName /home/apilist/.bash_history
$InputFileTag tag_bash_log:
$InputFileStateFile bash_log
$InputFileSeverity debug
$InputFileFacility local7
$InputRunFileMonitor
##
$InputFilePollInterval 3
local7.*                 @10.8.62.44:514
##################################################
service rsyslog restart
#настройка SELinux
#поставить утилиты если нет
yum install policycoreutils-python
#проверить в какой группе файлы rsyslog( на эти же правила настроим bashrc)
ls -Z /etc/rsyslog.d/
#настройка bashrc
chcon -t syslog_conf_t /home/local/.bash_history
#проверка уходят ли пакеты на сервер
tcpdump -i ens192 dst 10.8.62.44 -vv
