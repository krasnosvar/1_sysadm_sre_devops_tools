class Other(object):

    def override(self):
        print("КЛАСС OTHER override()")

    def implicit(self):
        print("КЛАСС OTHER implicit()")

    def altered(self):
        print("КЛАСС OTHER altered()")

class Child(object):

    def __init__(self):
        self.other = Other()

    def implicit(self):
        self.other.implicit()

    def override(self):
        print("ПОТОМОК override()")

    def altered(self):
        print("ПОТОМОК, ДО ВЫЗОВА altered() В КЛАССЕ OTHER")
        self.other.altered()
        print("ПОТОМОК, ПОСЛЕ ВЫЗОВА altered() В КЛАССЕ OTHER")

son = Child()

son.implicit()
son.override()
son.altered()