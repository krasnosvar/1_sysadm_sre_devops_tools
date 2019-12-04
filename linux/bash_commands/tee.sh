#записать вывод команды в файл
df -h | tee disk_usage.txt
#записать в несколько файлов
command | tee file1.out file2.out file3.out
#По умолчанию команда tee перезапишет указанный файл. 
#Используйте опцию -a( --append), чтобы добавить вывод в файл:
command | tee -a file.out
#записать в файл но не выводить на экран
command | tee file.out >/dev/null
