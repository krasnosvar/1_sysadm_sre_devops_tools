##############################################################################################
oc edit image.config.openshift.io/cluster

 
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: config.openshift.io/v1
kind: Image
metadata:
  annotations:
    release.openshift.io/create-only: "true"
  creationTimestamp: "2020-06-05T15:59:14Z"
  generation: 1
  name: cluster
  resourceVersion: "1660"
  selfLink: /apis/config.openshift.io/v1/images/cluster
  uid: 7845cd2f-fead-4ce8-97a9-b123f09a2a61
spec:
  additionalTrustedCA:
    name: user-ca-bundle
  registrySources:
    allowedRegistries:
    - v00opshift08tst.ocp4.corp.domain.ru:5000
    - v00rpm-dr.corp.domain.ru
