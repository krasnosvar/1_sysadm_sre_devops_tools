# powershell -executionpolicy bypass -File 'C:\Users\Den\Documents\choco.ps1'
$Packages = 'libreoffice',
            'foxitreader',
            'fbreader',
            'gimp',
            'vlc',
            'audacity',
            'copyq',
            'flameshot',
            'rufus',
            'linux-reader',
            'keepassxc',
            'telegram',
            'rocketchat',

            'googlechrome',
            'vivaldi',
            'brave',
            'firefox',
            'librewolf',

            'forticlientvpn',
            'openvpn-connect',
            'wireshark',
            'termius',
            'winscp',
            'putty',
            'kitty',
            'teraterm',

            'git',
            'python3',
            'golang',
            'openjdk8',
            'openjdk',
            'vscode',
            'vscodium',
            'neovim',
            'pycharm-community',
            'notepadplusplus',

            'terraform',
            'opentofu.portable',
            'dbeaver',
            'httpie',
            'curl',
            'postman',

            'docker-desktop',
            'kubernetes-cli',
            'podman-desktop',
            'rancher-desktop',

            'virtualbox',
            'steam'


If(Test-Path -Path "$env:ProgramData\Chocolatey") {
  # DoYourPackageInstallStuff
  ForEach ($PackageName in $Packages)
    {
        choco install $PackageName -y
    }
}
Else {
  # InstallChoco
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  # DoYourPackageInstallStuff
  ForEach ($PackageName in $Packages)
    {
        choco install $PackageName -y
    }
  wsl --install -d Ubuntu-22.04
  # enter  wsl vm:
  # ubuntu2204
}
