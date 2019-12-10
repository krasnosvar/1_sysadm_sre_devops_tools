def sorted3(a, b, c):
    if c < b: c, b = b, c
    if c < a: c, a = a, c
    if b < a: b, a = a, b
    return a, b, c

input_box = lambda: sorted3(*[int(input()) for _ in range(3)])
a, b = input_box(), input_box()
if a == b:
    print('Boxes are equal')
elif all(x <= y for x, y in zip(a, b)):
    print('The first box is larger than the second one')
elif all(x <= y for x, y in zip(b, a)):
    print('The first box is smaller than the second one')
else:
    print('Boxes are incomparable')
