r=sorted(list(input().split()))
#создаем второй список из первого через генератор списка r[i] for i in range(len(r))
#оставляя только повторяющиеся значения через комбинацию if not i == r.index(r[i])
dd=[r[i] for i in range(len(r)) if not i == r.index(r[i])]
#создаем третий, пустой список для цикла 
y=[]
#y=[dd[ff] for ff in dd if ff not in dd==dd.append(ff) ]
#создаем цикл, добавляем значения из второго списка только по одному разу
for ff in dd:
    if ff not in y:
        y.append(ff)
#вывести только значения списка (без скобок и кавычек) через пробел
print(" ".join(map(str, y)))
