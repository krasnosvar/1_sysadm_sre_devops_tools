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
podman run --name mirror-registry -p 5000:5000 -v /opt/registry/data:/var/lib/registry:z -v /opt/registry/auth:/auth:z -e "REGISTRY_AUTH=htpasswd" -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd -v /opt/registry/certs:/certs:z -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/v00opshift08tst.corp.domain.ru.cer -e REGISTRY_HTTP_TLS_KEY=/certs/v00opshift08tst.corp.domain.ru.key -e REGISTRY_COMPATIBILITY_SCHEMA1_ENABLED=true -d docker.io/library/registry:2
podman ps

[root@v00opshift08tst ~]# echo -n 'admin:admin' | base64 -w0
YWRtaW46YWRtaW4=


jq '.auths += {"v00opshift08tst.corp.domain.ru:5000": {"auth": "YWRtaW46YWRtaW4=","email": "notme@localhost"}}' < pull-secret.txt > pull2.txt


export OCP_RELEASE="4.4.3-x86_64" && \
export LOCAL_REG='v00opshift08tst.corp.domain.ru:5000' && \
export LOCAL_REPO='ocp4/openshift4' && \
export UPSTREAM_REPO='openshift-release-dev' && \
export LOCAL_SECRET_JSON="/root/pull2.txt" && \
export RELEASE_NAME="ocp-release"
