#use curl without proxy
curl  --noproxy "*"

#Тип запроса определяется с ключем -X (GET идет по-умолчанию, можно не указывать):
curl -X GET http://www.example.com
curl -X POST http://www.example.com -d '{"variable": "value"}'
curl -X POST http://www.example.com -d @filename.json


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
