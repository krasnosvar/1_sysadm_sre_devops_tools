def cheese_and_crackers(cheese_count, boxes_of_crackers):
    print(f"У нас есть {cheese_count} сырков!")
    print(f"У нас есть {boxes_of_crackers} пачек чипсов!")
    print("Этого достаточно для вечеринки!")
    print("Погнали!\n")


print("Мы можем непосредственно передать числа функции:")
cheese_and_crackers(20, 30)


print("ИЛИ, мы можем использовать переменные из нашего сценария:")
amount_of_cheese = 10
amount_of_crackers = 50

cheese_and_crackers(amount_of_cheese, amount_of_crackers)


print("Мы даже можем выполнять вычисления внутри функции:")
cheese_and_crackers(10 + 20, 5 + 6)


print("И объединять переменные с вычислениями:")
cheese_and_crackers(amount_of_cheese + 100, amount_of_crackers + 1000)