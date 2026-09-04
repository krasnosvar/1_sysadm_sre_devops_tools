#!/usr/bin/env zsh
set -euo pipefail

# Idempotent macOS workstation bootstrap. Package availability is checked by
# Homebrew at runtime because cask/formula names change independently of macOS.

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h}"
SHARED_FILES_DIR="${REPO_ROOT}/1_linux/fedora/files"

PROFILE=""
DRY_RUN=0
CHECK_ONLY=0
FAILED_ITEMS=()

usage() {
  cat <<'EOF'
Usage: update-mac.zsh PROFILE [--dry-run]

Profiles:
  --minimal   shell, Git and core CLI tools
  --devops    minimal + IaC, containers, Kubernetes, cloud and diagnostics
  --desktop   minimal + desktop applications
  --all       minimal + devops + desktop
  --check     read-only check of prerequisites and repository paths

Examples:
  ./update-mac.zsh --devops --dry-run
  ./update-mac.zsh --all
EOF
}

for argument in "$@"; do
  case "$argument" in
    --minimal|--devops|--desktop|--all)
      [[ -z "$PROFILE" ]] || { print -u2 "choose exactly one profile"; exit 2; }
      PROFILE="${argument#--}"
      ;;
    --dry-run) DRY_RUN=1 ;;
    --check) CHECK_ONLY=1 ;;
    --help|-h) usage; exit 0 ;;
    *) print -u2 "unknown option: $argument"; usage >&2; exit 2 ;;
  esac
done

if (( ! CHECK_ONLY )) && [[ -z "$PROFILE" ]]; then
  print -u2 "a profile is required"
  usage >&2
  exit 2
fi

run() {
  if (( DRY_RUN )); then
    print -r -- "+ ${(q)@}"
  else
    "$@"
  fi
}

append_line_if_missing() {
  local file=$1 line=$2
  run mkdir -p "${file:h}"
  if [[ -f "$file" ]] && grep -qxF "$line" "$file"; then
    return 0
  fi
  if (( DRY_RUN )); then
    print -r -- "+ append ${(q)line} to ${(q)file}"
  else
    print -r -- "$line" >> "$file"
  fi
}

check_environment() {
  local failed=0
  [[ "$(uname -s)" == Darwin ]] || { print -u2 "FAIL: this script requires macOS"; failed=1; }
  [[ -d "$SHARED_FILES_DIR" ]] || {
    print -u2 "FAIL: shared files not found: $SHARED_FILES_DIR"
    failed=1
  }
  if command -v brew >/dev/null 2>&1; then
    print "OK: Homebrew $(brew --version | head -n 1)"
  else
    print "WARN: Homebrew is not installed"
  fi
  for command_name in git curl; do
    if command -v "$command_name" >/dev/null 2>&1; then
      print "OK: $command_name"
    else
      print -u2 "FAIL: missing $command_name"
      failed=1
    fi
  done
  return "$failed"
}

if (( CHECK_ONLY )); then
  check_environment
  exit $?
fi

[[ "$(uname -s)" == Darwin ]] || { print -u2 "this script requires macOS"; exit 2; }

install_homebrew() {
  command -v brew >/dev/null 2>&1 && return 0
  local installer
  installer="$(mktemp -t homebrew-install.XXXXXX)"
  trap 'rm -f "$installer"' EXIT INT TERM
  curl --proto '=https' --tlsv1.2 -fsSL \
    https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
    -o "$installer"
  /bin/bash "$installer"
  rm -f "$installer"
  trap - EXIT INT TERM

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    print -u2 "Homebrew installed but brew is not on PATH"
    return 1
  fi
}

if (( DRY_RUN )) && ! command -v brew >/dev/null 2>&1; then
  print "+ install Homebrew from its official installer"
else
  install_homebrew
fi

if command -v brew >/dev/null 2>&1; then
  BREW_BIN="$(command -v brew)"
  BREW_PREFIX="$($BREW_BIN --prefix)"
else
  BREW_BIN=brew
  BREW_PREFIX=/opt/homebrew
fi

append_line_if_missing "$HOME/.zprofile" "eval \"\$(${BREW_BIN} shellenv)\""

minimal_formulae=(
  git jq yq ripgrep fd fzf bat eza zoxide direnv tree tmux
  htop btop ncdu dust curl wget openssl@3 coreutils gnu-sed
  shellcheck shfmt python go
)

