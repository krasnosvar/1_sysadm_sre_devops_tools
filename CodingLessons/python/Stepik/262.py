# Напишите программу, которая выводит часть последовательности 1 2 2 3 3 3 4 4 4 4 5 5 5 5 5 ... 
# (число повторяется столько раз, чему равно). 
# На вход программе передаётся неотрицательное целое число n — столько элементов последовательности должна отобразить программа. 
# На выходе ожидается последовательность чисел, записанных через пробел в одну строку.
# Например, если n = 7, то программа должна вывести 1 2 2 3 3 3 4.

#create empty list
v = []
#create input variable
n = int(input())
#create loop in range 1 to our digit "n", so "for" loop creates var "i", first == 1
for i in range(1, n+1):
    #in loop create variable "c", that is MINIMAL digit from our range, "1"
    c = min(n, i)
    #
    n = n - c
    #v = v+ str(i) + c
    v += [str(i)] * c
    # when n=0 stop script and print answer
    if n <= 0:
        break

print(" ".join(v))
