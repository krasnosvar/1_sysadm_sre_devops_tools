###ZIP
#unzip file to specific folder(/etc/ansible/roles)
unzip /home/krasnosvarov_dn/ansible-haproxy-master.zip -d /etc/ansible/roles/

#create zip-archive with password
zip -e ~/Downloads/manag.zip ~/Downloads/manag-adm.txt
  Enter password: 
  Verify password: 
    adding: home/den/Downloads/manag-adm.txt (deflated 9%)
#unzip passworded file
unzip -P your-password zipfile.zip


#create zip-archive with size limit 
zip -r -s 10m archive.zip directory/
#To unzip the file, the "zip" manpage explains that you should use the "-s 0`" switch.So, you first "unsplit" the ZIP file using the "-s 0" switch:
zip -s 0 split.zip --out unsplit.zip
unzip unsplit.zip


###TAR
#create tar
tar -cvf archive.tar file-to-be-archive
#extract tar
tar -xvf archive.tar
#add file to archive
tar -rvf archive.tar file-to-add
#list files in archive
tar -tvf archive.tar


#untar in specific folder /home/krasnosvarov_dn/tst2/ 
tar -C /home/krasnosvarov_dn/tst2/ -xvf /home/krasnosvarov_dn/tst/whs-gw-uzdo.zip --strip-components 1

#make backup
tar -cvzf $(hostname)-$(date -I).tar.gz /etc/sysconfig/whs-gw-uzdo.env /etc/systemd/system/whs-gw-uzdo.service /opt/whs-gw-uzdo

tar -cvzf $(hostname)-$(date -I).tar.gz /var/www/html/graphic-prod.domain.ru/ --exclude /var/www/html/graphic-prod.domain.ru/static/reports --exclude /var/www/html/graphic-prod.domain.ru/oradiag_ap_graphic
