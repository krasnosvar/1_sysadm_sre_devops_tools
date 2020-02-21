x1 = float(input())
y1 = float(input())
x2 = float(input())
y2 = float(input())
x3 = float(input())
y3 = float(input())


def distance(x1, y1, x2, y2, x3, y3):
    a = ((x2 - x1)**2 + (y2 - y1)**2) ** 0.5
    b = ((x3 - x2)**2 + (y3 - y2)**2) ** 0.5
    c = ((x3 - x1)**2 + (y3 - y1)**2) ** 0.5
    return float('{:.6f}'.format(a + b + c))
print(distance(x1, y1, x2, y2, x3, y3))
