#minikube docs
https://minikube.sigs.k8s.io/docs/start/
#kubernetes docs
https://kubernetes.io/docs
https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet


#start container in pod if it stops after interior command
#https://stackoverflow.com/questions/31870222/how-can-i-keep-a-container-running-on-kubernetes
root@minikube01:~# cat first-pod.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: first-pod
  labels:
    app: "krasnosvar_at_gmail.com"
spec:
  containers:
    - name: frontend
      image: godlovedc/lolcow:latest
      command: [ "/bin/bash", "-c", "--" ]
      args: ["while true; do fortune | cowsay | lolcat; sleep 1; done;"]


