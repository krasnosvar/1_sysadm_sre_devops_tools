from sys import argv
from os.path import exists

script, from_file, to_file = argv

print(f"Copying data from file {from_file} to {to_file}")

#
#in_file = open(from_file)
indata =  open(from_file).read()

print(f"First file size {len(indata)} bytes")

print(f"Target file exists? {exists(to_file)}")
print(f"Ready, press ENTER to continue or CTRL+C for cancel")
input()

out_file = open(to_file, 'w').write(indata)
#out_file.write(indata)

print("Well done, all is ok")

# out_file.close()
# in_file.close()
