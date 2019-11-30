#change locale(from RU to EN for example)
export LANG="en_US.UTF-8"
cat /etc/sysconfig/i18n
  LANG="en_US.UTF-8"
  SYSFONT="latarcyrheb-sun16"

#How do I find the FC ID (WWN) of a scsi device/LUN on Red Hat Enterprise Linux? 
#https://access.redhat.com/articles/17054
#узнать WWN на CentOS6
scsi_id --replace-whitespace --whitelisted --device /dev/sdm
for i in $(lsscsi -t| awk '{print $4}'); do echo "$i $(scsi_id --replace-whitespace --whitelisted --device $i)"; done
