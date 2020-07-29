class Parent(object):

    def override(self):
        print("РОДИТЕЛЬ override()")

class Child(Parent):

    def override(self):
        print("ПОТОМОК override()")

dad = Parent()
son = Child()

dad.override()
son.override()