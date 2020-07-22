---------------------------------------------------------------------------------------------
#генерация самоподписного сертификата oneliner
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

echo root:passssssword | chpasswd


#ping последовательно диапазона адресов
for ((i=120; i <= 130; i++)) do ping -c 1 192.168.43.$i; done

#убить процессы пользователя toor (например, для его удаления)
ps aux | awk '/^toor/ {print $2}' | xargs kill -9

#переименовать расширение всех файлов
yum -y install rename
rename 's/\.txt$/.text/' *.txt

#Change word in all files in exiting directory recursively
cd /tmp/test
find . -type f -exec sed -i  "s/OLDPASSWD/NEWPASSWD/g" {} +
#Find in /etc/ and change IP-address in all files(*-asterisk if IP written with port(for example)), errors output in devnull
find /etc/ -type f -exec sed -i 's/10.8.181.95*/10.5.10.149/g' {} + 2> /dev/null

#clear deleted files
for i in $(find /proc/*/fd -ls | grep  '(deleted)' | awk '{print $11}'); do "echo ''> $i"; done
