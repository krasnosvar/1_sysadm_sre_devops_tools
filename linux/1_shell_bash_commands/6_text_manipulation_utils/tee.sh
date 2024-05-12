#подробный вывод скрипта и в файл и на экран
bash -x 23_dkr.sh 2>&1 | tee output.log
#записать вывод команды в файл
df -h | tee disk_usage.txt
#записать в несколько файлов
command | tee file1.out file2.out file3.out
#По умолчанию команда tee перезапишет указанный файл. 
#Используйте опцию -a( --append), чтобы добавить вывод в файл:
command | tee -a file.out
#записать в файл но не выводить на экран
command | tee file.out >/dev/null
#добавить deb репозиторий в /etc/apt/sources.list
echo "deb http://packages.elastic.co/logstash/2.3/debian stable main" | sudo tee -a /etc/apt/sources.list
