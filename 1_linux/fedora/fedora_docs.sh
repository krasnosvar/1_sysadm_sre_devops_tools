#!/usr/bin/env bash
# Fedora workstation — reference links for all tools installed by the setup scripts.
# Run to print them, or just read the source as a quick reference.
# Sections mirror the install script (1_fedora-desktop-44-update.sh).

cat <<'EOF'
=======================================================================
 FEDORA WORKSTATION — DOCUMENTATION REFERENCE
=======================================================================

--- 01. REPOS & INITIAL UPGRADE ---
  RPM Fusion                https://rpmfusion.org/Configuration
  RPM Sphere                https://rpmsphere.github.io
  Flatpak / Flathub         https://flathub.org

--- 02. SYSTEM UTILITIES ---
  sysstat (iostat/pidstat)  https://github.com/sysstat/sysstat
  fd-find                   https://github.com/sharkdp/fd
  ripgrep                   https://github.com/BurntSushi/ripgrep
  direnv                    https://direnv.net
  fzf                       https://github.com/junegunn/fzf
  bat                       https://github.com/sharkdp/bat
  eza                       https://github.com/eza-community/eza
  zoxide                    https://github.com/ajeetdsouza/zoxide
  git-delta                 https://github.com/dandavison/delta
  tealdeer (tldr)           https://github.com/dbrgn/tealdeer
  lazygit                   https://github.com/jesseduffield/lazygit
  trash-cli                 https://github.com/andreafrancia/trash-cli
  rclone                    https://rclone.org/docs/
  restic                    https://restic.readthedocs.io
  borgbackup                https://borgbackup.readthedocs.io
  btop                      https://github.com/aristocratos/btop
  smartmontools             https://www.smartmontools.org
  lm_sensors                https://github.com/lm-sensors/lm-sensors
  intel-gpu-tools           https://drm.pages.freedesktop.org/igt-gpu-tools/
  nvtop                     https://github.com/Syllo/nvtop
  skanpage (KDE scanner)    https://apps.kde.org/skanpage/
    scanner drivers         see: my_projects/Infra/hardware/epson_v550/

--- 03. DESKTOP APPS ---
  LibreOffice               https://www.libreoffice.org/get-help/documentation/
  GIMP                      https://www.gimp.org/docs/
  Inkscape                  https://inkscape.org/learn/
  Blender                   https://docs.blender.org
  Audacity                  https://manual.audacityteam.org
  VLC                       https://wiki.videolan.org/Documentation/
  OBS Studio                https://obsudios.com/wiki/
  KDenlive                  https://kdenlive.org/en/manual/
  Krita                     https://docs.krita.org
  FreeCAD                   https://wiki.freecad.org
  OpenSCAD                  https://openscad.org/documentation.html
  KiCad                     https://docs.kicad.org
  LibreCAD                  https://librecad.org/docs.html
  SweetHome3D               https://www.sweethome3d.com/userGuide.jsp
  Calibre                   https://manual.calibre-ebook.com
  mpv                       https://mpv.io/manual/
  KTorrent                  https://apps.kde.org/ktorrent/
  Obsidian                  https://help.obsidian.md
  OpenShot                  https://www.openshot.org/user-guide/
  Shotcut                   https://shotcut.org/tutorials/
  flameshot                 https://flameshot.org/#usage
  pdftk-java                https://gitlab.com/pdftk-java/pdftk
  draw.io (optional)        https://www.drawio.com/doc/
  Figma Linux (optional)    https://github.com/Figma-Linux/figma-linux
  RustDesk (optional)       https://rustdesk.com/docs/

--- 04. VIRTUALIZATION ---
  Fedora virtualization     https://docs.fedoraproject.org/en-US/quick-docs/virtualization-getting-started/
  libvirt                   https://libvirt.org/docs.html
  virt-manager              https://virt-manager.org/

--- 05. SECURITY ---
  KeePassXC                 https://keepassxc.org/docs/
  VeraCrypt                 https://documentation.help/VeraCrypt/

--- 06. BROWSERS ---
  Vivaldi                   https://help.vivaldi.com
  Google Chrome             https://support.google.com/chrome
  Brave                     https://support.brave.com
  Floorp                    https://support.floorp.app
  Opera                     https://help.opera.com

--- 07. NETWORK & VPN ---
  wireshark                 https://www.wireshark.org/docs/
  mtr                       https://www.bitwizard.nl/mtr/
  nmap                      https://nmap.org/book/
  iperf3                    https://iperf.fr/iperf-doc.php
  tcpdump                   https://www.tcpdump.org/manpages/tcpdump.1.html
  aircrack-ng               https://www.aircrack-ng.org/documentation.html
  remmina                   https://remmina.org/remmina-usage/
  sshuttle                  https://sshuttle.readthedocs.io
  OpenVPN                   https://openvpn.net/community-resources/
  OpenConnect               https://www.infradead.org/openconnect/
  WireGuard                 https://www.wireguard.com/quickstart/
  openfortivpn              https://github.com/adrienverge/openfortivpn
  Happ VPN                  https://github.com/Happ-proxy/happ-desktop
  Amnezia VPN (optional)    https://docs.amnezia.org
  v2rayN                    https://github.com/2dust/v2rayN/wiki

