min = int(input())
ost = (int(min // 60) + 24) % 24
hour = 24 - ost
print(ost, min % 60)
