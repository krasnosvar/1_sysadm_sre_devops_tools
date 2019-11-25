#lst = input().split()
l = [10, 5, 8, 3]
def modify_list(*a):
    lst1=[]
    for i in l:
        if int(i) % 2 == 0:
            i = int(i)/2
            lst1.append(int(i))
    return lst1

print(modify_list(l))
lst = [1, 2, 3, 4, 5, 6]
print(modify_list(lst))
