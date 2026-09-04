#!/usr/bin/env bash
set -euo pipefail

sudo apt-get install -y neovim
git config --global core.editor nvim

sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 100
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 100
sudo update-alternatives --set vi /usr/bin/nvim
sudo update-alternatives --set vim /usr/bin/nvim
