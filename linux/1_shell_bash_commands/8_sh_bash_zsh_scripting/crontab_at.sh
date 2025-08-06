#list all cron's of user "user"
crontab -u user -l
#open file with cron tasks for "user"
crontab -u otrs -l
#restart cron
service crond restart

#cron on startup(after reboot)
#https://www.cyberciti.biz/faq/linux-execute-cron-job-after-system-reboot/
crontab -e
@reboot rsync -vuarP /home/den/git_projects --exclude 'images/*' * /media/den/240Gb/backup/
#at 0 hours
0 0 * * * docker-compose -f /var/prometheus/docker-compose_server.yml restart pushgateway

#at
#https://linuxize.com/post/at-command-in-linux/
Create a one-time task to reboot the operating system using at.

sudo apt-get install at 
systemctl start atd
systemctl enable atd

echo "sudo shutdown -r now" | at -m now
