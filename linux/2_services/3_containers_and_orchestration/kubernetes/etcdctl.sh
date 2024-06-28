https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster
https://github.com/etcd-io/website/blob/main/content/en/docs/v3.5/op-guide/recovery.md

#Получите доступ к etcd кластера с помощью консольной команды etcdctl. 
#Создайте key=value пару с произвольными значениями.  
#Составьте команду вывода данных, созданных в предыдущем пункте. Команду и вывод сохраните.
#install etcdctl
#https://github.com/etcd-io/etcd/releases
ETCD_VER=v3.4.9
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
/tmp/etcd-download-test/etcdctl version
cp /tmp/etcd-download-test/etcdctl /usr/local/sbin/

#Записать и прочитать пару ```foo-k8s-ex6 bar-k8s-ex6```
etcdctl --endpoints 127.0.0.1:2379 --cacert /var/lib/minikube/certs/etcd/ca.crt  --cert /var/lib/minikube/certs/etcd/server.crt --key /var/lib/minikube/certs/etcd/server.key put foo-k8s-ex6 bar-k8s-ex6
OK
etcdctl --endpoints 127.0.0.1:2379 --cacert /var/lib/minikube/certs/etcd/ca.crt  --cert /var/lib/minikube/certs/etcd/server.crt --key /var/lib/minikube/certs/etcd/server.key get foo-k8s-ex6
foo-k8s-ex6
bar-k8s-ex6


#ETCD backup
sudo apt install etcd-client
# https://k21academy.com/docker-kubernetes/etcd-backup-restore-in-k8s-step-by-step/
# check stastic pod file path
cat /var/lib/kubelet/config.yaml| grep staticPodPath
#check ETCD configuration
cat /etc/kubernetes/manifests/etcd.yaml
# backup ETCD
ETCDCTL_API=3 etcdctl snapshot save snapshot.db \
--cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key \
--endpoints https://127.0.0.1:2379
# check backup 
ETCDCTL_API=3 etcdctl snapshot status --write-out=table snapshot.db

#restore backup
rm -rf /var/lib/etcd
ETCDCTL_API=3 etcdctl snapshot restore snapshot.db --data-dir=/var/lib/etcd
