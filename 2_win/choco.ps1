#Requires -Version 5.1
[CmdletBinding()]
param(
    [switch]$WhatIf
)

$ErrorActionPreference = 'Stop'
$Failures = [System.Collections.Generic.List[string]]::new()

function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-Chocolatey {
    if (Get-Command choco -ErrorAction SilentlyContinue) { return }
    if ($WhatIf) {
        Write-Host '+ install Chocolatey from the official installer'
        return
    }

    $installer = Join-Path ([IO.Path]::GetTempPath()) 'install-chocolatey.ps1'
    try {
        Invoke-WebRequest -UseBasicParsing `
            -Uri 'https://community.chocolatey.org/install.ps1' `
            -OutFile $installer
        & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $installer
        if ($LASTEXITCODE -ne 0) {
            throw "Chocolatey installer exited $LASTEXITCODE"
        }
    }
    finally {
        Remove-Item -LiteralPath $installer -Force -ErrorAction SilentlyContinue
    }

    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        throw 'Chocolatey was installed but choco is not available in PATH.'
    }
}

function Test-ChocoPackageInstalled([string]$Name) {
    $escaped = [regex]::Escape($Name)
    $result = & choco list $Name --exact --limit-output 2>$null
    return $LASTEXITCODE -eq 0 -and $result -match "^$escaped\|"
}

function Install-ChocoPackage([string]$Name) {
    if ($WhatIf) {
        Write-Host "+ choco install $Name --yes --no-progress"
        return
    }
    if (Test-ChocoPackageInstalled $Name) {
        Write-Host "OK: $Name"
        return
    }

    $escaped = [regex]::Escape($Name)
    $available = & choco search $Name --exact --limit-output 2>$null
    if ($LASTEXITCODE -ne 0 -or $available -notmatch "^$escaped\|") {
        Write-Warning "Unavailable: $Name"
        $Failures.Add("Chocolatey package unavailable: $Name")
        return
    }

    & choco install $Name --yes --no-progress
    if ($LASTEXITCODE -notin 0, 1641, 3010) {
        Write-Warning "Failed: $Name (exit $LASTEXITCODE)"
        $Failures.Add("Chocolatey package failed: $Name")
    }
}

function Update-ProcessPath {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $paths = @($machinePath, $userPath) | Where-Object { $_ }
    $env:Path = $paths -join ';'
}

function Install-EditorExtensions {
    param(
        [string[]]$Editors,
        [string[]]$Extensions
    )

    foreach ($editor in $Editors) {
        if ($WhatIf) {
            foreach ($extension in $Extensions) {
                Write-Host "+ $editor --install-extension $extension --force"
            }
            continue
        }

        $command = Get-Command $editor -ErrorAction SilentlyContinue
        if (-not $command) {
            Write-Host "SKIP: editor command not found: $editor"
            continue
        }
        foreach ($extension in $Extensions) {
            & $editor --install-extension $extension --force
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "Extension failed: $extension ($editor)"
                $Failures.Add("Editor extension failed: $extension ($editor)")
            }
        }
    }
}

function Install-AITools([string[]]$Packages) {
    if ($WhatIf) {
        foreach ($package in $Packages) {
            Write-Host "+ npm install --global $package"
        }
        return
    }

    $npm = Get-Command npm -ErrorAction SilentlyContinue
    if (-not $npm) {
        Write-Warning 'npm not found; AI CLI tools were not installed.'
        $Failures.Add('npm not found for AI CLI tools')
        return
    }
    foreach ($package in $Packages) {
        & npm install --global $package
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "npm package failed: $package"
            $Failures.Add("npm package failed: $package")
        }
    }
}

function Configure-WSL {
    if ($WhatIf) {
        Write-Host '+ wsl --update'
        Write-Host '+ wsl --set-default-version 2'
        Write-Host '+ wsl --install --no-launch -d Ubuntu (when missing)'
        Write-Host '+ wsl --set-default Ubuntu'
        return
    }
    if (-not (Get-Command wsl -ErrorAction SilentlyContinue)) {
        Write-Host 'SKIP: wsl command not found.'
        return
    }

    & wsl --update
    if ($LASTEXITCODE -ne 0) { $Failures.Add('wsl --update failed') }

    & wsl --set-default-version 2
    if ($LASTEXITCODE -ne 0) { $Failures.Add('wsl --set-default-version failed') }

    $installedDistributions = @(& wsl --list --quiet 2>$null) -replace "`0", ''
    if ($LASTEXITCODE -ne 0) {
        $Failures.Add('wsl --list --quiet failed')
        return
    }
    if ($installedDistributions -notcontains 'Ubuntu') {
        # `Ubuntu` tracks the current default Ubuntu Store distribution.
        # Use `wsl --list --online` and install an exact Ubuntu release if needed.
        & wsl --install --no-launch -d Ubuntu
        if ($LASTEXITCODE -ne 0) { $Failures.Add('Ubuntu WSL install failed') }
    }

    & wsl --set-default Ubuntu
    if ($LASTEXITCODE -ne 0) { $Failures.Add('wsl --set-default Ubuntu failed') }
}

if (-not (Test-IsAdmin) -and -not $WhatIf) {
    throw 'Run this script from an elevated PowerShell session.'
}

Install-Chocolatey

if ($WhatIf) {
    Write-Host '+ choco feature enable --name allowGlobalConfirmation'
}
else {
    & choco feature enable --name allowGlobalConfirmation
    if ($LASTEXITCODE -ne 0) {
        $Failures.Add('Chocolatey allowGlobalConfirmation feature failed')
    }
}

# Full workstation manifest. Keep one package per line so a package can be
# retained, commented out or removed without editing neighbouring entries.
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
    'powershell-core',
    'microsoft-windows-terminal',
    'openssh',

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
    'shellcheck',

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
    'cosign',
    'syft',
    'grype',

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
    'azure-cli',
    'gcloudsdk',

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

foreach ($package in $Packages) {
    Install-ChocoPackage $package
}

# Packages installed above can add editor and npm commands to the persistent PATH.
Update-ProcessPath

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

$AITools = @(
    '@anthropic-ai/claude-code',
    '@openai/codex',
    '@google/gemini-cli'
)

Install-EditorExtensions -Editors $EditorCommands -Extensions $Extensions
Install-AITools -Packages $AITools
Configure-WSL

if ($Failures.Count -gt 0) {
    Write-Error "Completed with failures:`n- $($Failures -join "`n- ")" `
        -ErrorAction Continue
    exit 1
}

Write-Host "Completed: $($Packages.Count) Chocolatey packages, editor extensions, AI CLI tools and WSL."
