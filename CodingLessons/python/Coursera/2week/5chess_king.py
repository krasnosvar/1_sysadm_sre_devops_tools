a = int(input())
b = int(input())
c = int(input())
d = int(input())
if a - c == 1 or a - c == 0 or a - c == -1:
    if b - d == 1 or b - d == 0 or b - d == -1:
        print('YES')
    else:
        print('NO')
else:
    print('NO')
