#pip install on centos8
dnf install python2-pip
dnf install python3-pip

#VIRTUALENV
#install virtualenv
pip3 install virtualenv
#Создаём новое виртуальное окружение:
mkdir ~/newproject \
cd ~/newproject \
virtualenv newenv
#удалить виртуальное окружение
rm -rf ~/newproject/newenv/
#активировать окружение
source newenv/bin/activate

#DJANGO
#install django
pip install django psycopg2


#upgrade old pip version 
python -m pip install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org --upgrade pip


python -m pip install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org flower