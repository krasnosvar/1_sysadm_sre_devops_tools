#detailed script output both to file and screen
bash -x 23_dkr.sh 2>&1 | tee output.log
#write command output to file
df -h | tee disk_usage.txt
#write to multiple files
command | tee file1.out file2.out file3.out
#By default the tee command will overwrite the specified file.
#Use the -a (--append) option to append output to file:
command | tee -a file.out
#write to file but don't output to screen
command | tee file.out >/dev/null
#add deb repository to /etc/apt/sources.list
echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | sudo tee -a /etc/apt/sources.list
