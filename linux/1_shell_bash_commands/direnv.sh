# direnv — a small shell utility that automatically loads and unloads environment variables 
# when you enter or leave a directory.
# How it works: you put your settings in a file called .envrc inside the project folder. 
# When you cd into that folder, direnv exports those variables; when you leave, it cleans them up.
# Why it’s useful:
# Different projects can have different PATH, DATABASE_URL, API keys, etc.
# Great for Go/Python/Node development where each project needs its own environment.
# Security: direnv requires explicit approval (direnv allow) before executing a new .envrc, 
# so it won’t run arbitrary code silently.

# Using direnv for a Go project
# 1. Install direnv
# On Fedora (example):
sudo dnf install direnv
# Then hook it into your shell (for example, bash):
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
source ~/.bashrc
# For zsh:
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
source ~/.zshrc
# 2. Create .envrc in your Go project
# Inside your project folder (my-go-app/):
echo 'export GOPATH=$PWD/.gopath' >> .envrc
echo 'export PATH=$GOPATH/bin:$PATH' >> .envrc
echo 'layout go' >> .envrc
# 3. Allow it once
# Run:
direnv allow
# 4. Result
# Every time you cd into my-go-app/, your Go environment is automatically set up.
# When you leave the directory, variables are unloaded.
# Example:
cd my-go-app/
echo $GOPATH   # → /home/user/my-go-app/.gopath
cd ..
echo $GOPATH   # → (empty again)
