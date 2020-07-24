##############################################################################################
#LDAP
#с одинарными кавычками в пароле может быть двже пробел
oc create secret generic ldap-secret --from-literal=bindPassword='password' -n openshift-config
vi ldap-config.yaml
oc apply -f ldap-config.yaml
oc get pod -n openshift-authentication

#see auth logs in pods
for i in $(oc get pod -n openshift-authentication| awk '{print $1}'); do oc logs $i -n openshift-authentication; done| grep krasnosvarov

##############################################################################################
#ldap-config.yaml allow users by search string
#https://access.redhat.com/solutions/3510401
      url: "ldap://adtest1.corp.domain.ru/OU=Users,OU=gk,DC=corp,DC=domain,DC=ru?sAMAccountName(&(objectclass=*)(|(memberOf=CN=nix_adm,OU=Groups,OU=gk,DC=corp,DC=domain,DC=ru)(memberOf=CN=medvedev_a,OU=Users,OU=ITLab,OU=gk,DC=corp,DC=domain,DC=ru)))"



ldapsearch -h dc1 -D "CN=Administrator,CN=Users,DC=test,DC=local" -b "DC=test,DC=local" -W -s sub "(cn=Guest)"
