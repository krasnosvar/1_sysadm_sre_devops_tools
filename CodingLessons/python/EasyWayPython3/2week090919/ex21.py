def add(a, b):
    print(f"add {a} + {b}")
    return a + b

def subtract(a, b):
    print(f"Subtract {a} - {b}")
    return a - b

def multiply(a, b):
    print(f"Multiply {a} * {b}")
    return a*b

def divide(a, b):
    print(f"Divide {a}/{b}")
    return a / b

print("Lets do some tasks with functions!")


age = add(30, 5)
height = subtract(190, 4)
weight = multiply(35, 2)
iq = divide(250,2)

print(f"Age: {age}, Height {height}, Weight {weight}, IQ {iq}")

print("This is golovolomka")

what = add(age, subtract(height, multiply(weight, divide(iq,2))))
print(what)