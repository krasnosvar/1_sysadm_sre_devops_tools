class ex411:
    def s_method(self, fio, group, type1, digit=0):
        if digit==2:
            type1="dvoechnik"
        elif digit==3:
            type1="serednyachok"
        elif digit==4:
            type1="horoshist"
        elif digit==5:
            type1="otlichnik"
fio=input("Enter FIO: "); group=input("Enter GROUP: ")
digit=input("ENTER LAST EXAM OCENKA: "); type2=0
student411=ex411(fio, group, type2, digit)
print(student411)
