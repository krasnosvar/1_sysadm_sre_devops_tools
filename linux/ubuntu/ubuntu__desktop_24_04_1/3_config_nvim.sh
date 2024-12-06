
#!/usr/bin/env bash

sudo apt install neovim -y

# make default for vi vim
# https://medium.com/@troelslenda/make-neovim-your-default-vim-the-right-way-73396c3570cd
# echo "alias vim=\"nvim\"" | tee -a ~/.zshrc
git config --global core.editor nvim
sudo update-alternatives --set vi /usr/bin/nvim
sudo update-alternatives --set vim /usr/bin/nvim
sudo update-alternatives --install /usr/bin/vi vi "/usr/bin/nvim" 100

#plugins
# https://github.com/rockerBOO/awesome-neovim
