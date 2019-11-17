the_count=[1,2,3,4,5]
fruits=["apple","orange","persik","abrikos"]
change=[1,"chervonets","2","poltinnik",3,"sotnya"]

#цикл for первого типа обрабатывает список
for number in the_count:
     print(f"Counter {number}")

#the same that is above
for fruit in fruits:
    print(f"Fruit: {fruit}")

# также обрабатываем смешанные списки
# используются символы {}, так как неизвестен тип значения
for i in change:
    print(f"I got {i}")

#we can create lists, start with blank list:
elements=[]

#use range() to limit the "range"(diapazon znacheniy)
for i in range(0,6):
    print(f"Add {i} in list")
    #append - function to add elements in list
    elements.append(i)

#now we print it
for i in elements:
    print(f"Element number: {i}")



#https://python-scripts.com/range
numbers_divisible_by_three = [3, 6, 9, 12, 15]
 
for num in numbers_divisible_by_three:
    quotient = num / 3
    print(f"{num} делится на 3, результат {int(quotient)}.")