#list all users
sudo cat /etc/passwd | grep home | grep -v nologin| cut -d ':' -f 1
cut -d ':' -f 1 /etc/passwd
#if multiple spaces in line
#show host ports, opened by docker
ss -ntulp | grep docker| tr -s ' ' | cut -d ' ' -f 5
#change delimiter
cut -d " " -f 1,2 state.txt --output-delimiter='%'
