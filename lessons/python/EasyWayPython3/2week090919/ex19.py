cheese_count = int(input()); boxes_of_crackers=int(input())

def cheese_and_crackers(cheese_count, boxes_of_crackers):
    
    print(f"We have {cheese_count} cheese!")
    print(f"We have {boxes_of_crackers} boxes of crackers!")
    print("It will be enough for party!")
    print("Let's go!\n")

print("We can take numbers directly to function")
cheese_and_crackers(20, 30)

print("OR we can use variables from our script:")
amount_of_cheese = 10
amount_of_crackers = 50

cheese_and_crackers(amount_of_cheese,amount_of_crackers)

print("We can do math directly in function:")
cheese_and_crackers(10+20, 5+6)

print("And join variables with calculations:")
cheese_and_crackers(amount_of_cheese + 100, amount_of_crackers + 200)

cheese_and_crackers(cheese_count, boxes_of_crackers)