a = int(input())
if a == 1 or (a != 1 and a % 10 == 1) and a != 11:
    print(f"{a} korova")
elif 2 <= a <= 4 and a < 5 or 2 <= (a % 10) <= 4 and a > 14:
    print(f"{a} korovy")
elif a >= 5 or 11 <= a >= 14:
    print(f"{a} korov")
