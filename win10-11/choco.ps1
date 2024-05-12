# powershell -executionpolicy bypass -File 'C:\Users\Den\Documents\choco.ps1'
$Packages = 'rufus', # os utils
            'linux-reader',
            'ccleaner',
            '7zip',
            'copyq',
            'flameshot',
            'keepassxc',
            # office apps, multimedia
            'libreoffice',
            'foxitreader',
            'fbreader',
            'gimp',
            'inkscape',
            'audacity',
            'vlc',
            'k-litecodecpackfull',
            'steam',
            # communication, messengers, etc
            'telegram',
            'rocketchat',
            # browsers
            'googlechrome',
            'vivaldi',
            'brave',
            'firefox',
            'librewolf',
            'floorp',
            # net-tools
            'forticlientvpn',
            'openvpn-connect',
            'wireshark',
            'termius',
            'filezilla',
            'winscp',
            'putty',
            'kitty',
            'teraterm',
            # proggraming tools
            'git',
            'python3',
            'golang',
            'openjdk8',
            'openjdk',
            'vscode',
            'vscodium',
            'neovim',
            'pycharm-community',
            'intellijidea-community',
            'notepadplusplus',
            # devops, testing, debugging tools
            'terraform',
            'opentofu.portable',
            'dbeaver',
            'httpie',
            'curl',
            'postman',
            'jq',
            'yq',
            # containers tools
            'docker-desktop',
            'kubernetes-cli',
            'podman-desktop',
            'rancher-desktop',
            # virt, cloud tools
            'virtualbox',
            'awscli'


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
