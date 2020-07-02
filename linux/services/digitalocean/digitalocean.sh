#get ssh-keys
#https://developers.digitalocean.com/documentation/v2/#retrieve-an-existing-key
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer b7d03a6947b217efb6f3ec3bd3504582" "https://api.digitalocean.com/v2/account/keys" 
#get ssh-keys by name
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer b7d03a6947b217efb6f3ec3bd3504582" "https://api.digitalocean.com/v2/account/keys&page=2" | jq .ssh_keys[].name
#get ssh-keys by id and mane
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer b7d03a6947b217efb6f3ec3bd3504582" "https://api.digitalocean.com/v2/account/keys?page=3" | jq '.ssh_keys[] | .name, .id'

#get list of images for terraform 
curl -X GET --silent "https://api.digitalocean.com/v2/images?per_page=999" -H "Authorization: Bearer TOKEN" | jq .images[].slug
"ubuntu-14-04-x32-do"
"freebsd-10-4-x64-zfs"
"freebsd-10-4-x64"
"fedora-27-x64"
"centos-6-x32"
"ubuntu-14-04-x64-do"
"centos-6-x64"
"centos-7-x64"
"debian-9-x64"
"ubuntu-19-10-x64"
"ubuntu-16-04-x32"
"ubuntu-16-04-x64"
"debian-10-x64"
"fedora-31-x64"
"centos-8-x64"
"rancheros"
"freebsd-12-x64"
"freebsd-12-x64-zfs"
"coreos-alpha"
"coreos-beta"
"coreos-stable"
----------------------------------------------------------------
#list all droplest(size, region)
#https://developers.digitalocean.com/documentation/v2/#list-all-droplets
curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer b7d03a6947b217efb6f3ec3bd3504582" "https://api.digitalocean.com/v2/droplets?page=1&per_page=1" | jq
        "regions": [
          "nyc3",
          "nyc1",
          "sfo1",
          "nyc2",
          "ams2",
          "sgp1",
          "lon1",
          "nyc3",
          "ams3",
          "fra1",
          "tor1",
          "sfo2",
          "blr1",
          "sfo3"

        "sizes": [
          "s-1vcpu-1gb",
          "512mb",
          "s-1vcpu-2gb",
          "1gb",
          "s-3vcpu-1gb",
          "s-2vcpu-2gb",
          "s-1vcpu-3gb",
          "s-2vcpu-4gb",
          "2gb",
          "s-4vcpu-8gb",
          "m-1vcpu-8gb",
          "c-2",
          "4gb",
          "g-2vcpu-8gb",
          "gd-2vcpu-8gb",
          "m-16gb",
          "s-6vcpu-16gb",
          "c-4",
          "8gb",
          "m-2vcpu-16gb",
          "m3-2vcpu-16gb",
          "g-4vcpu-16gb",
          "gd-4vcpu-16gb",
          "m6-2vcpu-16gb",
          "m-32gb",
          "s-8vcpu-32gb",
          "c-8",
          "16gb",
          "m-4vcpu-32gb",
          "m3-4vcpu-32gb",
          "g-8vcpu-32gb",
          "s-12vcpu-48gb",
          "gd-8vcpu-32gb",
          "m6-4vcpu-32gb",
          "m-64gb",
          "s-16vcpu-64gb",
          "c-16",
          "32gb",
          "m-8vcpu-64gb",
          "m3-8vcpu-64gb",
          "g-16vcpu-64gb",
          "s-20vcpu-96gb",
          "48gb",
          "gd-16vcpu-64gb",
          "m6-8vcpu-64gb",
          "m-128gb",
          "s-24vcpu-128gb",
          "c-32",
          "64gb",
          "m-16vcpu-128gb",
          "m3-16vcpu-128gb",
          "s-32vcpu-192gb",
          "m-24vcpu-192gb",
          "m-224gb",
          "m6-16vcpu-128gb",
          "m3-24vcpu-192gb",
          "m6-24vcpu-192gb"
