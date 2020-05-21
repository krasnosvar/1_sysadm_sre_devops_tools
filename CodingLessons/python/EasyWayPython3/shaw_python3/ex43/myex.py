from sys import exit
from random import randint
from textwrap import dedent

class Scene:
    def enter(self):
        exit(1)

class Engine:
    def __init__(self, scene_map):
        self.scene_map = scene_map
    