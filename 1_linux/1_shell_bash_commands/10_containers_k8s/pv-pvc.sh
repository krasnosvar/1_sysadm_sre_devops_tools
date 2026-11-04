# pvc inspector
# https://stackoverflow.com/questions/76083530/how-can-i-see-the-contents-of-a-pvc-in-kubernetes
# https://frank.sauerburger.io/2021/12/01/inspect-k8s-pvc.html
export NamespaceMame="test-ns"
export PvcName="test-pvc"
cat <<EOF | kubectl -n $NamespaceMame apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: pvc-inspector
spec:
  containers:
  - image: busybox
    name: pvc-inspector
    command: ["tail"]
    args: ["-f", "/dev/null"]
    volumeMounts:
    - mountPath: /pvc
      name: pvc-mount
  volumes:
  - name: pvc-mount
    persistentVolumeClaim:
      claimName: $PvcName
EOF

# Inspect PVC
kubectl -n $NamespaceMame exec -it pvc-inspector -- sh
kubectl -n $NamespaceMame exec -it pvc-inspector -- ls -lahi /pvc
# Cleanup
kubectl -n $NamespaceMame delete pod pvc-inspector


# How To Fix A PVC Stuck in Terminating Status in Kubernetes: Troubleshooting Guide
# https://veducate.co.uk/kubernetes-pvc-terminating/
kubectl patch pvc {PVC_NAME} -p '{"metadata":{"finalizers":null}}'
