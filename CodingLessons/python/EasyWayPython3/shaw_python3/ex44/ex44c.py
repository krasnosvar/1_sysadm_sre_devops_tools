class Parent(object):

    def altered(self):
        print("РОДИТЕЛЬ altered()")

class Child(Parent):

    def altered(self):
        print("ПОТОМОК, ДО ВЫЗОВА altered() В РОДИТЕЛЕ")
        super(Child, self).altered()
        print("ПОТОМОК, ПОСЛЕ ВЫЗОВА altered() В РОДИТЕЛЕ")

dad = Parent()
son = Child()

dad.altered()
son.altered()