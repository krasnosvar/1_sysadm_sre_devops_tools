
class student:
    def __init__(self, kurs, id1):
        self.kurs=kurs #usual arg
        self.__id=id1 #private arg
id1=input("Enter id: ")
student1=student(1, id1)
print(student1._student__id)

