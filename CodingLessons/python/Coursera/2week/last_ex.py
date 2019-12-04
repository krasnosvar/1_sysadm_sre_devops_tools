a = int(input())
b = a
n = 1
while a != 0:
    a = int(input())
    if a == b:
        n += 1
        if a == 0:
            break
print(n)
