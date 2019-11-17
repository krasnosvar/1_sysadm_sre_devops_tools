#print all modules
nginx -V 2>&1|xargs -n1|grep module
