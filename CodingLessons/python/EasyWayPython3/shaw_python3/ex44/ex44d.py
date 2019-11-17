class Parent(object):

    def override(self):
        print("РОДИТЕЛЬ override()")

    def implicit(self):
        print("РОДИТЕЛЬ implicit()")

    def altered(self):
        print("РОДИТЕЛЬ altered()")

class Child(Parent):

    def override(self):
        print("ПОТОМОК override()")

    def altered(self):
        print("ПОТОМОК, ДО ВЫЗОВА altered() В РОДИТЕЛЕ")
        super(Child, self).altered()
        print("ПОТОМОК, ПОСЛЕ ВЫЗОВА altered() В РОДИТЕЛЕ")

dad = Parent()
son = Child()

dad.implicit()
son.implicit()

dad.override()
son.override()

dad.altered()
son.altered()