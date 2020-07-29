#ex 4.4
class summarize:
    var1=3
    def method_name(self, var2, var3=var1):
        self.var4=var2+var3
        print(f"Var4={self.var4}")
        print(f"Var1={self.var1}")
obj1=summarize()
obj1.method_name(2)

#ex4.5 str.159
class summarize2:
    def __init__(self, var5):
        self.var1 = var5
obj2 = summarize2(4)
print(f"Var1={obj2.var1}")

#ex 4.6 str159
# class student:
#     kurs = 2

# student1 = student()
# student2 = student()
# print(f"Student 1 studies on {student1.kurs} course")
# print(f"Student 2 studies on {student2.kurs} course")

#ex 4.7 str 159
class student:
    def __init__(self, kurs):
        self.kurs = kurs
student1 = student(2)
student2 = student(3)
print(f"Student 1 studies on {student1.kurs} course")
print(f"Student 2 studies on {student2.kurs} course")
