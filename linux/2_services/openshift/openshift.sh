#OpenShift 4 in an Air Gap (disconnected) environment (Part 2 — installation)
https://medium.com/@two.oes/openshift-4-in-an-air-gap-disconnected-environment-part-2-installation-1dd8bf085fdd
#link ip to out
https://docs.openshift.com/container-platform/4.5/networking/configuring_ingress_cluster_traffic/configuring-ingress-cluster-traffic-ingress-controller.html
https://cloud.ibm.com/docs/openshift?topic=openshift-openshift_routes

#USERS
#make user krasnosvarov_dn cluster-admin
oc adm add-cluster-role cluster-admin krasnosvarov_dn
oc adm policy add-cluster-role-to-user cluster-admin krasnosvarov_dn
#change pass for ldap-system-user(change ldap-secret in ldap config yaml in web)
oc create secret generic ldap-secret --from-literal=bindPassword=qazwsxedc123 -n openshift-config

#WORK WITH REGISTRY
#add registry to cluster
podman login registry.ru --tls-verify=false

#CLUSTER
#login to cluster from bastion
oc login --token=token_from_web --server=https://api.ocp4.cluster.ru:6443

#PROJECT
#create new project
oc new-progect kras

###################################################################################
#LOGS debug
#https://access.redhat.com/solutions/4100741
oc edit authentications.operator.openshift.io
oc get pod -n openshift-authentication
oc logs oauth-openshift-76bbd9475b-sp8z6 -n openshift-authentication
for i in $(oc get pod -n openshift-authentication| awk '{print $1}'); do oc logs $i -n openshift-authentication; done| grep medvedev




#make kras cluster-admin(as kubeadmin)
oc get users 
 3971  08.06.20 12:04:31 oc adm policy add-cluster-role-to-user cluster-admin krasnosvarov_dn

