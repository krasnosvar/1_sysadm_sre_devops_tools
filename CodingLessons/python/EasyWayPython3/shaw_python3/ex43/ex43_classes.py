from sys import exit
from random import randint
from textwrap import dedent

class Scene(object):

    def enter(self):
        print("Эта сцена еще не настроена.")
        print("Создайте подкласс и реализуйте функцию enter().")
        exit(1)

class Engine(object):

    def __init__(self, scene_map):
        self.scene_map = scene_map

    def play(self):
        current_scene = self.scene_map.opening_scene()
        last_scene = self.scene_map.next_scene('finished')

        while current_scene != last_scene:
            next_scene_name = current_scene.enter()
            current_scene = self.scene_map.next_scene(next_scene_name)

        # не забудьте вывести последнюю сцену
        current_scene.enter()

class Death(Scene):

    quips = [
        "Ты погиб.  Как это ни печально.",
        "Твоя мать будет грустить по тебе... надо было быть умнее.",
        "Надо же было быть таким придурком.",
        "Даже мой маленький щенок соображает лучше.",
        "Когда ж ты повзрослеешь, как говорил твой папка."

    ]

    def enter(self):
        print(Death.quips[randint(0, len(self.quips)-1)])
        exit(1)

class CentralCorridor(Scene):

    def enter(self):
        print(dedent("""
            Готоны с планеты Перкаль 25 захватили ваш корабль и уничтожили 
            всю команду. Ты - единственный, кто остался в живых. Тебе нужно 
            выкрасть нейтронную бомбу в оружейной лаборатории, заложить ее 
            в топливном отсеке и покинуть корабль в спасательной капсуле 
            прежде, чем он взорвется.

            Ты бежишь по центральному коридору в оружейную лабораторию, когда 
            перед тобой появляется готон с красной чешуйчатой кожей, гнилыми 
            зубами и в костюме клоуна. Он с ненавистью смотрит на тебя и, 
            перегородив дорогу в лабораторию, вытаскивает бластер, чтобы 
            отправить тебя к праотцам.
            -----------------------------------------------------------------
            "стрелять!"
            "пошутить!"
            """))

        action = input("> ")

        if action == "стрелять!":
            print(dedent("""
                Ты быстро выхватываешь бластер и начинаешь палить по готону. 
                Его клоунский наряд крутится на теле, мешая лучам попадать 
                в цель. Все твои выстрелы потерпели неудачу и заряд бластера 
                иссяк. Костюм готона, который купила его мать, безнадежно 
                испорчен, поэтому инопланетянин в ярости выхватывает бластер 
                и стреляет тебе в голову. В панике ты пытаешься удрать и, 
                резко повернувшись, ударяешься головой о балку и теряешь 
                сознание. Ты пал смертью храбрых.
                """))
            return 'death'

        elif action == "проскочить!":
            print(dedent("""
                Словно боксер мирового класса, ты уворачиваешься и проскакиваешь 
                мимо готона, краем глаза замечая, что его бластер направлен 
                тебе в голову. И тут ты подскальзываешься и врезаешься в 
                стену. От удара ты теряешь сознание. Придя в сознание, ты 
                успеваешь почувствовать, что готон топчется на твоей голове 
                и пожирает тебя. Свет меркнет перед глазами.
                """))
            return 'death'

        elif action == "пошутить!":
            print(dedent("""
                К счастью, ты знаком с культурой готонов и знаешь, что 
                может их рассмешить. Ты рассказываешь бородатый анекдот: 
                Неоколонии, изоморфно релятивные к мyльтиполосным гиперболическим 
                параболоидам, теоретически катаральны. 
                Готон замирает, старается сдержать смех, а затем начинает 
                безудержно хохотать. Пока он смеется, ты достаешь бластер 
                и стреляешь готону в голову. Он падает, а ты перепрыгиваешь его 
                и бежишь в оружейную лабораторию.
                """))
            return 'laser_weapon_armory'

        else:
            print("ТАК НЕЛЬЗЯ ПОСТУПИТЬ!")
            return 'central_corridor'

class LaserWeaponArmory(Scene):

    def enter(self):
        print(dedent("""
            Ты вбегаешь в оружейную лабораторию и начинаешь обыскивать 
            комнату, спрятались ли тут другие готоны.  Стоит мертвая тишина. 
            Ты бежишь в дальний угол комнаты и находишь нейтронную бомбу в 
            защитном контейнере. На лицевой стороне контейнера расположена 
            панель с кнопками и тебе надо ввести правильный код, чтобы 
            достать бомбу. Если ты 10 раз введешь неправильный код, контейнер 
            заблокируется и ты не сможешь достать бомбу. Учти, что код 
            состоит из 3 цифр.
            """))

        code = 123 #f"{randint(1,9)}{randint(1,9)}{randint(1,9)}"
        guess = int(input("[keypad]> "))
        guesses = 0

        while guess != code and guesses < 10:
            print("ВЖЖЖИИИК!")
            guesses += 1
            guess = input("[keypad]> ")

        if guess == code:
            print(dedent("""
                Контейнер открывается со щелчком и выпускает сизый газ. 
                Ты вытаскиваешь нейтронную бомбу и бежишь в топливный отсек, 
                чтобы установить бомбу в нужном месте, активировать ее и 
                успеть смотаться с корабля.
                """))
            return 'the_bridge'
        else:
            print(dedent("""
                Ты слышишь, как замок жужжит последний раз, а затем 
                чувствуешь запах гари - замок расплавился. Ты остаешься 
                в оружейной лавке, пока наконец готоны не взрывают 
                корабль выстрелом со своего судна и ты не умираешь.
                """))
            return 'death'

class TheBridge(Scene):

    def enter(self):
        print(dedent("""
            
            """))

class Finished(Scene):

    def enter(self):
        print("Ты победил! Отличная работа.")
        return 'finished'

class Map(object):

    scenes = {
        'central_corridor': CentralCorridor(),
        'laser_weapon_armory': LaserWeaponArmory(),
        #'the_bridge': TheBridge(),
        #'escape_pod': EscapePod(),
        'death': Death(),
        'finished': Finished(),
    }

    def __init__(self, start_scene):
        self.start_scene = start_scene

    def next_scene(self, scene_name):
        val = Map.scenes.get(scene_name)
        return val

    def opening_scene(self):
        return self.next_scene(self.start_scene)

a_map = Map('central_corridor')
a_game = Engine(a_map)
a_game.play()


# class Scene(object):

#     def enter(self):
#         pass


# class Engine(object):

#     def __init__(self, scene_map):
#         pass

#     def play(self):
#         pass

# class Death(Scene):

#     def enter(self):
#         pass

# class CentralCorridor(Scene):

#     def enter(self):
#         pass

# class LaserWeaponArmory(Scene):

#     def enter(self):
#         pass

# class TheBridge(Scene):

#     def enter(self):
#         pass

# class EscapePod(Scene):

#     def enter(self):
#         pass


# class Map(object):

#     def __init__(self, start_scene):
#         pass

#     def next_scene(self, scene_name):
#         pass

#     def opening_scene(self):
#         pass


# a_map = Map('central_corridor')
# a_game = Engine(a_map)
# a_game.play()