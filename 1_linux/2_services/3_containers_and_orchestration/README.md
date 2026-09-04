#### Containers and orchestration

```
.
├── docker      - Docker commands + Dockerfile/compose examples
├── kaniko      - Kaniko (in-cluster image builds without a daemon)
├── kubernetes  - kubectl/etcdctl/helm/argocd/kustomize, k9s cheatsheet, RBAC, resource examples
├── podman      - Podman (rootless Docker-compatible, daemonless)
└── nomad       - HashiCorp Nomad commands
```

1. [docker](docker/README.md) - Docker/cgroups/namespaces/overlayfs docs, `docker.sh`, and `examples/` (Dockerfiles: alpine+ansible x2, argocd, devops Ubuntu 18.04/20.04, grafana, sqlplus, terraform+ansible, plain Ubuntu 20.04; docker-compose examples for nginx/postgres/prometheus/redis)
2. [kaniko/kaniko.sh](kaniko/kaniko.sh) - building container images without a Docker daemon
3. [kubernetes](kubernetes/README.md) - `kubectl`/`etcdctl`/helm commands, [k9s cheatsheet](kubernetes/k9s_cheatsheet.md), RBAC kubeconfig examples, ingress and resource examples; plus [argocd.sh](kubernetes/argocd.sh) (GitOps CD) and [kustomize.sh](kubernetes/kustomize.sh) (template-free config overlays)
4. [podman/podman.sh](podman/podman.sh) - Podman: rootless containers, pods, podman-compose, systemd Quadlets, `alias docker=podman`
5. [nomad/nomad.sh](nomad/nomad.sh) - Nomad cluster/job commands
