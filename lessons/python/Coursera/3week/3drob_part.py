from math import modf
x = float(input())
print(round(modf(x)[0], 3))
