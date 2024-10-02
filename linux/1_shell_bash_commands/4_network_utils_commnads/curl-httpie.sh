#use curl without proxy
curl  --noproxy "*"

# curl with certs
curl --cert your-domain.crt --key your-domain.key --cacert ca-your-domain.crt https://your-domain.com

#do 10 curl's
curl http://localhost:80/[1-10]

#Request type -X (GET by default):
curl -X GET http://www.example.com
curl -X POST http://www.example.com -d '{"variable": "value"}'
curl -X POST http://www.example.com -d @filename.json

#download file with CURL instead of WGET
curl -O http://www.openss7.org/repos/tarballs/strx25-0.9.2.1.tar.bz2
#download mongo-db public key with CURL and HTTPS
curl -O -k https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -

#POST as JSON
curl -H "Content-Type: application/json" \
  -X POST \
  --data '{"username":"xyz","password":"xyz"}' \
  http://localhost:3000/api/login

 
#POST as JSON-file
curl --insecure \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: $AUTH" \
--data @snapvra.json https://tcloud.corp.domain/catalog-service/api/consumer/entitledCatalogItems/b7210569-ce4b-4110-b123-a58f8682fb67/requests| python -m json.tool

##curl and unzip file from URL
file=consul_1.8.3_linux_amd64.zip;  curl -O https://releases.hashicorp.com/consul/1.8.3/$file && unzip $file && rm -rf $file


#return only response code
#https://stackoverflow.com/questions/38906626/curl-to-return-http-status-code-along-with-the-response
curl -o /dev/null -s -w "%{http_code}\n" https://google.com
# with certs
curl -s -o /dev/null -w "%{http_code}" --cert domain.crt --key domain.key --cacert ca-domain.crt https://domain.com 


# ERRORS
# awoid 302 error
curl --location https://site.domain




#############################################################################
#httpie
#apt install httpie -y
#https://devhints.io/httpie
#https://github.com/httpie/httpie

http POST http://example.com/posts/3 \
    Origin:example.com \  # :   HTTP headers
    name="John Doe" \     # =   string
    q=="search" \         # ==  URL parameters (?q=search)
    age:=29 \             # :=  for non-strings
    list:='[1,3,4]' \     # :=  json
    file@file.bin \       # @   attach file
    token=@token.txt \    # =@  read from file (text)
    user:=@user.json      # :=@ read from file (json)

#Options
-v, --verbose            # same as --print=HhBb --all
-h, --headers            # same as --print=h
-b, --body               # same as --print=b
    --all                # print intermediate requests
    --print=HhBb         # H: request headers
                         # B: request body
                         # h: response headers
                         # b: response body
    --pretty=none        # all | colors | format
    --json | -j          # Response is serialized as a JSON object.

#Auth
    --session NAME
-a, --auth USER:PASS
    --auth-type basic
    --auth-type digest
