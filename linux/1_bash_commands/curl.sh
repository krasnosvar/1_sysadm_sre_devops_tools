#use curl without proxy
curl  --noproxy "*"

#Тип запроса определяется с ключем -X (GET идет по-умолчанию, можно не указывать):
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

 

curl --insecure \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: $AUTH" \
--data @snapvra.json https://tcloud.corp.domain.ru/catalog-service/api/consumer/entitledCatalogItems/b7210569-ce4b-4110-b123-a58f8682fb67/requests| python -m json.tool
