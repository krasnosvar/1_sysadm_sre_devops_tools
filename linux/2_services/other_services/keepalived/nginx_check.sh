#!/bin/bash
A=`ps -C nginx --no-header | wc -l`
if [ $A -eq 0 ];then
        systemctl start nginx # try start nginx
        sleep 2 # sleep wait for nginx
    if [ `ps -C nginx --no-header | wc -l` -eq 0 ];then
        kill -9 $(pgrep keepalived) #kill keepalived to move vip if nginx fails
    fi
fi
