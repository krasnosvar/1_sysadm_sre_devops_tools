a = input()
pos = 0
lst = []
while a.find("f", pos) != -1:
    pos = a.find("f", pos) + 1
    lst.append(pos - 1)
if len(lst) == 1:
    print(a.find("f"))
if len(lst) > 1:
    print(lst[0], lst[-1])
    print(lst)
