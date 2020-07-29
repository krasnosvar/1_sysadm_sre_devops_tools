states = {
    'Russia': 'RU',
    'Germany': 'DE',
    'Uzbekistan': 'UZ',
    'Zimbabve': 'ZW',
    'Turkey': 'TR'
}
print(states)
for countries, abbs in list(states.items()):
    print(f"In conutry {countries} used shortname {abbs}")

state = states.get('США')
russia=states.get('Russia')
if True == state:
    print("Прошу прощения, США не существует или уничтожено.")
else:
     print(russia)
