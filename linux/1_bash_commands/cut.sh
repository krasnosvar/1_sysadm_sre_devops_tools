#list all users
sudo cat /etc/passwd | grep home | grep -v nologin| cut -d ':' -f 1
