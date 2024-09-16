
#!/usr/bin/env bash

sudo apt install neovim -y

# make default for vi vim
# https://medium.com/@troelslenda/make-neovim-your-default-vim-the-right-way-73396c3570cd
# echo "alias vim=\"nvim\"" | tee -a ~/.zshrc
git config --global core.editor nvim
sudo update-alternatives --set vi /usr/bin/nvim
sudo update-alternatives --set vim /usr/bin/nvim


#plugin manager
# https://dev.to/slydragonn/ultimate-neovim-setup-guide-lazynvim-plugin-manager-23b7
mkdir -p ~/.config/nvim/
cp files/nvim/init.lua ~/.config/nvim/init.lua
mkdir -p ~/.config/nvim/lua/config/
cp files/nvim/lazy.lua ~/.config/nvim/lua/config/lazy.lua
mkdir -p ~/nvim/lua/plugins/
cp files/nvim/plugins/* ~/nvim/lua/plugins/
#plugins
# https://github.com/rockerBOO/awesome-neovim


