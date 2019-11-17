numbers=[]
i=0
D=11
G=5

def my_func(i):
    #i=0
    while i<D:
        print(f"In the beginning i = {i}")
        numbers.append(i)
        
        i=i+1
        print("Current values: ", numbers)
        print(f"At the end value i is {i}")

    print("Values: ")

    for num in range(G):
        print(num)


my_func(i)
