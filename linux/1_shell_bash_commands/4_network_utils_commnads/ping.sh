#ping последовательно диапазона адресов
for ((i=120; i <= 130; i++)) do ping -c 1 192.168.43.$i; done

#check if IP not pinging(free) and add first free in variable
for i in 10.9.32.254 10.9.32.253 10.9.32.252 10.9.32.251 10.9.32.250; do if ! ping -c 1 $i; then echo "$i free"; export SUPER_IP=$i; break; fi; done
