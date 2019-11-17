#!/usr/bin/env python3
#https://stackoverflow.com/questions/5419204/index-of-duplicates-items-in-a-python-list
#ввод данных в одну строку через пробел
string_list = input().split(" ")
elem = input()
if elem in string_list:
    counter = 0
    elem_pos = []
    for i in string_list:
        if i == elem:
            elem_pos.append(counter)
        counter = counter + 1
    print(" ".join(map(str, elem_pos)))
elif elem not in string_list:
    print("Отсутствует")
