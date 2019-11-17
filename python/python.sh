#install python3.8 from sources on centOS7
cd /usr/src/
wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tar.xz
tar xvf Python-3.8.0.tar.xz 
cd Python-3.8.0
./configure --enable-optimizations
make altinstall
 export PATH=$PATH:/usr/local/bin/
python3.8


#PIP
#already installed in python3.4 and above
#Если у вас последняя версия пакета, но вы хотите принудительно переустановить его:
pip install --force-reinstall
#Посмотреть список установленных пакетов Python можно с помощью команды:
pip list
#Когда пакет больше не нужен, пишем:
pip uninstall имя_пакета

