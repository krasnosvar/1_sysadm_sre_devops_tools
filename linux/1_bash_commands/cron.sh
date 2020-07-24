#list all cron's of user "user"
crontab -u user -l
#open file with cron tasks for "user"
crontab -u otrs -l
#restart cron
service crond restart
