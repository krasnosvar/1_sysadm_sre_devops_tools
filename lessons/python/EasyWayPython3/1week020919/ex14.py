from sys import argv
script, user_name=argv
prompt='> '

print(f"Hello, {user_name},i am -script {script}.")
print(f'Do you like me, {user_name}?')
likes=input(prompt)


print(f"{user_name}, where do you live")
live=input(prompt)
print(f'''
Ok, you answered "{likes}" on question "Do i like you". You live in {live}. Great!
''')