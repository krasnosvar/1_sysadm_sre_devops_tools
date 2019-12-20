#Вывести только первую строку файла
sudo awk 'NR==1{print $1}' /etc/*release*

#вывести второй столбец( в примере - PID процессов)
ps aux | grep "dd "|awk '{print $2}'

#kill all "dd" procecess
for i in $(ps aux | grep "dd "|awk '{print $2}'); do kill -9 $i; done

#Вывести кол-во ядер процессора(4 строка, 2 столбец)
lscpu|awk 'NR == 4{print$2}'
#умножить полученное значение на 2(например, для получения числа потоков)
cores=$(lscpu|awk 'NR == 4{print$2}'); echo $(($cores*2))
