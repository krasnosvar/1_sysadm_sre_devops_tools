#generate passwords with openssl
#-6 specifies SHA512. Use -5 for SHA256. Avoid -1 for MD5, if possible.
#Generate MD5 passwords
openssl passwd -1 -salt SaltSalt SecretPassword
#Generate DES passwords
openssl passwd -crypt -salt XR SecretPassword
#Random password generation
openssl rand -base64 12

# KUBERNETES k8s
#get cert from kube secret
kubectl get secret your-secret-name -n your-namespace -o json | jq '."data"."tls.crt"'| sed 's/"//g'| base64 -d -

# get cert or cert INFO
#see full chain of cert
#That command connects to the desired website and pipes the certificate in PEM format on to another openssl command that reads and parses the details.
#https://serverfault.com/questions/661978/displaying-a-remote-ssl-certificate-details-using-cli-tools
echo | openssl s_client -showcerts -servername gnupg.org -connect gnupg.org:443 2>/dev/null | openssl x509 -inform pem -noout -text
#fetch cert from site
echo | openssl s_client -connect google.com:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > google_certificate.crt
#best way(fetch only cert woithout tech-info)
#https://access.redhat.com/solutions/4799921
openssl s_client -connect ${URL}:22623 -showcerts </dev/null 2>/dev/null|openssl x509 -outform PEM > api-int.pem


# Working with local files ( certs )
#show ( cert as file ) information(*.crt or *.pem)
openssl x509 -text -noout -in CertName.crt 
openssl x509 -noout -ext subjectAltName -in CertName.crt
#rename cert(s) to it(s) common name
#https://unix.stackexchange.com/questions/368123/how-to-extract-the-root-ca-and-subordinate-ca-from-a-certificate-chain-in-linux
for cert in *.pem; do newname=$(openssl x509 -noout -subject -in $cert | sed -n 's/^.*CN=\(.*\)$/\1/; s/[ ,.*]/_/g; s/__/_/g; s/^_//g;p').pem; mv $cert $newname; done
#fetch all certs from pem-bundle via while loop
while openssl x509 -noout -text; do :; done < cert-bundle.pem


#commands to create self-sighned sert
openssl genrsa -out private.key 2048
openssl req -new -key private.key -out server.csr
openssl x509 -req -days 365 -in server.csr -signkey private.key -out server.crt
#self-sighned sert oneliner with "CN" ( CommonName )
openssl req -newkey rsa:4096 -nodes -sha256 -subj '/CN=localhost/O=domain/C=RU/ST=KRD/L=Krasnodar' \
-keyout domain.local.key -x509 -days 365 -out domain.local.crt
# same with DNS
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout ca.key -out ca.crt -subj \
"/CN=localhost/O=domain/C=RU/ST=KRD/L=Krasnodar" -addext "subjectAltName = DNS:localhost"
#or same without CA and DNS
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -keyout ca.key -out ca.crt -subj "/C=RU/ST=KRD/L=Krasnodar"



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


#errors
# update-ca-trust not adding certificates to ca-bundle
https://access.redhat.com/solutions/3220561
#check certs
openssl crl2pkcs7 -nocrl -certfile /etc/pki/tls/certs/ca-bundle.crt | openssl pkcs7 -print_certs | grep subject | head



#add certs to mozilla-truststore
sudo dpkg-reconfigure -f noninteractive ca-certificates
# add certs to OS truststore
#CentOS7
yum install -y ca-certificates
update-ca-trust force-enable
sudo ln -s /etc/ssl/your-cert.pem /etc/pki/ca-trust/source/anchors/your-cert.pem
update-ca-trust
#Ubuntu
Copy your CA to dir /usr/local/share/ca-certificates/
sudo update-ca-certificates



# keytool
# nstall keytool in Ubuntu
sudo apt install openjdk-8-jre-headless
# install keytool on MACOS
brew install openjdk@8
echo 'export PATH="/usr/local/opt/openjdk@8/bin:$PATH"' >> ~/.zshrc
#list certs from truststore
keytool -list -v -keystore truststore.jks -storepass changeit
#delete cert from truststore
keytool -delete -alias "server.com (go daddy secure certificate authority - g2)" -keystore truststore.jks  -storepass changeit
#add (import) cert to truststore
keytool -import -alias server.com -file server.crt -storetype JKS -keystore truststore.jks -storepass changeit
#or
#https://docs.redhat.com/en/documentation/red_hat_jboss_data_virtualization/6.2/html/security_guide/add_a_certificate_to_a_truststore_using_keytool#Add_a_Certificate_to_a_Truststore_Using_Keytool
keytool -import -alias teiid -file public.cert -storetype JKS -keystore server.truststore

# move keystore from old format to pkcs12
keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.jks -deststoretype pkcs12

#if need java-keystore
# keystore - for clients certs-keys
# trusstore - for CA-certs
# cert and key in one keystore
# 1. create *.p12 file via openssl ( we cannot add certs-keys in plain format )
openssl pkcs12 -export -in client-cert.pem -inkey key-client.pem -name client-domain-alias > client.p12
# 2. import *.p12 to JKS keystore
keytool -importkeystore -srckeystore client.p12 -destkeystore keystore.jks -srcstoretype pkcs12 -alias client-domain-alias 
# or 
cat server.crt private.key | tee my.pem
openssl pkcs12 -export -out keystore.p12 -inkey my.pem -in my.pem
keytool -importkeystore -destkeystore keystore.jks -srcstoretype PKCS12 -srckeystore keystore.p12

