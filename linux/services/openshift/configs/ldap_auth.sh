##############################################################################################
#LDAP
oc create secret generic ldap-secret --from-literal=bindPassword='password' -n openshift-config


apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
  - name: ldapidp 
    mappingMethod: claim 
    type: LDAP
    ldap:
      attributes:
        id: 
        - dn
        email: 
        - mail
        name: 
        - cn
        preferredUsername: 
        - sAMAccountName
      bindDN: "CN=svc_webupdate,OU=Users,OU=Service,DC=corp,DC=domain,DC=ru" 
      bindPassword: 
        name: ldap-secret
      insecure: true
      url: "ldap://adtest1.corp.domain.ru/OU=Users,OU=gk,DC=corp,DC=domain,DC=ru?sAMAccountName"
	