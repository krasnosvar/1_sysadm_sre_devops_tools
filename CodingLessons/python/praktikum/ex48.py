class student:
    def __init__(self, kurs, sex):
        self.kurs=kurs
        self._sex=sex
sex=input("Enter sex 1st student: ")
student1=student(2, sex)
print(student1._sex)

student1.sex="it"
print(student1.sex)
print(student1._sex)

print("#"*20)

class student2:
    def __init__(self2, kurs2,sex2):
        self.kurs2=kurs2
        self._sex2=sex2
@property

def sex2(self):
    return self._sex2
sex=input("Enter sex 2nd student: ")
student10=student(2, sex2)
student10.sex2="it"
