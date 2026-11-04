#main file
#in Ubuntu
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub2/grub.cfg.(never modify boot/grub2/grub.cfg!!!!!)
#in CentOS7
#grub2-mkconfig > /boot/grub2/grub.cfg
/etc/default/grub

#how to reset root password ( in all OSs) 
https://www.vultr.com/docs/reset-the-root-password-on-ubuntu

#set password to GRUB
#https://www.techrepublic.com/article/how-to-password-protect-the-grub-boot-loader-in-ubuntu/
grub-mkpasswd-pbkdf2
sudo vi /etc/grub.d/00_header
#and at the end of file paste
cat << EOF
set superusers="admin"
password_pbkdf2 admin HASH
EOF
#then
sudo update-grub
