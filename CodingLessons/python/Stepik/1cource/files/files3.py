# read_from_file = open('testfile.txt','r')
# str1= read_from_file.readline().strip()

import requests
url_got = requests.get("https://ya.ru")
# read_from_file.close()
string_count = url_got.text
# write_to_file = open('1.txt','w')
# read_from_file2 = open('1.txt','r')
# str2= read_from_file2.readline().strip()
# count = sum(1 for line in str2 if line.rstrip('\n'))
# with open('1.txt') as myfile:
#     count = sum(1 for line in myfile)
print(string_count)
# myfile.close()
