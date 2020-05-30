token = ""
access-key = ""
secret-key = ""
awszoneid = ""

#list all keys
#curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer " "https://api.digitalocean.com/v2/account/keys" 


# curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer " "https://api.digitalocean.com/v2/account/keys?page=12" | jq .ssh_keys[6]
