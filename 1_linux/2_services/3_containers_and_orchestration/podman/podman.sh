#!/usr/bin/env bash
# Podman — daemonless Docker-compatible container engine
# Default on RHEL/Fedora; runs rootless by default (no root daemon)
# Docs: https://docs.podman.io/

# ── Why Podman instead of Docker ─────────────────────────────────────────────
# - rootless by default: containers run as your user, not root
# - no daemon: each container is a direct child process (no dockerd)
# - OCI-compliant: same image format, most Docker commands work as-is
# - pods: native pod support without Kubernetes (shares network namespace)
# - docker-compatible CLI: alias docker=podman works for most workflows

# ── Install ───────────────────────────────────────────────────────────────────
# Fedora / RHEL:
sudo dnf install -y podman podman-compose

# Ubuntu 22.04+:
sudo apt install -y podman

# ── Basic usage (same as Docker) ─────────────────────────────────────────────
podman run -it --rm ubuntu bash
podman run -d --name nginx -p 8080:80 nginx
podman ps
podman ps -a
podman images
podman pull registry.example.com/my-app:1.0
podman build -t my-app:latest .
podman logs nginx
podman exec -it nginx bash
podman stop nginx && podman rm nginx

# ── Rootless specifics ────────────────────────────────────────────────────────
# containers run as your UID; port < 1024 requires extra config
# check user namespace mapping:
podman info | grep -A5 usernsMode
cat /proc/self/uid_map

# enable linger so user containers survive logout:
loginctl enable-linger $USER

# ── Volumes ───────────────────────────────────────────────────────────────────
podman volume create mydata
podman run -v mydata:/data:Z alpine   # :Z relabels SELinux context (required on Fedora/RHEL)
podman volume ls
podman volume inspect mydata
podman volume rm mydata

# ── Pods (group of containers sharing network) ─────────────────────────────────
podman pod create --name mypod -p 8080:80
podman run -d --pod mypod --name web nginx
podman run -d --pod mypod --name app myapp:latest

podman pod list
podman pod inspect mypod
podman pod stop mypod
podman pod rm mypod

# generate k8s YAML from a running pod (handy for migrating to k8s)
podman generate kube mypod > pod.yaml
kubectl apply -f pod.yaml

# ── podman-compose ────────────────────────────────────────────────────────────
# reads docker-compose.yml files
podman-compose up -d
podman-compose down
podman-compose logs -f

# ── Systemd integration (auto-start containers) ───────────────────────────────
# generate systemd service for a container
podman generate systemd --name nginx --new --files
# creates container-nginx.service
cp container-nginx.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now container-nginx

# Quadlets (Podman ≥ 4.4, preferred over generate systemd)
# place .container file in ~/.config/containers/systemd/
cat > ~/.config/containers/systemd/nginx.container << 'EOF'
[Container]
Image=docker.io/library/nginx:latest
PublishPort=8080:80
Volume=/srv/nginx:/usr/share/nginx/html:Z

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user start nginx

# ── Registry login ────────────────────────────────────────────────────────────
podman login registry.example.com -u myuser -p mytoken
podman login docker.io
cat ~/.docker/config.json                    # credentials are shared with Docker

# ── Image management ──────────────────────────────────────────────────────────
podman image list
podman image prune                           # remove dangling images
podman image prune -a                        # remove all unused images
podman system prune -a --volumes             # full cleanup

# push to registry
podman tag my-app:latest registry.example.com/org/my-app:1.0
podman push registry.example.com/org/my-app:1.0

# ── Build (Buildah under the hood) ────────────────────────────────────────────
# same Dockerfile as Docker; rootless build
podman build --squash -t my-app:latest .
podman build --platform linux/amd64,linux/arm64 -t my-app:latest .  # multi-arch

# ── docker alias ─────────────────────────────────────────────────────────────
# in ~/.bashrc or ~/.zshrc:
# alias docker=podman
# alias docker-compose=podman-compose
# this covers ~95% of Docker workflows transparently
