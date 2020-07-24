 #!/bin/bash
 #Update
 echo "Executing yum update"
 yum update -y

 #del users except local and yourself
 echo "Deleting users"
cp /etc/passwd /etc/passwd_backup
cut -d: -f1 /etc/passwd | grep -ve krasnosvarov_dn -e it_security -e local | grep '[a-z]_[a-z]' | while read name ; do userdel -r "$name" ; done
ls /home/ | grep -ve krasnosvarov_dn -e it_security -e local | grep '[a-z]_[a-z]' | while read name ; do userdel -r "$name" ; done
#or grep thru creating file "keepers": grep -vFf keepers
#cut -d: -f1 /etc/passwd   #output only first line(only logins)
#grep -ve krasnosvarov_dn -e local    #exclude logins "local", "it_security" and "krasnosvarov_dn"
#grep '[a-z]_[a-z]'  #select domain logins
#while read name ; do userdel -r "$name" ; done   #execute "userdel -r" command on selected logins
echo "Editing the <<sudoers>> file: "
cp /etc/sudoers /tmp/sudoers
echo "Executing: sed -i '/svc_addm_unix/d' /etc/sudoers"
sed -i '/svc_addm_unix/d' /etc/sudoers
echo "Executing: sed -i '/ADDM/d' /etc/sudoers"
sed -i '/ADDM/d' /etc/sudoers
echo "sed -i '/toor/d' /etc/sudoers"
sed -i '/toor/d' /etc/sudoers



#"Editing: /etc/ntp.conf"
IFS=$'\n'
echo "Editing: /etc/ntp.conf"
ntpconf=/etc/ntp.conf
ntptextok=$(echo "Text exist on file ntp.conf, no modification requed")
#restrict ::1
if grep -r "restrict ::1" /etc/ntp.conf
then
    echo $ntptextok
else
    echo "Config text not exist on file $ntpconf" 
    echo "Add text to $ntpconf" 
    echo "restrict ::1" >> /etc/ntp.conf
fi
#restrict -4 default kod nomodify nopeer noquery notrap
if
    grep -r "restrict -4 default kod nomodify nopeer noquery notrap" /etc/ntp.conf
then 
    echo $ntptextok
else
    echo "Config text not exist on file $ntpconf" 
    echo "Add text to $ntpconf" 
    echo "restrict -4 default kod nomodify nopeer noquery notrap" >> /etc/ntp.conf
fi
#restrict -6 default kod nomodify nopeer noquery notrap
if grep -r "restrict -6 default kod nomodify nopeer noquery notrap" /etc/ntp.conf
then 
    echo $ntptextok
else
    echo "Config text not exist on file $ntpconf" 
    echo "Add text to $ntpconf" 
    echo "restrict -6 default kod nomodify nopeer noquery notrap" >> /etc/ntp.conf
fi
#interface ignore wildcard
if grep -r "interface ignore wildcard" /etc/ntp.conf
then 
    echo $ntptextok
else
    echo "Config text not exist on file $ntpconf" 
    echo "Add text to $ntpconf" 
    echo "interface ignore wildcard" >> /etc/ntp.conf
fi
#interface listen lo
if  grep -r "interface listen lo" /etc/ntp.conf
then 
    echo $ntptextok
else
    echo "Config text not exist on file $ntpconf" 
    echo "Add text to $ntpconf" 
    echo "interface listen lo" >> /etc/ntp.conf
fi
#disable monitor
if "disable monitor" /etc/ntp.conf
then 
    echo $ntptextok
else
    echo "Config text not exist on file $ntpconf" 
    echo "Add text to $ntpconf" 
    echo "disable monitor" >> /etc/ntp.conf
fi
#############
#"Editing: /etc/pam.d/system-auth-ac"
echo "Editing: /etc/pam.d/system-auth-ac"
pamd=/etc/pam.d/system-auth-ac
pamdtextok=$(echo "Text exist on file /etc/pam.d/system-auth-ac, no modification requed")
if "password     requisite   pam_cracklib.so try_first_pass retry=3 type= ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 minlen=12 enforce_for_root" /etc/pam.d/system-auth-ac
then 
    echo $pamdtextok
else
    echo "Config text not exist on file $pamd"
    echo "Add text to $pamd"
    echo "password     requisite   pam_cracklib.so try_first_pass retry=3 type= ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 minlen=12 enforce_for_root" >> /etc/pam.d/system-auth-ac
fi
if "password     sufficient  pam_unix.so sha512 shadow nullok try_first_pass use_authtok" /etc/pam.d/system-auth-ac
then 
    echo $pamdtextok
else
    echo "Config text not exist on file $pamd"
    echo "Add text to $pamd"
    echo "password     sufficient  pam_unix.so sha512 shadow nullok try_first_pass use_authtok" >> /etc/pam.d/system-auth-ac
fi
