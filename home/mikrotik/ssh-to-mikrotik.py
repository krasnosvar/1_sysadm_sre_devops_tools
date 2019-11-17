#python script
#!/usr/bin/env python3

import paramiko 
 
target = '192.168.43.122'

#ssh to mikrotik by login-pass
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(target, username='admin', password='', port=22, look_for_keys=False)

#exec mikrotik command and print output
stdin,stdout,stderr = ssh.exec_command('/interface wireless registration-table print')
print(stdout.read())

############################
#shell script with arguments
############################
#launch script command and parse it output in "txt" file
#./micro.py | awk 'NR > 1 {print $3}'| xargs -I'{}' echo $(date +%T) "{}" >> worker_time-$(date +%y%m%d)


