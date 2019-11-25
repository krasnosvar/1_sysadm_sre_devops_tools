read_from_file = open('testfile.txt','r')
str1= read_from_file.readline().strip()
print(str1)
read_from_file.close()

#построчное чтение файла
# with open file.txt as inf:
#     for line in inf:
#         line=line.strip()
#         print(line)

#задание 1
import re # Импорт модуля для работы с регулярными выражениями 
read_from_file = open('testfile.txt','r')
str1= read_from_file.readline().strip()# Данные из файла с удалением системных символов(стрип)

# def numbers_from_string(data):                 # Функция берёт строку
#     result = " ".join(re.findall(r'\w\d+', '.', data)) # находит все числа в строке и склеивает их в строку 
#     return result                               # возвращает полученный результат

# def main():
#     print(numbers_from_string(str1))         # Вызов функции и печать результата

# if __name__ == '__main__':
#     main()
numbers, lit = list(re.findall(r'\d+', str1)), list(re.findall(r'\D', str1))

print(''.join(int(x) * y for x, y in zip(numbers, lit)))