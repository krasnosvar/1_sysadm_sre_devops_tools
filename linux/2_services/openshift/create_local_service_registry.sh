#Сборка локального регистри
#install required packages
yum -y install podman httpd-tools
#create dirs
mkdir -p /opt/registry/{auth,certs,data}
ll /home/local/
#copy host certs(need for registry)
cp /home/local/* /opt/registry/certs/
ll /opt/registry/certs/
rm /opt/registry/certs/doma-x509 
rm /opt/registry/certs/reg* 
ll /opt/registry/certs/
htpasswd -bBc /opt/registry/auth/htpasswd admin admin
systemctl status firewalld
firewall-cmd --add-port=5000/cp --zone=internal --permanent
firewall-cmd --add-port=5000/tcp --zone=public   --permanent
firewall-cmd --reload
podman run --name mirror-registry -p 5000:5000 -v /opt/registry/data:/var/lib/registry:z -v /opt/registry/auth:/auth:z -e "REGISTRY_AUTH=htpasswd" -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd -v /opt/registry/certs:/certs:z -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/v00opshift08tst.ocp4.corp.domain.ru.cer -e REGISTRY_HTTP_TLS_KEY=/certs/v00opshift08tst.ocp4.corp.domain.ru.key -e REGISTRY_COMPATIBILITY_SCHEMA1_ENABLED=true -d docker.io/library/registry:2
curl -u admin:admin -k https://v00opshift08tst.ocp4.corp.tander.ru:5000/v2/_catalog

podman ps
podman rm --all --force

[root@v00opshift08tst ~]# echo -n 'admin:admin' | base64 -w0
YWRtaW46YWRtaW4=

jq '.auths += {"v00opshift08tst.ocp4.corp.domain.ru:5000": {"auth": "YWRtaW46YWRtaW4=","email": "notme@localhost"}}' < pull-secret.txt > pull2.txt

export OCP_RELEASE="4.4.3-x86_64" 
export LOCAL_REGISTRY='v00opshift08tst.ocp4.corp.domain.ru:5000' 
export LOCAL_REPOSITORY='ocp4/openshift4' 
export PRODUCT_REPO='openshift-release-dev' 
export LOCAL_SECRET_JSON='/root/pull2.txt' 
export RELEASE_NAME="ocp-release"

#проверка переменных
echo $OCP_RELEASE 
echo $LOCAL_REGISTRY 
echo $LOCAL_REPOSITORY
echo $PRODUCT_REPO
echo $LOCAL_SECRET_JSON
echo $RELEASE_NAME

oc adm -a ${LOCAL_SECRET_JSON} release mirror --from=quay.io/${PRODUCT_REPO}/${RELEASE_NAME}:${OCP_RELEASE} --to=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY} --to-release-image=${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}
oc adm -a /root/pull-isolated.txt release mirror --from=quay.io/openshift-release-dev/ocp-release:4.4.3-x86_64 --to=help1.test.local:5000/ocp443-mirror --to-release-image=help1.test.local:5000/ocp443-mirror:4.4.3-x86_64
oc adm -a ${LOCAL_SECRET_JSON} release extract --command=openshift-install "${LOCAL_REGISTRY}/${LOCAL_REPOSITORY}:${OCP_RELEASE}"

#вывод по окончании установки локального регистри для конфига install-config.yml
imageContentSources:
- mirrors:
  - v00opshift08tst.corp.domain.ru:5000/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - v00opshift08tst.corp.domain.ru:5000/ocp4/openshift4
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev


'{"auths":{"v00opshift08tst.corp.domain.ru:5000": {"auth": "YWRtaW46YWRtaW4=","email": "you@example.com"}}}'


#хз что за команды, просто записал
skopeo inspect docker://v00opshift08tst.corp.tander.ru:5000/rhscl/python-36-rhel7
oc image mirror registry.redhat.io/rhscl/ruby-25-rhel7:latest v00opshift08tst.ocp4.corp.tander.ru:5000/rhscl/ruby-25-rhel7:latest