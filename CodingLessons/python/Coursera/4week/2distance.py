x1 = float(input())
y1 = float(input())
x2 = float(input())
y2 = float(input())


def distance(x1, y1, x2, y2):
    dist = ((x2 - x1)**2 + (y2 - y1)**2) ** 0.5
    return float('{:.6f}'.format(dist))
print(distance(x1, y1, x2, y2))
