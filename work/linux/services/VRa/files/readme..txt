#Creating a snapshot via the vRA API
https://tisgoud.nl/creating-a-snapshot-via-the-vra-api/

#How to script a vRealize Automation 7 REST API request
www.vmtocloud.com/how-to-script-a-vrealize-automation-7-rest-api-request/tcloud.corp.domain.rutcloud.corp.domain.ru

#https://katello.corp.domain.ru/job_templates/138-Upd%20all%20pkg%20with%20snapshot/edit



#https://github.com/ATIX-AG/foreman_snapshot_management
#Upd all pkg with snapshot
#create snapshot
unset http_proxy
unset https_proxy
unset ftp_proxy
curl -k -s -u "admin:obvJrxJ9fUzpp58o" -X POST -H 'Accept: application/json' -H 'Content-Type: application/json' --data "{ \"name\": \"<%= input("name") %>\", \"description\": \"<%= input("description") %>\", \"include_ram\": \"false\" }" "https://<%= @host.puppetmaster %>/api/v2/hosts/<%= @host %>/snapshots"
if [ $? -ne 0 ]
then
    echo "!!!!!!!!!!!!!!SNAPSHOT NOT CREATED. JOB CANCELED!!!!!!!!!!!!"
    exit 1
fi
sleep 600
netstat -ntulp > /root/ports
yum update --nogpgcheck -t -y <%= input("yum_opts") %> > /tmp/katello_update
if grep 'Complete!' /tmp/katello_update > /dev/null
then
    shutdown -r 1
else
    echo "!!!!!!!!!!!!!!!!!!!!!SYSTEM IS NOT UPDATED!!!!!!!!!!!!!"
    exit 1
fi


#API VRa user:
#corp\svc_katello



#вывести общий список джейсон-файлом
curl --insecure -H "Accept: application/json" -H "Authorization: $AUTH" https://tcloud.corp.domain.ru/catalog-service/api/consumer/entitledCatalogItems | python -m json.tool

#save snapshot template in file
curl --insecure -H "Accept: application/json" -H "Authorization: $AUTH" https://tcloud.corp.domain.ru/catalog-service/api/consumer/entitledCatalogItems/b7210569-ce4b-4110-b123-a58f8682fb67/requests/template | python -m json.tool > /tmp/snapshot-vra_svc-katello.json


#create snapshot
curl --insecure -H "Accept: application/json" -H "Authorization: $AUTH" https://tcloud.corp.domain.ru/catalog-service/api/consumer/entitledCatalogItems/b7210569-ce4b-4110-b123-a58f8682fb67/requests --data @snapvra.json --verbose -H "Content-Type: application/json" | python -m json.tool