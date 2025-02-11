---------------------------------------------------------------------------------------------
#most used oneliners
#update ubuntu apps ( apt and snap, and remove older versions of snaps)
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo snap refresh && snap list --all | \
awk '/disabled/{print $1, $3}' | while read name rev; do sudo snap remove "$name" --revision="$rev"; done && \
flatpak update -y && sudo pip3 list --outdated | awk 'NR>2{print $1}'| xargs pip3 install -U && \
pip3 list --outdated | awk 'NR>2{print $1}'| xargs pip3 install -U


#update fedore apps
sudo dnf update -y && \
flatpak update --force-remove -y


#git
git add . && git commit -m "add ldapsearch info" && git push
#backup
# backup_dir=/media/den/1tb_wd/backup; \
backup_dir=/media/veracrypt1/backup; \
rsync -vuarPp /home/den/git_projects $backup_dir && \
rsync -vuarP ~/.bashrc $backup_dir && \
rsync -vuarP ~/.zshrc $backup_dir && \
rsync -vuarP -r ~/.zsh_history $backup_dir
rsync -vuarP /etc/environment $backup_dir && \
rsync -vuarP ~/.vimrc $backup_dir && \
rsync -vuarP -r ~/.byobu $backup_dir && \


#generate self-sighned cert oneliner
openssl req -newkey rsa:4096 -nodes -sha256 -subj '/CN=localhost/O=domain/C=RU/ST=KRD/L=Krasnodar' \
-keyout domain.local.key -x509 -days 365 -out domain.local.crt
#with pem
openssl genrsa -out private.key 2048 && \
openssl req -new -subj '/CN=localhost/O=domain/C=RU/ST=KRD/L=Krasnodar' -key private.key -out cert.csr && \
openssl x509 -req -in cert.csr -signkey private.key -out cert.crt -days 3650 && \
cat cert.crt > my.pem && cat private.key >> my.pem

#Random password generation
openssl rand -base64 12

#сгенерировать ключ одной командой(для скриптов), without passphrase
ssh-keygen -b 2048 -t rsa -f /path/to/file/ssh_key_name -q -N ""

#erase external USB-stick
sudo dd if=/dev/zero of=/dev/sdc bs=1M && sync

#change pass in one line command ( only by root)
echo "passssssword" | passwd root --stdin > /dev/null
#or
echo root:passssssword | chpasswd

# for-loop example
#ping последовательно диапазона адресов
for ((i=120; i <= 130; i++)) do ping -c 1 192.168.43.$i; done
#or
for i in {120..130}; do ping -c 1 192.168.43.$i; done

# curl with only HTTP-code putput
for i in {1..100}; do echo $i && curl -s -o /dev/null -w "%{http_code}\n" https://site.domain; done
# in alpine ash
for i in $(seq 100); do echo $i && curl -s -o /dev/null -w "%{http_code}\n" https://site.domain; done

#del toor processes (to delete user for example)
ps aux | awk '/^toor/ {print $2}' | xargs kill -9

#rename all files with *.txt extension
yum -y install rename
rename 's/\.txt$/.text/' *.txt

#Change word in all files in exiting directory recursively
cd /tmp/test
find . -type f -exec sed -i  "s/OLDPASSWD/NEWPASSWD/g" {} +
#Find in /etc/ and change IP-address in all files(*-asterisk if IP written with port(for example)), errors output in devnull
find /etc/ -type f -exec sed -i 's/10.8.181.95*/10.5.10.149/g' {} + 2> /dev/null

#clear deleted files
for i in $(find /proc/*/fd -ls | grep  '(deleted)' | awk '{print $11}'); do echo ''> $i; done

#one-liner command to get certs(nginx must be on, certbot place file to check in "webroot-path")
#centos
certbot certonly --agree-tos --email blabla@mail.com --webroot --webroot-path /usr/share/nginx/html -n -d domain.net
#ubuntu
certbot certonly --agree-tos --email blabla@mail.com --webroot --webroot-path /var/www/html -n -d domain.net
#certs will be in: /etc/letsencrypt/live/

#remove spaces from filenames
for f in *; do mv "$f" `echo $f | tr ' ' '_'`; done


#create sleep, fetch PID and renice it
( sleep 10000 & echo $! >&3 ) 3>pid | renice -n 15 -p $(<pid)


