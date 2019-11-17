cars = 100
space_in_a_car = 4
drivers = 30
passengers = 90
cars_not_driven = cars - drivers
cars_driven = drivers
carpool_capacity = cars_driven * space_in_a_car
average_passengers_per_car = passengers / cars_driven
print("В наличии", cars, "автомобилей.")
print("M только", drivers, "водителей вышли на работу.")
print("Получается, что", cars_not_driven, "машин пустуют.")
print("Мы можем перевезти сегодня", carpool_capacity, "человек.")
print("Сегодня нужно отвезти", passengers, "человек.")
print("B каждой машине будет примерно", average_passengers_per_car, "человека.")