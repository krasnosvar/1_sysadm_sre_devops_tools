a, b = str(input()), str(input())

class Person:
    def __init__(self, name, surname):
        self.name = name
        self.surname = surname
den = Person(a, b)
print(f"Your name is: {den.name} {den.surname}")

