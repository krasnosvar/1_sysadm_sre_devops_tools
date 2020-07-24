#list two fields 
#https://stackoverflow.com/questions/34834519/how-do-i-select-multiple-fields-in-jq?rq=1
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer TOKEN" "https://api.digitalocean.com/v2/account/keys?page=3" | jq '.ssh_keys[] | .name, .id'



curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer " "https://api.digitalocean.com/v2/account/keys?page=12" | jq .ssh_keys[6]

curl -X GET --silent "https://api.digitalocean.com/v2/images?per_page=999" -H "Authorization: Bearer TOKEN" | jq .images[].slug

curl -k  -u user:password_or_api_token -X GET -H "Content-Type: application/json"    https://jira.domain.ru/rest/api/2/issue/CIMIT-1622/transitions| jq "." > jira.txt

latest=$(curl -s 'https://raw.githubusercontent.com/grafana/grafana/master/latest.json' | jq -r '.stable')

http http://64.225.109.32/add-to-cart| jq ._items[].price

