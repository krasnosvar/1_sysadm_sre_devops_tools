# terraform for Yandex Cloud

0. yandex tander federation link
* https://console.cloud.yandex.ru/federations/bpfsbv43mnjahtv4sp6q


1. Install YC cli
* https://cloud.yandex.ru/docs/cli/operations/install-cli
```
#macos
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | zsh
source "~/.zshrc"

#linux with bash
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```


2. Configure YC
```
# yc init --federation-id=

```


3. Create service account with role ```k8s.admin``` and create key-file for access
* https://cloud.yandex.com/en/docs/managed-kubernetes/security/

* https://cloud.yandex.ru/docs/iam/operations/sa/create
* https://cloud.yandex.ru/docs/iam/concepts/access-control/roles#compute-admin
```
yc iam service-account create --name svc-yc-kuber-tst \
  --description "service account for creation tst kube clusters"

id: 
folder_id: 
created_at: "2022-10-19T07:52:31.585871653Z"
name: svc-kuber-tst
description: service account for creation tst kube clusters


yc resource-manager folder add-access-binding cb-tech \
  --role k8s.admin --role viewer \
  --subject serviceAccount:<id>

# kreate key-file for access
yc iam service-account --folder-name tech list 



yc iam key create --service-account-name svc-yc-kuber-tst --output svc-yc-kuber-tst.json
```

4. fetch subnets for cluster ( nets and subnets created by cloud-admins, not us)
```
yc vpc network list-subnets default

```


5. list kuber versions ( for TF script)
```
yc managed-kubernetes list-versions


+-----------------+------------------------+
| RELEASE CHANNEL |        VERSIONS        |
+-----------------+------------------------+
| RAPID           | 1.20, 1.21, 1.22, 1.23 |
| REGULAR         | 1.20, 1.21, 1.22       |
| STABLE          | 1.20, 1.21, 1.22       |
+-----------------+------------------------+
```

6. cmd's for creation-deletion
```
terraform apply -auto-approve
terraform destroy -auto-approve
```

7. TODO:
* parametrize for ```zonal-regional```
* parametrize for ```dev-prod-test```
