

# a=int(input())
# b=0
# c=0

# while 0==0:
#     #a=int(input())
#     b+=a
#     c +=a**2
#     if b==0:    
#         print(c)

number = 0
while number <= 1000:
    number +=1
    if (number%2) != 0:
        continue
    print("Четное число", number)
