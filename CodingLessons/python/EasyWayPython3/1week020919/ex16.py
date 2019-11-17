from sys import argv

script, filename = argv

print(f"I am gonig to erase file {filename}.")
print("if you do not want to erase it, press CTRL+C (^C).")
print("If you want to erase it, press ENTER.")

input("?")

print("Opening file...")
target = open(filename, 'w')

print("Cleaning file. Goodbye!")
target.truncate()

print("Now i am requesting three strings.")

line1 = input("string 1: ")
line2 = input("string 2: ")
line3 = input("string 3: ")

print("I will write it into file")


for i in line1, line2, line3:
    target.write(i+"\n")
    #target.write("\n")
# target.write(line1)
# target.write("\n")
# target.write(line2)
# target.write("\n")
# target.write(line3)
# target.write("\n")

print(f"File {filename} contents: ")
target = open(filename)
print(target.read())
print("Finally, i will close the file")
target.close()