--- 08. DATABASE TOOLS ---
  PostgreSQL client (psql)  https://www.postgresql.org/docs/current/app-psql.html
  MariaDB client (mysql)    https://mariadb.com/kb/en/mysql-client/
  SQLite                    https://www.sqlite.org/docs.html
  Redis (redis-cli)         https://redis.io/docs/manual/cli/
  pgcli                     https://www.pgcli.com
  mycli                     https://www.mycli.net
  litecli                   https://litecli.com
  usql                      https://github.com/xo/usql
  mssql-tools (sqlcmd)      https://docs.microsoft.com/en-us/sql/tools/sqlcmd-utility
  DBeaver                   https://dbeaver.io/docs/wiki/
  DataGrip (optional)       https://www.jetbrains.com/help/datagrip/
  mongocli                  https://www.mongodb.com/docs/mongocli/current/
  MongoDB Compass           https://www.mongodb.com/docs/compass/current/
  MongoDB Atlas CLI         https://www.mongodb.com/docs/atlas/cli/current/
  RedisInsight              https://redis.io/docs/connect/insight/
  sqlitebrowser             https://sqlitebrowser.org/help/

--- 09. DEVOPS & CLOUD ---
  Taskfile                  https://taskfile.dev/usage/
  Terraform                 https://developer.hashicorp.com/terraform/docs
  OpenTofu                  https://opentofu.org/docs/
  Terragrunt                https://terragrunt.gruntwork.io/docs/
  tflint                    https://github.com/terraform-linters/tflint
  Docker                    https://docs.docker.com
  stern                     https://github.com/stern/stern
  dive                      https://github.com/wagoodman/dive
  lazydocker                https://github.com/jesseduffield/lazydocker
  kind                      https://kind.sigs.k8s.io/docs/
  trivy                     https://aquasecurity.github.io/trivy/
  kubectl                   https://kubernetes.io/docs/reference/kubectl/
  kustomize                 https://kubectl.docs.kubernetes.io/guides/
  Krew (plugin manager)     https://krew.sigs.k8s.io/docs/
  kubectl node-shell        https://github.com/kvaps/kubectl-node-shell
  k9s                       https://k9scli.io/topics/commands/
  Lens                      https://docs.k8slens.dev
  kops                      https://kops.sigs.k8s.io/getting_started/
  Helm                      https://helm.sh/docs/
  age (encryption)          https://github.com/FiloSottile/age
  yq                        https://mikefarah.gitbook.io/yq/
  jq                        https://jqlang.github.io/jq/manual/
  AWS CLI v2                https://docs.aws.amazon.com/cli/latest/userguide/
  Session Manager plugin    https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
  ECR credential helper     https://github.com/awslabs/amazon-ecr-credential-helper
  aws-iam-authenticator     https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
  SOPS                      https://getsops.github.io/sops/
  helm-secrets              https://github.com/jkroepke/helm-secrets
  helm-diff                 https://github.com/databus23/helm-diff
  helmfile                  https://helmfile.readthedocs.io
  istioctl                  https://istio.io/latest/docs/reference/commands/istioctl/
  jsonnet                   https://jsonnet.org/ref/language.html

--- 10. ARDUINO & ELECTRONICS ---
  Arduino IDE 2             https://docs.arduino.cc/software/ide-v2/
  Arduino Lab MicroPython   https://github.com/arduino/lab-micropython-editor
  minicom                   https://linux.die.net/man/1/minicom
  esptool                   https://docs.espressif.com/projects/esptool/

--- 11. PROGRAMMING LANGUAGES ---
  Node.js / nvm             https://nodejs.org/en/docs  |  https://github.com/nvm-sh/nvm
  Python 3                  https://docs.python.org/3/
  uv (Python pkg manager)   https://docs.astral.sh/uv/
  Ruby / Bundler            https://bundler.io/docs.html
  Go                        https://go.dev/doc/
  golangci-lint             https://golangci-lint.run/usage/install/
  protobuf / gRPC (Go)      https://grpc.io/docs/languages/go/
  Graphviz (go pprof)       https://graphviz.org/documentation/
  Java (OpenJDK)            https://docs.oracle.com/en/java/javase/
  Neovim / LazyVim          https://neovim.io/doc/  |  https://www.lazyvim.org
  Rust / rustup / cargo     https://doc.rust-lang.org/book/  |  https://rustup.rs
  cargo-binstall            https://github.com/cargo-bins/cargo-binstall

--- 12. TESTING & DEBUGGING ---
  httpie                    https://httpie.io/docs/cli
  k6 (load testing)         https://grafana.com/docs/k6/latest/
  grpcurl                   https://github.com/fullstorydev/grpcurl
  Insomnia                  https://docs.insomnia.rest
  Slack                     https://slack.com/help
  Zoom                      https://support.zoom.us

--- AI TOOLS (see 5_ai_tools.sh) ---
  Claude Code               https://docs.anthropic.com/en/docs/claude-code
  Codex CLI                 https://github.com/openai/codex
  Gemini CLI                https://github.com/google-gemini/gemini-cli
  Aider                     https://aider.chat/docs/
  Goose                     https://block.github.io/goose/docs/
  OpenCode                  https://opencode.ai/docs
  Cursor                    https://docs.cursor.com
  Windsurf                  https://docs.windsurf.com
  LM Studio                 https://lmstudio.ai/docs
  AnythingLLM               https://docs.anythingllm.com
  Warp terminal             https://docs.warp.dev

=======================================================================
EOF
