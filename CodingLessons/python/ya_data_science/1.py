emojixpress = [2.26, 19.1, 25.6, 233.0, 15.2, 22.7, 64.6, 87.5, 6.81, 6.0]
index_digit = 0
sum = 0 
while index_digit <= len(emojixpress) - 1:
    sum += index_digit
    index_digit += 1
    
total = sum
print("{:.2f}".format(total))
# print(emojixpress[0])
# print(len(emojixpress))
