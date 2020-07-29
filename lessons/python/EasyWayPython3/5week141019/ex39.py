#sheme nets abbreviatures with country names
states = {
    'Russia': 'RU',
    'Germany': 'DE',
    'Uzbekistan': 'UZ',
    'Zimbabve': 'ZW',
    'Turkey': 'TR'
}

#base set of countries and their cities creating
cities = {
    'UZ': 'Guzli',
    'TR': 'Sarygme',
    'DE': 'Munich'
}

#add some cities
cities['ZW'] = 'Gveru'
cities['RU'] = 'Moscow'

#some cities output
print('-'*10)
print("In country ZW here city: ", cities['ZW'])
print("In country RU here city: ", cities['RU'])

#print some countries
print('-'*10)
print("Turkey abbreviature: ", states['Turkey'])
print("Germany abbreviature: ", states['Germany'])

#print with country and city
print('-'*10)
print("Here in Turkey city: ", cities[states['Turkey']])
print("Here in Germany city: ", cities[states['Germany']])

#print all coutries abbreviatures
print('-'*10)
for state, abbrev in list(states.items()):
    print(f"{state} has abbreviature {abbrev}")

# вывод всех городов в странах
print('-' * 10)
for abbrev, city in list(cities.items()):
    print(f"В стране {abbrev} есть город {city}")

# а теперь сразу оба типа данных
print('-' * 10)
for state, abbrev in list(states.items()):
    print(f"В стране {state} используется аббревиатура {abbrev}")
    print(f"и есть город {cities[abbrev]}")

print('-' * 10)
# безопасное получение аббревиатуры страны, которая не представлена
state = states.get('США')

if not state:
    print("Прошу прощения, США не существует или уничтожено.")

# получение города со значение по умолчанию
city = cities.get('US', 'не существует')
print(f"В стране 'US' есть город: {city}")
