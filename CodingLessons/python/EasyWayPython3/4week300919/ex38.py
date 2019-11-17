ten_things="Apples Oranges Vorons Phones Light Sugar"

print("Wait, here are less than 10 odjects. Let's fix it.")
#создаем список из строки ten_things, разделитель пробел- определение элементов списка, 
#они идут через пробел а не через двоеточие(:) например
stuff=ten_things.split(' ')
#второй список 
more_stuff=["Day","Night", "Song", "Bear", "Corn", "Banana", 
"Girl", "Boy"]

#цикл while для добавления к списку stuff для общего значения 10 элементов списка
while len(stuff) != 10:
    
    next_one= more_stuff.pop()
    print("Add: ", next_one)
    stuff.append(next_one)
    print(f"Now we have {len(stuff)} objects.")

print("So: ", stuff)

print("Let's do smthg with our objects.")

print(stuff[1])
print (stuff[-1] ) 
print (stuff.pop())
print(' '.join(stuff)) 
print('#'.join(stuff [3:5])) 
