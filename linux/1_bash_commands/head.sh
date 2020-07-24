#generate random password with characters and digits only
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''

#more complicated pass
</dev/urandom tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c 13  ; echo
#or (if problems with "tr")
LC_ALL=C tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c 13 ; echo
