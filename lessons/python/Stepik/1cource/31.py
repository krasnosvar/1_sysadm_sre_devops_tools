x=float(input("Enter (x):"))
y=0

def f(y):
    #y=0
    # put your python code here
    if x <=-2:
       y=(1-(x-2)**2)
    elif -2<x<=2:
        y=(-(x/2))
    elif 2<x:
        y=((x-2)**2+1)
    print(y)
f(y)
