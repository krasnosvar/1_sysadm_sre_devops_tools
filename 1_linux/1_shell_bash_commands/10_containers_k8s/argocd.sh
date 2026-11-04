#!/usr/bin/env bash
# ArgoCD — GitOps continuous delivery for Kubernetes
# Docs: https://argo-cd.readthedocs.io/
# Install CLI: https://argo-cd.readthedocs.io/en/stable/cli_installation/

# ── Install ArgoCD into cluster ───────────────────────────────────────────────
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait for all pods to be ready
kubectl -n argocd rollout status deploy/argocd-server

# get initial admin password
argocd admin initial-password -n argocd
# or via kubectl:
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d

# port-forward UI (then open https://localhost:8080)
kubectl -n argocd port-forward svc/argocd-server 8080:443

# ── Login ─────────────────────────────────────────────────────────────────────
argocd login localhost:8080 --username admin --password <PASSWORD> --insecure

# login via SSO / token
argocd login argocd.example.com --sso

# change admin password
argocd account update-password

# ── App management ────────────────────────────────────────────────────────────
# create app (Helm chart from git)
argocd app create my-app \
  --repo https://github.com/org/repo.git \
  --path helm/my-app \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace production \
  --helm-set image.tag=1.2.3 \
  --sync-policy automated \
  --self-heal \
  --auto-prune

# create app (plain kustomize)
argocd app create my-app \
  --repo https://github.com/org/repo.git \
  --path kustomize/overlays/prod \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace production

# list all apps
argocd app list

# show app status and diff
argocd app get my-app
argocd app diff my-app          # diff live state vs git
argocd app diff my-app --local  # diff against local files

# manual sync
argocd app sync my-app
argocd app sync my-app --force          # force replace resources
argocd app sync my-app --prune          # delete resources removed from git
argocd app sync my-app --resource apps:Deployment:my-app  # sync one resource

# wait for sync to complete
argocd app wait my-app --health --timeout 120

# rollback to previous revision
argocd app history my-app
argocd app rollback my-app 3    # rollback to revision 3

# delete app (keeps k8s resources)
argocd app delete my-app
# delete app AND k8s resources (cascade)
argocd app delete my-app --cascade

# ── App sets (ApplicationSet) ──────────────────────────────────────────────────
# ApplicationSet generates multiple apps from one template (e.g. per cluster/env)
# Example in YAML — generates an app per directory in repo:
# apiVersion: argoproj.io/v1alpha1
# kind: ApplicationSet
# spec:
#   generators:
#     - git:
#         repoURL: https://github.com/org/repo.git
#         revision: HEAD
#         directories:
#           - path: apps/*
#   template:
#     metadata:
#       name: '{{path.basename}}'
#     spec:
#       destination:
#         namespace: '{{path.basename}}'

# ── Projects ──────────────────────────────────────────────────────────────────
argocd proj list
argocd proj get my-project
argocd proj create my-project \
  --src https://github.com/org/repo.git \
  --dest https://kubernetes.default.svc,production

# ── Repositories ──────────────────────────────────────────────────────────────
argocd repo list
argocd repo add https://github.com/org/private-repo.git \
  --username git --password <TOKEN>
# SSH:
argocd repo add git@github.com:org/repo.git \
  --ssh-private-key-path ~/.ssh/id_rsa

# Helm repo:
argocd repo add https://charts.bitnami.com/bitnami \
  --type helm --name bitnami

# ── Clusters ──────────────────────────────────────────────────────────────────
argocd cluster list
argocd cluster add <CONTEXT_NAME>       # add cluster from current kubeconfig context
argocd cluster get <SERVER_URL>

# ── User / RBAC ───────────────────────────────────────────────────────────────
argocd account list
argocd account get --account alice
argocd account update-password --account alice --new-password <PW>

# generate API token for a service account
argocd account generate-token --account ci-bot

# ── Admin / maintenance ───────────────────────────────────────────────────────
# export all app configs to YAML (backup)
argocd app list -o name | xargs -I{} argocd app get {} -o yaml > argocd-backup.yaml

# force re-sync all apps in a namespace
argocd app list -o name | xargs -I{} argocd app sync {}

# check argocd version
argocd version
