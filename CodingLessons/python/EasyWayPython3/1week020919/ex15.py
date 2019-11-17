#import "argv" function from module "sys"
from sys import argv

#pass argument's names to "argv" function, to take filename to to next steps in script
#script, filename = argv
filename = input("Print filename to open: ")

#assign name "txt" to variable and say to it open file, used in variable "filename"
txt = open(filename)

#print name and path to file, wich we will be read
print(f"text of {filename}:")

#print content of file
print(txt.read())

# #read another filename to print it context
# print("enter filename again")
# file_again = input("> ")

# #assign variable "text_againt" to new file content
# text_again = open(file_again)

# #print content of new file
# print(text_again.read())
#txt.close()
#close(text_again)