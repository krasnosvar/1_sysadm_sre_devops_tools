# class prakt44:
# var1 = 3 
#     def func(self, var2, var3 = var1):
#         self.var4 = var2*var3
#         print(self.var4)
# obj1 = prakt44()
# obj1.func(2)

# print("#"*30)

# class prakt45:
#     def __init__(self, var):
#         self.var1 = var
# obj2 = prakt45(4)
# print(obj2.var1)

# print("#"*30)

# class student:
#     def __init__(self, kurs):
#         self.kurs = kurs
# student1=student(2)
# student2=student(3)
# print(F"Student 1 studies on {student1.kurs} course")


class student:
    def __init__(self, kurs, sex):
        self.kurs=kurs#обычныйаргумент
        self._sex=sex#защищаемыйаргумент
sex=input('Введитепол1-гостудента:')
student1=student(2,sex)#созданиеэкземпляра
print(student1._sex)#печатьатрибутаэкземпляра