devops_formulae=(
  ansible opentofu tfenv terragrunt tflint packer go-task
  kubectl helm helmfile kustomize k9s kind stern krew
  podman podman-compose skopeo dive lazydocker
  awscli azure-cli
  sops age trivy cosign syft grype
  httpie grpcurl k6 nmap mtr iperf3 socat bind tcpdump
  rclone restic smartmontools libpq
)

desktop_casks=(
  visual-studio-code vscodium antigravity docker podman-desktop
  keepassxc veracrypt obsidian firefox google-chrome
  iterm2 wireshark dbeaver-community insomnia
  rectangle maccy flameshot vlc iina libreoffice
)

devops_casks=(docker podman-desktop visual-studio-code vscodium antigravity wireshark dbeaver-community insomnia google-cloud-sdk)

install_brew_items() {
  local kind=$1 item
  shift
  for item in "$@"; do
    if (( DRY_RUN )) && ! command -v "$BREW_BIN" >/dev/null 2>&1; then
      run "$BREW_BIN" install "--$kind" "$item"
      continue
    fi
    if "$BREW_BIN" list "--$kind" "$item" >/dev/null 2>&1; then
      print "OK: $item"
      continue
    fi
    if ! "$BREW_BIN" info "--$kind" "$item" >/dev/null 2>&1; then
      print -u2 "UNAVAILABLE: $item"
      FAILED_ITEMS+=("$kind:$item")
      continue
    fi
    if ! run "$BREW_BIN" install "--$kind" "$item"; then
      print -u2 "FAILED: $item"
      FAILED_ITEMS+=("$kind:$item")
    fi
  done
}

install_brew_items formula "${minimal_formulae[@]}"
case "$PROFILE" in
  devops)
    install_brew_items formula "${devops_formulae[@]}"
    install_brew_items cask "${devops_casks[@]}"
    ;;
  desktop) install_brew_items cask "${desktop_casks[@]}" ;;
  all)
    install_brew_items formula "${devops_formulae[@]}"
    install_brew_items cask "${devops_casks[@]}"
    install_brew_items cask "${desktop_casks[@]}"
    ;;
esac

configure_shell() {
  local omz="$HOME/.oh-my-zsh"
  local custom="${ZSH_CUSTOM:-$omz/custom}"
  local plugin repo destination

  if [[ ! -d "$omz/.git" ]]; then
    run git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$omz"
  elif (( ! DRY_RUN )); then
    git -C "$omz" pull --ff-only || print -u2 "WARN: could not update $omz"
  fi

  for plugin repo in \
    zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git \
    zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git \
    zsh-completions https://github.com/zsh-users/zsh-completions.git; do
    destination="$custom/plugins/$plugin"
    if [[ ! -d "$destination/.git" ]]; then
      run git clone --depth 1 "$repo" "$destination"
    elif (( ! DRY_RUN )); then
      git -C "$destination" pull --ff-only || print -u2 "WARN: could not update $destination"
    fi
  done

  local config_dir="$HOME/.config/sre-tools"
  run mkdir -p "$config_dir"
  run install -m 0644 "$SCRIPT_DIR/.zshrc_mac" "$config_dir/zshrc"
  append_line_if_missing "$HOME/.zshrc" 'source "$HOME/.config/sre-tools/zshrc"'
}

configure_shell

if [[ "$PROFILE" == devops || "$PROFILE" == all ]]; then
  vscode_extensions=(
    ms-python.python golang.Go redhat.vscode-yaml
    ms-azuretools.vscode-docker ms-kubernetes-tools.vscode-kubernetes-tools
    hashicorp.terraform davidanson.vscode-markdownlint
  )
  editor_commands=(code codium)
  local_editor=""
  for local_editor in "${editor_commands[@]}"; do
    command -v "$local_editor" >/dev/null 2>&1 || continue
    for extension in "${vscode_extensions[@]}"; do
      run "$local_editor" --install-extension "$extension" --force || true
    done
  done
fi

if (( ${#FAILED_ITEMS[@]} > 0 )); then
  print -u2 "Completed with unavailable/failed packages: ${FAILED_ITEMS[*]}"
  exit 1
fi

print "Completed profile: $PROFILE"
