# fix 304 error
# https://stackoverflow.com/questions/59498640/running-kubernetes-locally-via-minikube-always-returns-304-not-modified-resource
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: myingress
  namespace: mynamespace
  annotations:
    nginx.ingress.kubernetes.io/configuration-snippet: |
      add_header Cache-Control "max-age=0, no-cache, no-store, must-revalidate";