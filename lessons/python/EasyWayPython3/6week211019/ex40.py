#importing file mystuff.py like a module
import mystuff
#calling motorcycle function
mystuff.motorcycle()
#print "car" variable
print(mystuff.car)

d={'mystyffo': 'apples'}
print("*"*10, f"Hello, {mystuff.car}")
# способ со словарем
print(d['mystyffo'])
# способ с модулем
mystuff.motorcycle()
print(mystuff.car)
# способ с классом
class MyStuff(object):
    #1.Python создает пустой объект со всеми функциями, указанными вами
    #в классе с помощью ключевого слова def
    #2.Python затем ищет волшебную функцию __ init__ и, если она
    #обнаружена, вызывает ее для инициализации созданного пустого объекта.
    #3.В классе MyStuff с помощью конструктора__ init__ передает­ся 
    #параметр self, на место которого будет помещен пустой объект,
    #создаваемый Python, кроме того я могу установить дополнительные
    #параметры так же, как и при работе с модулем, словарем или другим
    #объектом.
    def __init__(self):
        #В примере я присвоил переменной self.tangerine текст из пес­ни, 
        #а затем инициализировал этот объект.
        self.tangerine= "Pust begut neukluzhe"

    def apple(self):
        print("I AM THE SWEETIEST APPLE!")
thing = MyStuff()
thing.apple()
print(thing.tangerine)
##########
print("*"*100)
###########
class Song(object):

    def __init__(self, lyrics):
        self.lyrics=lyrics

    def sing_me_a_song(self):
        for line in self.lyrics:
            print(line)
           #list
happy_bday=Song(["I cant in your Birthday",
                 "expensive gifts to you ",
                 "but in this summer nights"])

bulls_on_parade=Song(["Far-far away on lug who?",
                      "Drink, children milk, be ok!"])

happy_bday.sing_me_a_song()

bulls_on_parade.sing_me_a_song()
##########
print("*"*100)
###########

class Vehicle(object):
    """docstring"""
 
    def __init__(self, color, doors, tires):
        """Constructor"""
        self.color = color
        self.doors = doors
        self.tires = tires
    
    def brake(self):
        """
        Stop the car
        """
        return "Braking"
    
    def drive(self):
        """
        Drive the car
        """
        return "I'm driving!"

if __name__ == "__main__":
    car = Vehicle("blue", 5, 4)
    print(car.color)
    
    truck = Vehicle("red", 3, 6)
    print(truck.color)

motorcycle=Vehicle("siniy", 0, 2)
print(f" колес у {motorcycle.doors} {motorcycle.tires}, color of {motorcycle.color}")
class Vehicle(object):
    """docstring"""
    
    def __init__(self, color, doors, tires, vtype):
        """Constructor"""
        self.color = color
        self.doors = doors
        self.tires = tires
        self.vtype = vtype
    
    def brake(self):
        """
        Stop the car
        """
        return "%s braking" % self.vtype
    
    def drive(self):
        """
        Drive the car
        """
        return "I'm driving a %s %s!" % (self.color, self.vtype)
 
 
if __name__ == "__main__":
    car = Vehicle("blue", 5, 4, "car")
    print(car.brake())
    print(car.drive())
 
    truck = Vehicle("red", 3, 6, "truck")
    print(truck.drive())
    print(truck.brake())


class Car(Vehicle):
    """
    The Car class
    """
 
    #----------------------------------------------------------------------
    def brake(self):
        """
        Override brake method
        """
        return "The car class is breaking slowly!"
 
#https://ru.stackoverflow.com/questions/515852/Что-делают-if-name-main
if __name__ == "__main__":
    car = Car("yellow", 2, 4, "car")
    car.brake()
    print('The car class is breaking slowly!')
    car.drive()
    print("I'm driving a yellow car!")
