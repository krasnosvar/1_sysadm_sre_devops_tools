#установить либу для чтения docx
#pip3 install docx2txt

import docx2txt
my_text = docx2txt.process("teams.docx")
print(my_text)
