a = input()
b = a[:a.find("h") + 1]
c = a[a.rfind("h"):]
f = a[a.find("h") + 1:a.rfind("h")].replace("h", "H")
e = b + f + c
print(e)
