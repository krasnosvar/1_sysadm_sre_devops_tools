a, b, c = int(input()), int(input()), int(input())
p = (a + b + c) / 2
S = ((p * (p - a) * (p - b) * (p - c)) ** 0.5)
print(round(S, 3)) #округлить до 3 знаков после запятой
