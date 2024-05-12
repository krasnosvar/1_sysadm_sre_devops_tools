#PIP
#already installed in python3.4 and above
#force reinstall package:
pip install --force-reinstall
#Посмотреть список установленных пакетов Python можно с помощью команды:
pip list
#upgrade pacage
sudo pip3 install --upgrade ansible
#remove
pip uninstall ansible
#Output installed packages in requirements format(create requirements.txt) 
pip freeze > requirements.txt
# Upgrade all outdated packages
pip install -r requirements.txt --upgrade
# upgrade all packages using pip with grep or awk on Ubuntu Linux
pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 
pip3 list -o | cut -f1 -d' ' | tr " " "\n" | awk '{if(NR>=3)print)' | cut -d' ' -f1 | xargs -n1 pip3 install -U 
# upgrade all pip on Win
pip freeze | %{$_.split('==')[0]} | %{pip install --upgrade $_}


# set specific pupy repo
pip3 config --global set global.index-url https://pupy.local.server/repository/pypi/simple/ \
&& pip3 config --global set global.trusted-host pupy.local.server

