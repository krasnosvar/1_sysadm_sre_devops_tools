#переименовать расширение всех файлов
yum -y install rename
rename 's/\.txt$/.text/' *.txt
