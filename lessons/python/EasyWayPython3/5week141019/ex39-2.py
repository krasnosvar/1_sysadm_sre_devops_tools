#create empy dictionary
d={}
#begin loop with range 1-10
for i in range(1,11):
    #in loop create dictionary with key i, and value i*i
    d1=dict([(i, i*i)])
    #join "d1" to "d"
    d.update(d1)
print(d)
#print key "5"
print(d[5])


log=[['Ivanov','123','Иванов Петр Петрович','ivanov0mail.ru'],['Sidorov','123','Сидоров Иван Иванович', 'sidorov0yandex.ru']]
d2={1:log[0],2:log[1]}
print('Сотрудник c id1:',d2[1])
print('Сотрудник c id2:',d2[2])
list1=d2[1]

print('Mail cотрудникa c id1:',list1[3])

print("#"*100)
#method "items" can be used with loop "for"
for keys,values in d2.items():
    print(f"Mail employee {keys}:", values[3])

d = {}
key=int(input)
value=int(input)
def update_dictionary(d, key, value):
    