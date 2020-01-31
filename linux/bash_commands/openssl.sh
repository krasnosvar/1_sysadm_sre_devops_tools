---------------------------------------------------------------------------------------------
#генерация самоподписного сертификата oneliner
openssl genrsa -out private.key 2048 && openssl req -new -subj '/CN=localhost/O=domain/C=RU/ST=KRD/L=Krasnodar' \
-key private.key -out cert.csr && \
openssl x509 -req -in cert.csr -signkey private.key -out cert.crt -days 3650 && \
cat cert.crt > my.pem && cat private.key >> my.pem

#Random password generation
openssl rand -base64 12

#Get cert CA
openssl s_client -showcerts -servername server -connect server:443 > cacert.pem
---------------------------------------------------------------------------------------------

#генерация кейстора из сертификата и ключа
openssl pkcs12 -export -in journal-sp.corp.domain.ru.crt -inkey journal-sp.corp.domain.ru.key -out keystore.jks -name tomcat

#copy cert from coderepotst
openssl s_client -showcerts -servername coderepotst.corp.domain.ru -connect coderepotst.corp.domain.ru:443 > cacert.pem

#commands to create self-sighned sert
openssl genrsa -out private.key 2048
openssl req -new -key private.key -out server.csr
openssl x509 -req -days 365 -in server.csr -signkey private.key -out server.crt
#if neet java-keystore
cat server.crt private.key | tee my.pem
openssl pkcs12 -export -out keystore.p12 -inkey my.pem -in my.pem
keytool -importkeystore -destkeystore keystore.jks -srcstoretype PKCS12 -srckeystore keystore.p12
