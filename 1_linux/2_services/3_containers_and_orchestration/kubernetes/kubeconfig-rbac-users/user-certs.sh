# create user certs
# https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/
#create key and csr
openssl genrsa -out myuser.key 2048
openssl req -new -key myuser.key -out myuser.csr -subj "/CN=myuser"
cat myuser.csr | base64 | tr -d "\n"
#create csr object in kube
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: myuser
spec:
  request: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1ZqQ0NBVDRDQVFBd0VURVBNQTBHQTFVRUF3d0dZV3R6YUdGNU1JSUJJakFOQmdrcWhraUc5dzBCQVFFRgpBQU9DQVE4QU1JSUJDZ0tDQVFFQWtNUnAwejh3K0EvTUpNYVgxbnJWcm1MYzRsNGxoVzQzUnRPb1p4bmRIS09jCmJDQ3VzNkpQYS9qaFp6OWFZT0NCSFlERjdPQ29RYWtIV253TGJJc0RvNjBrcXJxU2s1Z2QyTzFLdllQZUppVGIKd3pmakE3ZkVVaVFtOXJGeG5wNmVTNm02d1Z0R3FVOURtOUJMcndzeXlQcE0rckZMdkVockV4ZU1hRnNjazlQUApVY2treVRCQWNBNTROWG0zZ2dwRFA0ZmxVNkRnZFJoQk9zRjhPcFJqY1M5OUdLQjlTa0pEWW9OUGZFRlRFQnNyCjFySmp0Z1JjY241MUFlaGY1UVNjTVlybHFXUzVwdTZhZEdBTWhjQ2szaHpsVXZJdDlhTVVpR1crS0V4L2VPaGUKTlpMZDY0VnFDbkFZcWJHSVI3RDdwaEdQOGdabDZtRFRjVG5UbXpYTEF3SURBUUFCb0FBd0RRWUpLb1pJaHZjTgpBUUVMQlFBRGdnRUJBRVVrb0lXT0ZldlRycGJKcUNCTGx5TUhwZElmK2tYV3ZxWmtBSGFTaFlyQmg3VEU2blp4ClZwK0ZKMG00c3p2WlFSdTdHM05ISlN3SkMveW5WZCs5REs4Q1NiZkZzMlRYVHJtZXA2TzlndTNZSkNqaUVpSysKb0UvTWNnT0t2QWM0NWV6OVdTdlBublJkcGRZY2diS0U4ZW0vd3c0OVIrTWFHa3BDS2Z3WkN5M2tVSE1oK0hregpLWGxqZ0MvUnhRTHNnY0xRZEl6bldZZzhJaGpTWUJZNFdjZ1IycFova1JZUFhVYWVlSURrdTBmSUlpVlhTYjQ0CjE5VzU4WnczWUUyR3d0a2w0ZWNXV1N3ZnJRSlFGcFB0UFVESDBYMEwxSlNZSit3M2ZHRnNXVXJteS9Ta2VYanMKeWd6THlSOVJHNlc5N2tMUUUyNTBPNlFubjVjWHAwUld3aEE9Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF

#check
kubectl get csr
# Approve the CSR:
kubectl certificate approve myuser
# Retrieve the certificate from the CSR:
kubectl get csr/myuser -o yaml
# Export the issued certificate from the CertificateSigningRequest.
kubectl get csr myuser -o jsonpath='{.status.certificate}'| base64 -d > myuser.crt

# ROLES
# Create Role and RoleBinding
kubectl create role developer --verb=create --verb=get --verb=list --verb=update --verb=delete --resource=pods
kubectl create rolebinding developer-binding-myuser --role=developer --user=myuser
# check clusterroles
# https://kubernetes.io/docs/reference/access-authn-authz/rbac/
kubectl get clusterrolebinding
kubectl get clusterroles

# Add to kubeconfig
# The last step is to add this user into the kubeconfig file.
# First, you need to add new credentials:
kubectl config set-credentials myuser --client-key=myuser.key --client-certificate=myuser.crt --embed-certs=true
# Then, you need to add the context:
kubectl config set-context myuser --cluster=kubernetes --user=myuser
# To test it, change the context to myuser:
kubectl config use-context myuser


# create clusterole
k create sa mishelle &&\
kubectl create clusterrole michelle --verb=get,list,watch --resource=nodes &&\
kubectl create clusterrolebinding michelle --clusterrole=michelle --serviceaccount=michelle
