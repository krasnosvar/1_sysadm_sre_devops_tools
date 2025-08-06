# ZIP
#unzip file to specific folder(/etc/ansible/roles)
unzip /home/den/ansible-haproxy-master.zip -d /etc/ansible/roles/
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
#unzip file from URL
file=consul_1.8.3_linux_amd64.zip;  curl -O https://releases.hashicorp.com/consul/1.8.3/$file && unzip $file && rm -rf $file
# unzip password-protected archive without knowing the password
apt install fcrackzip
fcrackzip -u -b -v file.zip


# 7z
#install in Ubuntu
sudo apt install p7zip-full -y
#untar password-protected archive with password "7928"
7z x unix_admin.7z -p7928
#pack
7z a secure.7z * -pSECRET
#If the password contains spaces or special characters, then enclose it with quotes
7z a secure.7z * -p"pa$$word @|"


# TAR
# extracts: *.tar, *.tar.gz,  *.tar.xz, *.tbz
#create tar
tar -cvf archive.tar file-to-be-archive
#create tar.gz from specific dir ( /var/log) and put in in specific dir (/backup)
tar cvzf /backup/log.tar.gz /var/log
#create tar.gz from specific dir with timestamp (make backup)
tar -cvzf $(hostname)-$(date -I).tar.gz /etc/sysconfig/app.env /etc/systemd/system/app.service /opt/app
#create tar.gz from specific dir with timestamp and exlude some dirs
tar -cvzf $(hostname)-$(date -I).tar.gz /var/www/html/site.domain.ru/ --exclude /var/www/html/site.domain.ru/static/reports --exclude /var/www/html/site.domain.ru/oradiag_ap_graphic
#extract tar
tar -xvf archive.tar
#extract *.tar.gz or *.tgz TGZ file
tar -xvzf archive.tar.gz
tar -xvzf metallb-4.5.7.tgz
#add file to non compressed archive
tar -rvf archive.tar file-to-add
#list files in archive
tar -tvf archive.tar
#untar in specific folder /home/den/tst2/ 
tar -C /home/den/tst2/ -xvf /home/den/tst/app.zip --strip-components 1

# TBZ by tar
#extract TBZ
tar -xjf test.tbz
#To extract to  folder tmp/test
tar -xjf test.tbz -C /tmp/test
#extract tar from link
sudo wget -c https://github.com/fullstorydev/grpcurl/releases/download/v1.8.0/grpcurl_1.8.0_linux_x86_64.tar.gz -O - | sudo tar -xz -C /usr/local/bin/
sudo wget -c https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz -O - | sudo tar -xz -C /usr/local/bin/

# XZ by tar
tar -xpJf archive.tar.xz
#or
#XZ - working with *.xz files
#https://computingforgeeks.com/how-to-extract-xz-files-on-linux/
#install utils
sudo apt-get install xz-utils
yum install xz
#Extract .xz files on Linux
tar -xvf archive.tar.xz
tar -xfv Hack-v3.003-ttf.tar.xz /usr/share/fonts/
unxz file.xz
#extract Fedora CoreOS( will be extracted in the same dir as archive)
unxz -v  /home/den/git_projects/images/fedora-coreos-32.20200809.3.0-qemu.x86_64.qcow2.xz
#or
xz --decompress file.xz


#unpack ARJ archive 
sudo apt update && sudo apt install unar -y
cp task task_bkp
unar task


#GZ - not tar.gz
# -c, --stdout      write on standard output, keep original files unchanged
gzip -c filename.log.gz > /test_logs/filename.log
