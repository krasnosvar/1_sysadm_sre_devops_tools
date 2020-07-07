# -*- coding: utf-8 -*-
"""
hierarchical prompt usage example
"""
from __future__ import print_function, unicode_literals

from PyInquirer import style_from_dict, Token, prompt

from examples import custom_style_2


def ask_direction():
    directions_prompt = {
        'type': 'list',
        'name': 'direction',
        'message': 'Давай выбирай, что делаем?',
        'choices': ['Поприветствовать Лёху', 'Поехать с Лёхой в Крым', 'Поехать с Лёхой в Сочи', 'Бухать в Краснодаре']
    }
    answers = prompt(directions_prompt)
    return answers['direction']

# TODO better to use while loop than recursion!


def main():
    print('Наступило 31-е и Лёха приехал, чо делать будем?')
    exit_house()


def exit_house():
    direction = ask_direction()
    if (direction == 'Поехать с Лёхой в Крым'):
        print('Пиздорез, до этого Крыма как до Китая раком, особенно до Севастополя! Лучше-б бухали в Сочи. Мож в Сочи?')
        encounter1()
    else:
        print('Не, низя так, другое выбирай, а то Лёха расстроится')
        exit_house()


def encounter1():
    direction = ask_direction()
    if (direction == '1'):
        print('You attempt to fight the wolf')
        print('Theres a stick and some stones lying around you could use as a weapon')
        encounter2b()
    elif (direction == 'Поехать с Лёхой в Крым'):
        print('Ну ок, я предупреждал, и это, на всякий, бензика до Тамани закупите, а то там чутка дороже выйдет')
        encounter2a()
    else:
        print('Не, низя так, другое выбирай, а то Лёха расстроится')
        encounter1()


def encounter2a():
    direction = ask_direction()
    if direction == 'Поехать с Лёхой в Крым':
        output = 'Ебааать, бенз дорогой, связь стоит как алмазы, все в развалинах, пиздец, лучше-б бухали в Сочи:'
        print(output)
    else:
        print('Не, низя так, другое выбирай, а то Лёха расстроится')
        encounter2a()


def encounter2b():
    prompt({
        'type': 'list',
        'name': 'weapon',
        'message': 'Pick one',
        'choices': [
            'Use the stick',
            'Grab a large rock',
            'Try and make a run for it',
            'Attack the wolf unarmed'
        ]
    }, style=custom_style_2)
    print('The wolf mauls you. You die. The end.')


if __name__ == '__main__':
    main()
