# powershell -executionpolicy bypass -File 'C:\Users\Den\Documents\choco.ps1'
# Run from an elevated PowerShell session.

$ErrorActionPreference = 'Stop'

function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-IsAdmin)) {
    throw "Run this script from an elevated PowerShell session."
}

if (-not (Test-Path -Path "$env:ProgramData\Chocolatey")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

choco feature enable -n allowGlobalConfirmation

$Packages = @(
    # OS utils / maintenance
    'rufus',
    'linux-reader',
    'bleachbit',
    '7zip',
    'copyq',
    'greenshot',
    'flameshot',
    'sharex',
    'keepassxc',
    'veracrypt',
    'smartmontools',
    'sysinternals',

    # Office, multimedia, CAD, notes
    'libreoffice-fresh',
    'sumatrapdf',
    'fbreader',
    'gimp',
    'inkscape',
    'audacity',
    'vlc',
    'mpv',
    'ffmpeg',
    'k-litecodecpackfull',
    'blender',
    'obs-studio',
    'shotcut',
    'openshot',
    'davinci-resolve',
    'kdenlive',
    'krita',
    'figma',
    'drawio',
    'kicad',
    'freecad',
    'openscad',
    'sweethome3d',
    'calibre',
    'obsidian',
    'steam',
    'qbittorrent',

    # Communication
    'telegram',
    'rocketchat',
    'slack',
    'zoom',

    # Browsers
    'googlechrome',
    'vivaldi',
    'brave',
    'firefox',
    'librewolf',
    'floorp',
    'tor-browser',
    'opera',

    # Network, VPN, remote access
    'forticlientvpn',
    'openvpn',
    'wireguard',
    'amneziavpn',
    'v2rayn',
    'wireshark',
    'nmap',
    'winmtr-redux',
    'iperf3',
    'windump',
    'bind-toolsonly',
    'rclone',
    'restic',
    'termius',
    'filezilla',
    'winscp',
    'putty',
    'kitty',
    'teraterm',
    'mobaxterm',
    'tigervnc',
    'rustdesk',

    # Programming tools
    'git',
    'python3',
    'ruby',
    'rustup.install',
    'nodejs-lts',
    'golang',
    'openjdk',
    'vscode',
    'vscodium',
    'neovim',
    'vim',
    'pycharm-community',
    'intellijidea-community',
    'notepadplusplus',
    'golangci-lint',

    # DevOps, testing, debugging
    'terraform',
    'opentofu.portable',
    'terragrunt',
    'tflint',
    'packer',
    'ansible',
    'go-task',
    'dbeaver',
    'datagrip',
    'mongodb-compass',
    'mongodb-database-tools',
    'mongodb-atlas-cli',
    'redisinsight',
    'beekeeper-studio',
    'postgresql',
    'sqlite',
    'sqlitebrowser',
    'httpie',
    'insomnia-rest-api-client',
    'curl',
    'postman',
    'k6',
    'grpcurl',
    'jq',
    'yq',
    'sops',
    'age.portable',
    'vault',

    # Modern CLI utilities, matching Fedora/macOS shell toolkit
    'bat',
    'fzf',
    'ripgrep',
    'fd',
    'eza',
    'ncdu',
    'btop',
    'htop',
    'pv',
    'gsudo',
    'direnv',
    'zoxide',
    'delta',
    'tealdeer',
    'lazygit',

    # Containers / Kubernetes
    'docker-desktop',
    'kubernetes-cli',
    'kubernetes-helm',
    'kustomize',
    'helmfile',
    'k9s',
    'lens',
    'kops',
    'istioctl',
    'podman-desktop',
    'rancher-desktop',
    'stern',
    'dive',
    'lazydocker',
    'kind',
    'trivy',

    # Virtualization / cloud
    'virtualbox',
    'awscli',

    # Hardware / Arduino
    'arduino-ide',
    'arduino-cli',
    'esptool',

    # AI tools / IDE forks
    'cursoride',
    'windsurf',
    'antigravity',
    'warp',
    'lm-studio'
)

foreach ($PackageName in $Packages) {
    choco install $PackageName -y --no-progress
}

$Extensions = @(
    'ms-python.python',
    'golang.Go',
    'redhat.java',
    'redhat.vscode-yaml',
    'ms-azuretools.vscode-docker',
    'ms-kubernetes-tools.vscode-kubernetes-tools',
    'hashicorp.terraform',
    'ms-vscode-remote.remote-containers',
    'eamodio.gitlens',
    'gitlab.gitlab-workflow',
    'mtxr.sqltools',
    'davidanson.vscode-markdownlint',
    'tomoki1207.pdf',
    'Codeium.codeium',
    'github.copilot-chat',
    'usernamehw.errorlens',
    'Gruntfuggly.todo-tree',
    'alefragnani.Bookmarks',
    'humao.rest-client',
    'esbenp.prettier-vscode'
)

$EditorCommands = @(
    'code',
    'codium',
    'cursor',
    'antigravity',
    # Windsurf/Devin naming has changed across releases; keep all known CLI names.
    'windsurf',
    'windsurf-next',
    'devin',
    'devin-desktop'
)

foreach ($Editor in $EditorCommands) {
    $Command = Get-Command $Editor -ErrorAction SilentlyContinue
    if ($Command) {
        foreach ($Extension in $Extensions) {
            & $Command.Source --install-extension $Extension --force
        }
    }
}

if (Get-Command npm -ErrorAction SilentlyContinue) {
    npm install -g @anthropic-ai/claude-code @openai/codex @google/gemini-cli
}

if (Get-Command wsl -ErrorAction SilentlyContinue) {
    wsl --update
    wsl --set-default-version 2

    $InstalledDistros = @(wsl --list --quiet 2>$null)
    if ($InstalledDistros -notcontains 'Ubuntu') {
        # `Ubuntu` tracks the current default Ubuntu Store distribution.
        # Use `wsl --list --online` and install `Ubuntu-24.04`, `Ubuntu-26.04`, etc.
        # if an exact LTS release is required instead of the moving default.
        wsl --install --no-launch -d Ubuntu
    }

    wsl --set-default Ubuntu
}
