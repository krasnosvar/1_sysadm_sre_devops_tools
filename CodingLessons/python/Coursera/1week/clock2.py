digit = int(input())
hour = (int(digit // 3600) + 24) % 24
min1 = (digit - (hour * 3600)) // 60
min2 = "0" + str(min1)
min = int(min2) % 100
print(f"{hour}:{min}:{digit % 60}")
print(min2)
