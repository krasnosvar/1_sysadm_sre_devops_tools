class Parent(object):

    def implicit(self):
        print("РОДИТЕЛЬ implicit()")

class Child(Parent):
    pass

dad = Parent()
son = Child()

dad.implicit()

