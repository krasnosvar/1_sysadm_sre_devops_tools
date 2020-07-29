class MyStuff(object):
    #1.Python создает пустой объект со всеми функциями, указанными вами
    #в классе с помощью ключевого слова def
    #2.Python затем ищет волшебную функцию __ init__ и, если она
    #обнаружена, вызывает ее для инициализации созданного пустого объекта.
    #3.В классе MyStuff с помощью конструктора__ init__ передает­ся 
    #параметр self, на место которого будет помещен пустой объект,
    #создаваемый Python, кроме того я могу установить дополнительные
    #параметры так же, как и при работе с модулем, словарем или другим
    #объектом.
    def __init__(self):
        #В примере я присвоил переменной self.tangerine текст из пес­ни, 
        #а затем инициализировал этот объект.
        self.tangerine= "Pust begut neukluzhe"

    def apple(self):
        print("I AM THE SWEETIEST APPLE!")

#Python ищет функцию MyStuff () и обнаруживает, что это объяв­ленный вами класс.
#Теперь Python берет этот созданный объект и присваивает его пере­
#менной thing, чтобы я смог работать с ней.
thing=MyStuff()

thing.apple()
print(thing.tangerine)