from sys import exit

def gold_room():
    print("Здесь полно золота. Сколько кг ты унесешь?")

    choice = input("> ")
    if "0" in choice or "1" in choice:
        how_much = int(choice)
    else:
        dead("Эй, ввести надо число.")

    if how_much < 50:
        print("Шикарно! Ты не жадный, поэтому выигрываешь!")
        exit(0)
    else:
        dead("Ах ты жадина!")


def bear_room():
    print("Здесь сидит медведь.")
    print("У медведя бочка с медом.")
    print("Медведь закрыл собой дверь выхода.")
    print("Как переместить медведя? Отобрать мед или подразнить медведя?")
    bear_moved = False

    while True:
        choice = input("> ")

        if choice == "отобрать мед":
            dead("Медведь посмотрел на тебя и ударил лапой по лицу.")
        elif choice == "подразнить медведя" and not bear_moved:
            print("Медведь отошел от двери.")
            print("Вы можете войти в нее. Подразнить медведя или войти в дверь?")
            bear_moved = True
        elif choice == "подразнить медведя" and bear_moved:
            dead("Медведь разозлился и откусил тебе ногу.")
        elif choice == "войти в дверь" and bear_moved:
            gold_room()
        else:
            print("Введите одно из предложенных действий.")


def cthulhu_room():
    print("На тебя смотрит великий и ужасный Ктулху.")
    print("Он смотрит на тебя, и ты начинаешь сходить с ума.")
    print("Убежать или начать сражаться?")

    choice = input("> ")

    if "убежать" in choice:
        start()
    elif "начать сражаться" in choice:
        dead("Хм, возможно, даже удастся победить!")
    else:
        cthulhu_room()


def dead(why):
    print(why, "Великолепно!")
    exit(0)

def start():
    print("Ты в темной комнате.")
    print("Отсюда ведут две двери, налево и направо.")
    print("Куда ты повернешь?")

    choice = input("> ")

    if choice == "налево":
        bear_room()
    elif choice == "направо":
        cthulhu_room()
    else:
        dead("Ты ходишь из комнаты в комнату, пока не умираешь с голоду.")


start()