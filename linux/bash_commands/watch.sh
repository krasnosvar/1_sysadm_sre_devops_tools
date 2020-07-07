#output command in realtime(default every 2 seconds)
watch systemctl status tomcat

#reduce delay to 0,5 second(minimal time)
watch -n 0,5 ip a