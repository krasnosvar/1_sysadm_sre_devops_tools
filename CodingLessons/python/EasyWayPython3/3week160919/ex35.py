from sys import exit

def gold_room():
    print("here is a lot of gold. How many kg do you take?")

    choice=input("> ")
    if "0" in choice or "1" in choice:
        how_much=int(choice)
    else:
        dead("Hey, enter the digit!")

    if how_much<50:
        print("Good! You are not greedly, you will win!")
        exit(0)
    else:
        dead("you are greedly!")

def bear_room():
    print("Here is a bear")
    print("He has a barrel with honey")
    print("How to transport bear? take honey or tease him?")
    bear_moved=False

    while True:
        choice=input("> ")

        if choice=="take honey":
            dead("Bear killed you!")
        elif choice=="tease bear" and not bear_moved:
            print("bear go away from the door")
            print("YOU can enter. Tease bear or enter?")
            bear_moved=True
        elif choice=="tease bear" and bear_moved:
            dead("Bear eat your leg")
        elif choice=="enter" and bear_moved:
            gold_room()
        else:
            print("Enter one of given choices")

def chtulhu_room():
    print("Kxtulhu watchng on you")
    print("you are crazy")
    print("Run or fight?")

    choice=input("> ")

    if "run" in choice:
        start()
    elif "fight" in choice:
        dead("Hmmm, may be you can win")
    else:
        chtulhu_room()

def dead(why):
    print(why, "Great!")
    exit(0)

def start():
    print("you are in dark room")
    print("There are two doors-reft and right")
    print("Where do you go?")

    choice=input("> ")

    if choice=="left":
        bear_room()
    elif choice=="right":
        chtulhu_room()
    else:
        dead("YOU DEAD!")


start()
