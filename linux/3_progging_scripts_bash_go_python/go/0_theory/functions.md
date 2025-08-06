1. Function execution time output
```
// Implement logTime() function that doesn't take input parameters, determines and outputs to screen the execution time of your program.
// Time output should occur before main() function completion.
// https://stackoverflow.com/questions/45766572/is-there-an-efficient-way-to-calculate-execution-time-in-golang
func logTime() func() {
	start := time.Now()
	return func() {
		fmt.Printf("Exec time took %v\n", time.Since(start))
	}
}

func main() {
	defer logTime()()
}
```


1. Named Return Values
* In Go, you can name the return values of a function.
* https://www.w3schools.com/go/go_function_returns.php
```
package main
import ("fmt")

func myFunction(x int, y int) (result int) {
  result = x + y
  return
}

func main() {
  fmt.Println(myFunction(1, 2))
}
```

2. Store the Return Value in a Variable
```
package main
import ("fmt")

func myFunction(x int, y int) (result int) {
  result = x + y
  return
}

func main() {
  total := myFunction(1, 2)
  fmt.Println(total)
}
```

3. Recursive and Anonymous Function in Golang ( in one example)
* https://www.geeksforgeeks.org/recursive-anonymous-function-in-golang/
```
// Golang program to show
// how to create an recursive
// Anonymous function
package main

import (
	"fmt"
)

func main() {

	// Anonymous function
	var recursiveAnonymous func(int)
	
	// Passing arguments
	// to Anonymous function
	recursiveAnonymous = func(variable int) {
	
		// Checking condition
		// to return
		if variable == -1 {
		
			fmt.Println("Welcome to Geeks for Geeks!")
			return
		} else {
		
			fmt.Println(variable)
			
			// Calling same
			// function recursively
			recursiveAnonymous(variable - 1)
		}
	}
	
	// Main calling
	// of the function
	recursiveAnonymous(10)
}


Output:

10
9
8
7
6
5
4
3
2
1
0
Welcome to Geeks for Geeks!

```
