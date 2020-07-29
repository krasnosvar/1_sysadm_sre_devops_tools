ten_things = "Яблоки Апельсины Вороны Телефоны Свет Сахар"

print("Погодите, тут меньше 10 объектов. Давайте исправим это.")

stuff = ten_things.split(' ')
more_stuff = ["День", "Ночь", "Песня", "Мишка",
"Кукуруза", "Банан", "Девочка", "Мальчик"]

while len(stuff) != 10:
    next_one = more_stuff.pop()
    print("Добавляем: ", next_one)
    stuff.append(next_one)
    print(f"Теперь у нас {len(stuff)} объектов.")

print("Итак: ", stuff)

print("Давайте кое-что сделаем с нашими объектами.")

print(stuff[1])
print(stuff[-1]) # хм! интересно
print(stuff.pop())
print(' '.join(stuff)) # что? круто!
print('#'.join(stuff[3:5])) # просто супер!