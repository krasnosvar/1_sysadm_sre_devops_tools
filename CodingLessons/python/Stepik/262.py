
#create empty list
v = []
#create input variable
n = int(input())
#create loop in range 1 to our digit "n", so "for" loop creates var "i", first == 1
for i in range(1, n+1):
    #in loop create variable "c", that is MINIMUMAL digit from our range, "1"
    c = min(n, i)
    #
    n = n - c
    #v = v+ str(i) + c
    v += [str(i)] * c
    # when n=0 stop script and print answer
    if n <= 0:
        break

print(" ".join(v))
