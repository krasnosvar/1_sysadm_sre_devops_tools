def print_two_2(*args):
     arg1, arg2 = args
     print(f"arg1: {arg1}, arg2: {arg2}")

def print_two_again(arg1, arg2):
    print(f"arg1: {arg1}, arg2: {arg2}")

def print_one(arg1):
    print(f"arg1: {arg1}")

def print_none():
    print("I get nothing.")

print_two_2("Michael","Rightman")
print_two_again("Michael","Rightman")
print_one("First!")
print_none()
