class summarize:
    var1=3
    def method_name(self, var2, var3=var1):
        self.var4=var2+var3
        print(f"Var4={self.var4}")
        print(f"Var1={self.var1}")
obj1=summarize()
obj1.method_name(2)

print("#"*20)

class class2:
    def __init__(self, var1):
        self.var2=var1
obj2=class2(4)
obj10=class2(33)
print(obj2.var2)
print(obj10.var2)
print("#"*20)

#создн базовый класс student
class student:
    #аттрибуты класса student: cource2 и cource4, равные 2 и 4 соответственно
    course2=2
    course4=4

student1=student() #creating class exemplar
student2=student() #creating exemplar class(the same)
print(f"Student 1 studies on {student1.course2} course")
print(f"Student 2 studies on {student2.course4} course")

print("#"*20)

class student2:
    def __init__(self, course):
        #синтаксисЖ переменная=значение
        self.course=course
#для изменения свойства(атрибута) достаточно присвоить ему новое значение
student10=student2(4)
student20=student2(5)
#имя_экземпляра_класса.переменная
print(f"Student 10 studies on {student10.course} course")
print(f"Student 20 studies on {student20.course} course")

