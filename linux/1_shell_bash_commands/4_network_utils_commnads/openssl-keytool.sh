#see full chain of cert
#That command connects to the desired website and pipes the certificate in PEM format on to another openssl command that reads and parses the details.
#https://serverfault.com/questions/661978/displaying-a-remote-ssl-certificate-details-using-cli-tools
echo | openssl s_client -showcerts -servername gnupg.org -connect gnupg.org:443 2>/dev/null | openssl x509 -inform pem -noout -text

#fetch cert from site
echo | openssl s_client -connect google.com:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > google_certificate.crt

#Как правильно собрать цепочку сертификатов
https://www.digicert.com/kb/ssl-support/pem-ssl-creation.htm

#commands to create self-sighned sert
openssl genrsa -out private.key 2048
openssl req -new -key private.key -out server.csr
openssl x509 -req -days 365 -in server.csr -signkey private.key -out server.crt
#if need java-keystore
cat server.crt private.key | tee my.pem
openssl pkcs12 -export -out keystore.p12 -inkey my.pem -in my.pem
keytool -importkeystore -destkeystore keystore.jks -srcstoretype PKCS12 -srckeystore keystore.p12
#генерация самоподписного сертификата oneliner
openssl req -newkey rsa:4096 -nodes -sha256 -subj '/CN=localhost/O=domain/C=RU/ST=KRD/L=Krasnodar' \
-keyout domain.local.key -x509 -days 365 -out domain.local.crt
#or
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout ca.key -out ca.crt -subj "/CN=localhost/O=domain/C=RU/ST=KRD/L=Krasnodar" -addext "subjectAltName = DNS:localhost"
#or same without CommonName
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout ca.key -out ca.crt -subj "/C=RU/ST=KRD/L=Krasnodar"

#with pem
openssl genrsa -out private.key 2048 && \
openssl req -new -subj '/CN=localhost/O=domain/C=RU/ST=KRD/L=Krasnodar' -key private.key -out cert.csr && \
openssl x509 -req -in cert.csr -signkey private.key -out cert.crt -days 3650 && \
cat cert.crt > my.pem && cat private.key >> my.pem

#Random password generation
openssl rand -base64 12

#Get cert CA
openssl s_client -showcerts -servername server -connect server:443 > cacert.pem
#copy cert from coderepotst
openssl s_client -showcerts -servername coderepotst.corp.domain.ru -connect coderepotst.corp.domain.ru:443 > cacert.pem
#best way(fetch only cert woithout tech-info)
#https://access.redhat.com/solutions/4799921
openssl s_client -connect ${URL}:22623 -showcerts </dev/null 2>/dev/null|openssl x509 -outform PEM > api-int.pem
---------------------------------------------------------------------------------------------

#генерация кейстора из сертификата и ключа
openssl pkcs12 -export -in journal-sp.corp.domain.ru.crt -inkey journal-sp.corp.domain.ru.key -out keystore.jks -name tomcat

#add certs to mozilla-truststore
sudo dpkg-reconfigure -f noninteractive ca-certificates

#show cert information(*.crt or *.pem)
openssl x509 -in CertName.crt -text -noout


#PFX to crt
#https://www.ibm.com/support/knowledgecenter/SSVP8U_9.7.0/com.ibm.drlive.doc/topics/r_extratsslcert.html
#Run the following command to extract the certificate:
openssl pkcs12 -in [yourfile.pfx] -clcerts -nokeys -out [drlive.crt]
#Run the following command to extract the private key:
openssl pkcs12 -in [yourfile.pfx] -nocerts -out [drlive.key]
#remove passphrase from key
openssl rsa -in keyfile.key -out keyfile_nopass.key

#old pfx ( openssl v3 will show error)
#cert
docker run -v ~/Documents/user_certs/:/work -it ubuntu:16.04 /bin/bash -c \
"apt update && apt install openssl -y && openssl pkcs12 -in /work/cert.pfx -clcerts -nokeys -out /work/cert.crt"
#key
docker run -v ~/Documents/user_certs/:/work -it ubuntu:16.04 /bin/bash -c \
"apt update && apt install openssl -y && openssl pkcs12 -in /work/cert.pfx -nocerts -out /work/cert.key"
#decrypt key
docker run -v ~/Documents/user_certs/:/work -it ubuntu:16.04 /bin/bash -c \
"apt update && apt install openssl -y && openssl rsa -in /work/cert.key -out /work/cert_decrypted.key"


#rename cert(s) to it(s) common name
#https://unix.stackexchange.com/questions/368123/how-to-extract-the-root-ca-and-subordinate-ca-from-a-certificate-chain-in-linux
for cert in *.pem; do newname=$(openssl x509 -noout -subject -in $cert | sed -n 's/^.*CN=\(.*\)$/\1/; s/[ ,.*]/_/g; s/__/_/g; s/^_//g;p').pem; mv $cert $newname; done

#check certs in keystore
keytool -v -list -keystore keystore/keystore.jks

# add certs to OS truststore
#CentOS7
yum install -y ca-certificates
update-ca-trust force-enable
sudo ln -s /etc/ssl/your-cert.pem /etc/pki/ca-trust/source/anchors/your-cert.pem
update-ca-trust
#Ubuntu
Copy your CA to dir /usr/local/share/ca-certificates/
sudo update-ca-certificates

#generate passwords with openssl
#-6 specifies SHA512. Use -5 for SHA256. Avoid -1 for MD5, if possible.
#Generate MD5 passwords
openssl passwd -1 -salt SaltSalt SecretPassword
#Generate DES passwords
openssl passwd -crypt -salt XR SecretPassword



#errors
# update-ca-trust not adding certificates to ca-bundle
https://access.redhat.com/solutions/3220561
#check certs
openssl crl2pkcs7 -nocrl -certfile /etc/pki/tls/certs/ca-bundle.crt | openssl pkcs7 -print_certs | grep subject | head


# keytool
#delete cert fron truststore
keytool -delete -alias "server.com (go daddy secure certificate authority - g2)" -keystore truststore.jks  -storepass changeit
#list certs fron truststore
keytool -list -v -keystore truststore.jks -storepass changeit
#add cert fron truststore
keytool -import -alias server.com -file server.crt -storetype JKS -keystore truststore.jks -storepass changeit
