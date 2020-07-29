x = float(input())
y = float(input())
xc = float(input())
yc = float(input())
r = float(input())


def IsPointinCercle(x, y, xc, yc, r):
    return (x-xc) * (x-xc) + (y-yc) * (y-yc) <= r * r

if IsPointinCercle(x, y, xc, yc, r):
    print("YES")
else:
    print("NO")
