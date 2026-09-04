#!/usr/bin/env bash
# Kustomize — template-free Kubernetes config customization
# Built into kubectl (kubectl apply -k); also standalone binary
# Docs: https://kubectl.docs.kubernetes.io/guides/

# ── Typical directory layout ──────────────────────────────────────────────────
# base/                   <- shared resources
#   kustomization.yaml
#   deployment.yaml
#   service.yaml
# overlays/
#   dev/
#     kustomization.yaml  <- patches for dev
#   prod/
#     kustomization.yaml  <- patches for prod

# ── Build & apply ─────────────────────────────────────────────────────────────
# preview rendered YAML without applying
kubectl kustomize overlays/prod
kustomize build overlays/prod           # standalone binary

# apply to cluster
kubectl apply -k overlays/prod
kubectl apply -k overlays/prod --dry-run=client   # preview
kubectl apply -k overlays/prod --prune            # delete resources removed from overlay

# diff live state vs kustomize output
kubectl diff -k overlays/prod

# delete all resources defined in overlay
kubectl delete -k overlays/prod

# ── kustomization.yaml reference ──────────────────────────────────────────────
# Full docs: https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/

# --- base/kustomization.yaml ---
# apiVersion: kustomize.config.k8s.io/v1beta1
# kind: Kustomization
# resources:
#   - deployment.yaml
#   - service.yaml
# commonLabels:
#   app: my-app
# namespace: default

# --- overlays/prod/kustomization.yaml ---
# apiVersion: kustomize.config.k8s.io/v1beta1
# kind: Kustomization
# bases:
#   - ../../base
# namePrefix: prod-               # prepend prefix to all resource names
# namespace: production
# replicas:
#   - name: my-app
#     count: 3
# images:
#   - name: my-app
#     newTag: "1.4.2"             # override image tag
# patchesStrategicMerge:
#   - patch-resources.yaml        # merge patch (like kubectl patch)
# patches:
#   - target:
#       kind: Deployment
#       name: my-app
#     patch: |-
#       - op: replace
#         path: /spec/template/spec/containers/0/resources/limits/memory
#         value: "512Mi"

# ── Common operations ─────────────────────────────────────────────────────────

# override image tag (useful in CI after building new image)
# in kustomization.yaml:
# images:
#   - name: registry.example.com/my-app
#     newTag: abc1234

# set image tag via CLI (edits kustomization.yaml in place)
kustomize edit set image registry.example.com/my-app:abc1234

# add a patch file to overlay
kustomize edit add patch --path my-patch.yaml

# generate ConfigMap from files
# configMapGenerator:
#   - name: app-config
#     files:
#       - config/app.properties
#     literals:
#       - LOG_LEVEL=info

# generate Secret from literals (base64 encoded automatically)
# secretGenerator:
#   - name: db-creds
#     literals:
#       - DB_USER=admin
#       - DB_PASS=s3cr3t

# ── Strategic merge patch example ────────────────────────────────────────────
# overlays/prod/patch-resources.yaml — override resource limits:
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: my-app
# spec:
#   template:
#     spec:
#       containers:
#         - name: my-app
#           resources:
#             requests:
#               cpu: "500m"
#               memory: "256Mi"
#             limits:
#               cpu: "1"
#               memory: "512Mi"

# ── ArgoCD + Kustomize ────────────────────────────────────────────────────────
# ArgoCD auto-detects kustomization.yaml and runs kustomize build
# To pin kustomize version in ArgoCD app:
# argocd app create my-app --kustomize-version v5.3.0 ...
# Or in Application spec:
# spec:
#   source:
#     kustomize:
#       version: v5.3.0
#       images:
#         - my-app=registry.example.com/my-app:1.4.2
