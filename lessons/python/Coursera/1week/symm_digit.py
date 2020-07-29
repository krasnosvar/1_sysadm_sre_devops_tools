digit = int(input())
left = digit // 100
half_right1 = digit % 100
half_right2 = half_right1 // 10
half_right3 = half_right1 % 10
half_right4 = str(half_right3) + str(half_right2)
right = int(half_right4)
print(int(left - right + 1))
