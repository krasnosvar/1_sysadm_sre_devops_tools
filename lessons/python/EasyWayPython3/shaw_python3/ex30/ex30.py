people = 30
cars = 40
trucks = 15


if cars > people:
    print("Поедем на машине.")
elif cars < people:
    print("Не поедем на машине.")
else:
    print("Мы не можем выбрать.")

if trucks > cars:
    print("Слишком много автобусов.")
elif trucks < cars:
    print("Может поехать на автобусе?")
else:
    print("Мы до сих пор не можем выбрать.")

if people > trucks:
    print("Хорошо, давайте поедем на автобусе.")
else:
    print("Прекрасно, давайте останемся дома.")