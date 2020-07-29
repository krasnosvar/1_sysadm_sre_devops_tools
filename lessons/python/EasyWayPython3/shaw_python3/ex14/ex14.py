from sys import argv

script, user_name = argv
prompt = '> '

print(f"Привет, {user_name}, я - сценарий {script}.")
print("Я хочу задать тебе несколько вопросов.")
print(f"Я тебе нравлюсь, {user_name}?")
likes = input(prompt)

print(f"Где ты живешь, {user_name}?")
lives = input(prompt)

print("На каком компьютере ты работаешь?")
computer = input(prompt)

print(f"""
Итак, ты ответил {likes} на вопрос, нравлюсь ли я тебе.
Ты живешь {lives}. Не представляю, где это.
И у тебя есть компьютер {computer}. Прекрасно!
""")