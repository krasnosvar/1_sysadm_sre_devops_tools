# KREW
# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
cd ~/Downloads && \
OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
KREW="krew-${OS}_${ARCH}" &&
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
tar zxvf "${KREW}.tar.gz" &&
./"${KREW}" install krew && \
echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.zshrc && \
source ~/.zshrc && \
kubectl krew install neat && \
kubectl krew install tree && \
kubectl krew install topology && \
kubectl krew install who-can && \
kubectl krew install ctx && \
kubectl krew install ns && \
kubectl krew install sudo && \
kubectl krew install view-allocations


# 1. kubectl-neat
# Purpose: Cleans up verbose Kubernetes resource YAML/JSON output.
# Example: kubectl get pod mypod -o yaml | kubectl neat

# 2. kubectl-tree
# Purpose: Shows resource hierarchy in a tree-like view (ownerReferences).
# Example: kubectl tree deployment my-deploy

# 3. kubectl-debug
# https://kubernetes.io/docs/reference/kubectl/generated/kubectl_debug/
# Purpose: Debug pods with ephemeral containers, even if they’re non-root.
# Example: kubectl debug pod/mypod -it --image=busybox
# already installed

# 4. kubectl-topology
# Purpose: Visualizes Kubernetes resources and their relationships.
# Example: kubectl topology pod mypod

# 5. kubectl-who-can
# Purpose: Checks RBAC permissions; shows who can perform an action.
# Example: kubectl who-can get pods

# 6. kubectl-ctx / kubectx
# Purpose: Quickly switch between Kubernetes contexts.
# Example: kubectx minikube

# 7. kubectl-ns / kubens
# Purpose: Quickly switch Kubernetes namespaces.
# Example: kubens dev

# 8. kubectl-sudo
# Purpose: Temporarily elevate privileges inside pods or resources.
# Example: kubectl sudo pod/mypod -- bash

# 9. kubectl-view-allocations
# Purpose: Shows resource (CPU/memory) allocations per namespace, pod, or node.
# Example: kubectl view-allocations ns dev

# 10. kubectl-plugins (official plugin manager)
# Purpose: A framework to discover, install, and manage kubectl plugins easily.
# Example: kubectl plugin list


# 11. Node-shell
# https://github.com/kvaps/kubectl-node-shell

# install kubectl node-shell
curl -LO https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell && \
chmod +x ./kubectl-node_shell && \
sudo mv ./kubectl-node_shell /usr/local/bin/kubectl-node_shell


# command example
# ${node##node/} = "give me the actual node name without the node/ prefix."
for node in $(kubectl get nodes -o name); do
  kubectl node-shell ${node##node/} -- cat /proc/sys/net/netfilter/nf_conntrack_acct
done
# or
for node in $(kubectl get nodes -o jsonpath='{.items[*].metadata.name}'); do
  kubectl node-shell "$node" -- cat /proc/sys/net/netfilter/nf_conntrack_acct
done
