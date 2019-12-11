#python links
#google python cource
https://developers.google.com/edu/python
#another site with python examples and cources
https://www.geeksforgeeks.org/python-programming-language/
http://pythontutor.ru/lessons
https://www.practicepython.org/ #practical lessons on python
http://xahlee.info/python/python3_basics.html #everithing(with classes and site parsing) in one place
#Python with usual bash-env vars
https://www.journaldev.com/24935/python-set-environment-variable
#Great site for styding python with MongoDB(and other python lessons)
https://www.w3schools.com/python/python_mongodb_create_collection.asp
#parsing with python
https://proglib.io/p/parsing-course

#install python3.8 from sources on centOS7
cd /usr/src/
wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tar.xz
tar xvf Python-3.8.0.tar.xz 
cd Python-3.8.0
./configure --enable-optimizations
make altinstall
export PATH=$PATH:/usr/local/bin/ #или прописать в /etc/env
python3.8


#PIP
#already installed in python3.4 and above
#Если у вас последняя версия пакета, но вы хотите принудительно переустановить его:
pip install --force-reinstall
#Посмотреть список установленных пакетов Python можно с помощью команды:
pip list
#Когда пакет больше не нужен, пишем:
pip uninstall имя_пакета

#VIRTUAL ENVIRONMENT
#virtualenv's should be in a separate dir like "test"
cd test
#create virtualenv in dir "venv"(every name you like)
#"— system-site-packages" - system packadges allowed in venv
virtualenv — system-site-packages ~/test/venv
#activate virtualenv
source venv/bin/activate
#install ansible in venv
pip install ansible
#deactivate virtualenv
deactivate

#for vmware-api script 
https://stackoverflow.com/questions/12320076/set-vms-hostname-automatically-in-debian-as-the-vms-name
