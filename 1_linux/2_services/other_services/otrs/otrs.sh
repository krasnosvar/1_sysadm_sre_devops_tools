#check Mail Queue
#https://doc.otrs.com/doc/manual/admin/6.0/en/html/email-settings.html
cd /opt/otrs/
su -c "bin/otrs.Console.pl Maint::Email::MailQueue --list" -s /bin/bash otrs

