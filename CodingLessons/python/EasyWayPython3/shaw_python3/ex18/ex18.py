# похоже на сценарии с argv
def print_two(*args):
    arg1, arg2 = args
    print(f"arg1: {arg1}, arg2: {arg2}")

# ок, здесь вместо *args мы делаем следующее
def print_two_again(arg1, arg2):
    print(f"arg1: {arg1}, arg2: {arg2}")

# принимает только один аргумент
def print_one(arg1):
    print(f"arg1: {arg1}")

# не принимает аргументов
def print_none():
    print("А я ничего не получаю.")


print_two("Михаил","Райтман")
print_two_again("Михаил","Райтман")
print_one("Первый!")
print_none()