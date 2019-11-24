#!/bin/bash

#pip install vmware-nsx


#Ссылка для получения шаблона ДЖСОН-запроса на создание снапшота от самой ВРА 
#curl --insecure -H "Accept: application/json" -H "Authorization: $AUTH" https://tcloud.corp.domain.ru/catalog-service/api/consumer/entitledCatalogItems/b7210569-ce4b-4110-b123-a58f8682fb67/requests/template | python -m json.tool > /tmp/snapshot-vra_svc-katello.json


#Получаем от ВРА токен по доменной учетке, плюс через АВК убираем лишние символы при выдаче ответа 
export vAPI_TOKEN=`curl -s --insecure -H "Accept: application/json" -H 'Content-Type: application/json' --data '{"username":"krasnosvarov_dn","password":"PASSWD","tenant":"magnit"}' https://tcloud.corp.domain.ru/identity/api/tokens | cut -d\: -f5 | cut -d\, -f1 | awk '{print substr($0, 2, length($0) - 2)}' | tr -d "\n"`

echo "Answer from VRa API:"

#Экспортируем как переменную токен, попутно приделывая ему Бирер, чтобы ВРА его опознавала 
echo $vAPI_TOKEN
export AUTH="Bearer ${vAPI_TOKEN}"
echo "Bearer TOKEN:"
echo $AUTH

#Даты создания и удаления снапшота, только в таком формате ВРА принимает(хотя по общим стандартам ДЖСОН вроде и попроще можно)
start_snap_date=`date +"%FT%T.000Z" -d "$end_date+5 minutes"`
end_snap_date=`date +"%FT%T.000Z" -d "$end_date+3 days"`


#Начало цикла для чтения списка серверов из файла list_servers.txt
for server in `cat list_servers.txt`; do
#=====================================================================
#В закоментированном ниже фрагменте не удалось передать ДЖСОН-формат

# json_data="'{ 
#     "businessGroupId": "c19acbcc-b592-4615-a885-e195ceca362d",
#     "catalogItemId": "b7210569-ce4b-4110-b123-a58f8682fb67",
#     "data": { 
#         "CreateDate": "$start_snap_date",
#         "SnapName": "Test_Snap",
#         "toAddressList": "krasnosvarov_dn@magnit.ru",
#         "vmName": "$server",
#         "workflowScheduleDate": "$end_snap_date"
#     },
#     "description": null,
#     "reasons": null,
#     "requestedFor": "krasnosvarov_dn@corp.domain.ru",
#     "type": "com.vmware.vcac.catalog.domain.request.CatalogItemProvisioningRequest"}'"
#=========================================================================================

#Удалось передать в таком формате, создаю переменную с телом ДЖСОН-данных, пришлось слэшами экранировать кавычки чтобы они оставались в выводе, более простого способа не нашел
json_data="'{\"businessGroupId\": \"c19acbcc-b592-4615-a885-e195ceca362d\", \"catalogItemId\": \"b7210569-ce4b-4110-b123-a58f8682fb67\", \"data\": { \"CreateDate\": \"$start_snap_date\", \"SnapName\": \"Test_Snap\", \"toAddressList\": \"krasnosvarov_dn@magnit.ru\", \"vmName\": \"$server\", \"workflowScheduleDate\": \"$end_snap_date\" }, \"description\": null, \"reasons\": null, \"requestedFor\": \"krasnosvarov_dn@corp.domain.ru\", \"type\": \"com.vmware.vcac.catalog.domain.request.CatalogItemProvisioningRequest\"}'"

#Вывожу ДЖСОН в файл
echo $json_data > snapvra.json

#По ссылке нашел регулярку седа для убирания одинарных кавычек, которые остаются при выполнении предыдущей команды
#http://qaru.site/questions/61556/stripping-single-and-double-quotes-in-a-string-using-bash-standard-linux-commands-only
noquotes_text=`sed "s/^\([\']\)\(.*\)\1\$/\2/g" snapvra.json`

#Раскавыченный правильный ДЖСОН снова выводим в файл
echo $noquotes_text > snapvra.json


#Выполняем КУРЛ-запрос в ВРА, данные берем из ДЖСОН-файла
curl --insecure \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: $AUTH" \
--data @snapvra.json https://tcloud.corp.domain.ru/catalog-service/api/consumer/entitledCatalogItems/b7210569-ce4b-4110-b123-a58f8682fb67/requests| python -m json.tool

#Конец цикла
done
