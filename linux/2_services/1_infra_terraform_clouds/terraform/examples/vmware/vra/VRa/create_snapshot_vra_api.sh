#!/bin/bash

#pip install vmware-nsx


# Link to get JSON request template for snapshot creation from vRA itself
#curl --insecure -H "Accept: application/json" -H "Authorization: $AUTH" https://tcloud.corp.domain.ru/catalog-service/api/consumer/entitledCatalogItems/b7210569-ce4b-4110-b123-a58f8682fb67/requests/template | python -m json.tool > /tmp/snapshot-vra_svc-katello.json


# Get token from vRA using domain account, plus remove extra characters from response using awk
export vAPI_TOKEN=`curl -s --insecure -H "Accept: application/json" -H 'Content-Type: application/json' --data '{"username":"user","password":"PASSWD","tenant":"magnit"}' https://tcloud.corp.domain.ru/identity/api/tokens | cut -d\: -f5 | cut -d\, -f1 | awk '{print substr($0, 2, length($0) - 2)}' | tr -d "\n"`

echo "Answer from vRA API:"

# Export token as variable, adding Bearer prefix so vRA can recognize it
echo $vAPI_TOKEN
export AUTH="Bearer ${vAPI_TOKEN}"
echo "Bearer TOKEN:"
echo $AUTH

# Snapshot creation and deletion dates, only in this format vRA accepts (although according to general JSON standards, simpler formats should work)
start_snap_date=`date +"%FT%T.000Z" -d "$end_date+5 minutes"`
end_snap_date=`date +"%FT%T.000Z" -d "$end_date+3 days"`


# Start loop to read server list from list_servers.txt file
for server in `cat list_servers.txt`; do
#=====================================================================
# In the commented fragment below, failed to pass JSON format

# json_data="'{ 
#     "businessGroupId": "c19acbcc-b592-4615-a885-e195ceca362d",
#     "catalogItemId": "b7210569-ce4b-4110-b123-a58f8682fb67",
#     "data": { 
#         "CreateDate": "$start_snap_date",
#         "SnapName": "Test_Snap",
#         "toAddressList": "user@domain.local",
#         "vmName": "$server",
#         "workflowScheduleDate": "$end_snap_date"
#     },
#     "description": null,
#     "reasons": null,
#     "requestedFor": "user@corp.domain.ru",
#     "type": "com.vmware.vcac.catalog.domain.request.CatalogItemProvisioningRequest"}'"
#=========================================================================================

# Managed to pass in this format, creating variable with JSON data body, had to escape quotes with slashes so they remain in output, couldn't find a simpler way
json_data="'{\"businessGroupId\": \"c19acbcc-b592-4615-a885-e195ceca362d\", \"catalogItemId\": \"b7210569-ce4b-4110-b123-a58f8682fb67\", \"data\": { \"CreateDate\": \"$start_snap_date\", \"SnapName\": \"Test_Snap\", \"toAddressList\": \"user@domain.local\", \"vmName\": \"$server\", \"workflowScheduleDate\": \"$end_snap_date\" }, \"description\": null, \"reasons\": null, \"requestedFor\": \"user@corp.domain.ru\", \"type\": \"com.vmware.vcac.catalog.domain.request.CatalogItemProvisioningRequest\"}'"

# Output JSON to file
echo $json_data > snapvra.json

# Found regex for sed to remove single quotes that remain after executing previous command
# http://qaru.site/questions/61556/stripping-single-and-double-quotes-in-a-string-using-bash-standard-linux-commands-only
noquotes_text=`sed "s/^\([\']\)\(.*\)\1\$/\2/g" snapvra.json`

# Output the unquoted correct JSON to file again
echo $noquotes_text > snapvra.json


# Execute CURL request to vRA, taking data from JSON file
curl --insecure \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: $AUTH" \
--data @snapvra.json https://tcloud.corp.domain.ru/catalog-service/api/consumer/entitledCatalogItems/b7210569-ce4b-4110-b123-a58f8682fb67/requests| python -m json.tool

# End of loop
done