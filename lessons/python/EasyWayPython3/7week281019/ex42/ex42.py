## Animal наследует object
class Animal(object):
    pass

## ??
class Dog(Animal):

    def __init__(self, name):
        ## ??
        self.name = name

## ??
class Cat(Animal):

    def __init__(self, name):
        ## ??
        self.name = name

## ??
class Person(object):

    def __init__(self, name):
        ## ??
        self.name = name

        ## Person – композиция животного некоторого вида
        self.pet = None

## ??
class Employee(Person):

    def __init__(self, name, salary):
        ## ?? хмм, что за чудеса?
        super(Employee, self).__init__(name)
        ## ??
        self.salary = salary

## ??
class Fish(object):
    pass

## ??
class Salmon(Fish):
    pass

## ??
class Halibut(Fish):
    pass


## barbos наследует Dog
barbos = Dog("Барбос")

## ??
barsik = Cat("Барсик")

## ??
mary = Person("Машка")

## ??
mary.pet = barsik

## ??
filka = Employee("Филька", 120000)

## ??
filka.pet = barbos

## ??
flipper = Fish()

## ??
crouse = Salmon()

## ??
harry = Halibut()