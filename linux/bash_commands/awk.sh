#Вывести только первую строку файла
sudo awk 'NR==1{print $1}' /etc/*release*

#вывести второй столбец( в примере - PID процессов)
ps aux | grep "dd "|awk '{print $2}'

#kill all "dd" procecess
for i in $(ps aux | grep "dd "|awk '{print $2}'); do kill -9 $i; done
