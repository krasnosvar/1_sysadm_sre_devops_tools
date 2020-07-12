package main

import "fmt"

var test int = 100 //global variable

func main() {
	fmt.Println(test)
	//multiple variables in a row(несколько переменных подряд)
	var (
		a = 5
		b = 10
		c = 15
	)
	fmt.Println(a, b, c)
	const ( //const - immutable variables(неизменяемые переменные)
		piConst = 3.14
		myName  = "Den"
	)
	fmt.Println(piConst, myName)
	//simple digit, 1st metod:
	randomNum := 111
	//second method with "var"
	var var1, var2 = 10, 20
	var bigInt int64 = 1<<32 - 1
	//float variable
	var pi float32 = 3.14
	//strings
	var hello string = "Hello\n\t"
	var hello2 string = "Hello"
	//lengthInRunes := utf8.RuneCountString(hello2)
	//fmt.Println(lengthInRunes) //length

	var hello3 string = "World!"
	//concatenate strings
	hello4 := hello2 + " " + hello3
	hello5 := "HEllo" + " World!_2"
	fmt.Println(randomNum, "\n", var1, var2, bigInt)
	fmt.Println(pi)
	fmt.Println(len(hello)) // length in BYTES!
	fmt.Println(hello4)
	fmt.Println(hello5)

	var x string
	x = "first"
	fmt.Println(x)
	x = "second"
	fmt.Println(x)
	x = x + "second"
	fmt.Println(x)

	//Fahrenheit to Celsium
	var (
		fahrenDegree  = 0
		celsiumDegree = (fahrenDegree - 32) * 5 / 9
	)
	fmt.Println(celsiumDegree)

}
