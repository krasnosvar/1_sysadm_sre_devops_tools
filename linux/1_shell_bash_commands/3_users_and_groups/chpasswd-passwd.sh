#CHPASSWD
#Change password in one line
echo root:password | chpasswd
cat file.txt| chpasswd
echo "Password123" | passwd root --stdin > /dev/null #won't work everywhere
#generate password
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '' #generate random pass
#or
openssl rand -base64 12
#change pass in one line command ( only by root)
echo "passssssword" | passwd root --stdin > /dev/null
#or
echo root:passssssword | chpasswd


#gen pass with "head"
#generate random password with characters and digits only
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''

#more complicated pass
</dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c 13  ; echo
#or (if problems with "tr")
LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 13 ; echo
