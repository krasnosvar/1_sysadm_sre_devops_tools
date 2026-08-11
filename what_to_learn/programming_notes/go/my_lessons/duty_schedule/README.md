# Admin on Duty Sheduler
1. App uses ```txt``` with admins list file to build calendar till year end
```
# go run main.go                                                     
Date-time now: 2024-02-08 13:43:38.566129254 +0300 MSK m=+0.000014522
[Roma 777 Boris 111 Igor 222 John 333 Denis 444 Ramir 555 Nikolya 666]
-----------------------------------------
Admin On Duty NOW: Roma 777
-----------------------------------------
DayNum| Year| Month| WeekNum| WeekDay| Day| Admin on Duty
---------------------------------------------------------------------------------
34   | 0 |  | 0 |  | 0 | Roma 777
41   | 2024 | February | 6 | Saturday | 10 | Boris 111
48   | 2024 | February | 7 | Saturday | 17 | Igor 222
55   | 2024 | February | 8 | Saturday | 24 | John 333
62   | 2024 | March | 9 | Saturday | 2 | Denis 444
69   | 2024 | March | 10 | Saturday | 9 | Ramir 555
76   | 2024 | March | 11 | Saturday | 16 | Nikolya 666
83   | 2024 | March | 12 | Saturday | 23 | Roma 777
90   | 2024 | March | 13 | Saturday | 30 | Boris 111
97   | 2024 | April | 14 | Saturday | 6 | Igor 222
104   | 2024 | April | 15 | Saturday | 13 | John 333
...
...
328   | 2024 | November | 47 | Saturday | 23 | Roma 777
335   | 2024 | November | 48 | Saturday | 30 | Boris 111
342   | 2024 | December | 49 | Saturday | 7 | Igor 222
349   | 2024 | December | 50 | Saturday | 14 | John 333
356   | 2024 | December | 51 | Saturday | 21 | Denis 444
363   | 2024 | December | 52 | Saturday | 28 | Ramir 555

```




* BUGS
1. if number of duty admins is 7, bug occurs (will fix later_) - fixed
