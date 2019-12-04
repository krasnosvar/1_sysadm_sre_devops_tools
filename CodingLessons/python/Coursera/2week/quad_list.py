a = int(input())
n = 0
while n < a:
    n += 1
    if n ** 2 <= a:
        print(n ** 2, end=" ")
