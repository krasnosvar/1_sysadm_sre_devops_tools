#Requires -Version 5.1
[CmdletBinding()]
param(
    [ValidateSet('Minimal', 'DevOps', 'Desktop', 'All')]
    [string]$Profile = 'Minimal',
    [switch]$WhatIf,
    [switch]$InstallWSL
)

$ErrorActionPreference = 'Stop'
$FailedPackages = [System.Collections.Generic.List[string]]::new()

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
        if ($LASTEXITCODE -ne 0) { throw "Chocolatey installer exited $LASTEXITCODE" }
    }
    finally {
        Remove-Item -LiteralPath $installer -Force -ErrorAction SilentlyContinue
    }
}

function Test-ChocoPackageInstalled([string]$Name) {
    $escaped = [regex]::Escape($Name)
    $result = & choco list $Name --exact --limit-output 2>$null
    return $LASTEXITCODE -eq 0 -and $result -match "^$escaped\|"
}

function Install-ChocoPackage([string]$Name) {
    if ($WhatIf) {
        Write-Host "+ choco install $Name"
        return
    }
    if (Test-ChocoPackageInstalled $Name) {
        Write-Host "OK: $Name"
        return
    }
    & choco search $Name --exact --limit-output *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Unavailable: $Name"
        $FailedPackages.Add($Name)
        return
    }
    & choco install $Name --yes --no-progress
    if ($LASTEXITCODE -notin 0, 1641, 3010) {
        Write-Warning "Failed: $Name (exit $LASTEXITCODE)"
        $FailedPackages.Add($Name)
    }
}

if (-not (Test-IsAdmin) -and -not $WhatIf) {
    throw 'Run this script from an elevated PowerShell session.'
}

Install-Chocolatey

$MinimalPackages = @(
    'git', 'powershell-core', 'microsoft-windows-terminal', 'openssh',
    '7zip', 'curl', 'jq', 'yq', 'ripgrep', 'fd', 'fzf', 'bat', 'eza',
    'zoxide', 'direnv', 'sysinternals', 'keepassxc'
)

$DevOpsPackages = @(
    'terraform', 'opentofu.portable', 'terragrunt', 'tflint', 'packer',
    'go-task', 'python3', 'golang', 'shellcheck',
    'docker-desktop', 'podman-desktop', 'kubernetes-cli', 'kubernetes-helm',
    'kustomize', 'k9s', 'kind', 'stern',
    'awscli', 'azure-cli', 'gcloudsdk',
    'sops', 'age.portable', 'trivy', 'cosign', 'syft', 'grype',
    'nmap', 'wireshark', 'iperf3', 'httpie', 'grpcurl', 'k6',
    'rclone', 'restic', 'dbeaver', 'postman',
    'vscode', 'vscodium', 'antigravity'
)

$DesktopPackages = @(
    'keepassxc', 'veracrypt', 'firefox', 'googlechrome', 'brave',
    'sumatrapdf', 'libreoffice-fresh', 'vlc', 'obsidian',
    'sharex', 'winscp', 'rustdesk', 'antigravity'
)

$Packages = [System.Collections.Generic.HashSet[string]]::new(
    [StringComparer]::OrdinalIgnoreCase
)
foreach ($package in $MinimalPackages) { [void]$Packages.Add($package) }
if ($Profile -in 'DevOps', 'All') {
    foreach ($package in $DevOpsPackages) { [void]$Packages.Add($package) }
}
if ($Profile -in 'Desktop', 'All') {
    foreach ($package in $DesktopPackages) { [void]$Packages.Add($package) }
}

foreach ($package in ($Packages | Sort-Object)) {
    Install-ChocoPackage $package
}

if ($InstallWSL) {
    if ($WhatIf) {
        Write-Host '+ wsl --install --no-launch -d Ubuntu'
    }
    else {
        & wsl --update
        $installed = @(& wsl --list --quiet 2>$null) -replace "`0", ''
        if ($installed -notcontains 'Ubuntu') {
            & wsl --install --no-launch -d Ubuntu
            if ($LASTEXITCODE -ne 0) { throw "WSL install exited $LASTEXITCODE" }
        }
        & wsl --set-default-version 2
        & wsl --set-default Ubuntu
    }
}

if ($FailedPackages.Count -gt 0) {
    Write-Error "Unavailable or failed packages: $($FailedPackages -join ', ')" -ErrorAction Continue
    exit 1
}

Write-Host "Completed profile: $Profile"
