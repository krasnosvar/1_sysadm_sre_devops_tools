#### Install multiple versions of Ansible via venv
* https://www.redhat.com/sysadmin/python-venv-ansible


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

# IN ONE COMMAND
# for ansible v4:
ansVer=4 pythonVer=3.9 && \
cd ~/python-venv && \
python$pythonVer -m venv ansible$ansVer && \
source ansible$ansVer/bin/activate && \
python$pythonVer -m pip install --upgrade pip && \
python$pythonVer -m pip install ansible==$ansVer && \
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES && \
cd -

# for ansible v9:
ansVer=9 pythonVer=3.12 && \
cd ~/python-venv && \
python$pythonVer -m venv ansible$ansVer && \
source ansible$ansVer/bin/activate && \
python$pythonVer -m pip install --upgrade pip && \
python$pythonVer -m pip install ansible==$ansVer && \
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES && \
cd -

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
