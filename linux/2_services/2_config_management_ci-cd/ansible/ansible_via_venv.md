1. (FOR MACOS) Install latest python ( 3.12) and delete ansible installed via brew
```
brew uninstall ansible
brew install python
echo "alias python3=python3.12" >> ~/.zshrc
```

2. Create python virtual environment for different versions of ansible
```
mkdir ~/python-venv
cd ~/python-venv

# for ansible v9:
python3 -m venv ansible9
source ansible9/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install ansible==9
```

3. Execute playbook with activated venv
```
cd PLAYBOOK_DIR
ansible-playbook role_playbook.yaml -i hosts.yml \
-b -u $USER_LOGIN --extra-vars="ansible_ssh_pass=$USER_PASS ansible_become_pass=$USER_PASS" -v -DC
```

4. Deactivate venv
```
deactivate
```
