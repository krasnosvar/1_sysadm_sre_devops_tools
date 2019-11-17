print("Let's practice!")
print("You should know about upravlaushie posledovatelnosti with \\, kotorye:")
print("\n rule strings and \t tabulation.")

poem = """
\tfor happiness
i need not mutch
I want you \n nezhno obnimat.
I want always
be near with you 
\n\t\tand never go away!
"""

print("----------------------------")
print(poem)
print("----------------------------")


five=10-2+3-6
print(f"Here should be five: {five}")

#вызвать функцию secret-formula со значением started

def secret_formula(started):
    #передать джели бинс значение стартед*500
    jelly_beans=started*500
    # передать джарс значеине джели_бинс/1000
    jars=jelly_beans/1000
    crates=jars/100
    #вернуть все три значения(а вывести их можно принтом), 
    #они связаны дргуг с другом, тк начинаются от значения стартед
    return jelly_beans, jars, crates

start_point=10000

#все три значения функции зазадаются через функцию с явно указанным значением старт_поинт
# и переназначим джели_бинс на бинс
beans, jars, crates=secret_formula(start_point)

#remember, this is another way to format string
# то есть начнем с 10000, выведем на экран значение через формат
print("Start with: {}".format(start_point))
#and with string f""
# выведем значения из самой первой функции, указав там стартед как
# старт_поинт, а она рана 10000
print(f"We have {beans} beans, {jars} jars and {crates} crates.")

# разделим значение на 10
start_point=start_point/10

# определим функцию как формула
print("We can do this that way:")
formula= secret_formula(start_point)
#Easy way to get list to formatting string
# передадим значения через формат
print("We have {} beans, {} jars and {} crates.".format(*formula))
