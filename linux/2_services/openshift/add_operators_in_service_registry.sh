#Перенос операторов в сервисный регистри
https://docs.openshift.com/container-platform/4.4/operators/olm-restricted-networks.html

#автодополнение табом команды "oc" 
oc completion bash | sudo tee /etc/bash_completion.d/openshift > /dev/null


podman login --authfile pull2.txt registry.redhat.io


#построили каталог с описанием (кнопочки в вебке)
oc adm catalog build \
    --appregistry-org redhat-operators \
    --from=registry.redhat.io/openshift4/ose-operator-registry:v4.4 \
    --filter-by-os="linux/amd64" \
    --to=v00opshift08tst.ocp4.corp.domain.ru:5000/olm/redhat-operators:v1 \
    -a ${REG_CREDS} \
    --insecure 


#запретить все внешние источники для OperatorHub
oc patch OperatorHub cluster --type json \ -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'


#скачать образы операторов (смирорить операторХаб)
oc adm catalog mirror v00opshift08tst.ocp4.corp.domain.ru:5000/olm/redhat-operators:v1 v00opshift08tst.ocp4.corp.domain.ru:5000  -a /root/pull2.txt --insecure --skip-verification=true
