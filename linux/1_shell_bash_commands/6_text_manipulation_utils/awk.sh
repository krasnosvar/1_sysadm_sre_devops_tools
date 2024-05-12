#Вывести только первую строку файла
sudo awk 'NR==1{print $1}' /etc/*release*

#вывести второй столбец( в примере - PID процессов)
ps aux | grep "dd "|awk '{print $2}'

#Вывести число 15
echo "2020-02-21 15:22" | awk '{print $2}' |awk -F ":" '{print $1}' 

#print FROM 2nd string of 1st table
ls -al | awk 'NR>1{print $1}'

#kill all "dd" procecess
for i in $(ps aux | grep "dd "|awk '{print $2}'); do kill -9 $i; done

#Вывести кол-во ядер процессора(4 строка, 2 столбец)
lscpu|awk 'NR == 4{print$2}'
#умножить полученное значение на 2(например, для получения числа потоков)
cores=$(lscpu|awk 'NR == 4{print$2}'); echo $(($cores*2))

#посмотреть память
egrep 'Mem|Swap|High|Low' /proc/meminfo| awk '{$2=$2/1000; $3="Mb"; print $0}'
#Output
MemTotal: 8074.48 Mb
MemFree: 516.34 Mb
MemAvailable: 821.04 Mb
SwapCached: 106.66 Mb
SwapTotal: 3998.72 Mb
SwapFree: 2359.55 Mb


#awk show ips without ip ot ifconfig commands
## Get the primary and secundary IPs
awk '/\|--/ && !/\.0$|\.255$/ {print $2}' /proc/net/fib_trie

## Get only the primary IPs
awk '/32 host/ { print i } {i=$2}' /proc/net/fib_trie
