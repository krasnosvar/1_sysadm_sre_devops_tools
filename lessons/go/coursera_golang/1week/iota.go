package main

//import "fmt"

func (day Weekday) String() string {
	// declare an array of strings
	// ... operator counts how many
	// items in the array (7)
	names := [...]string{
		"Sunday",
		"Monday",
		"Tuesday",
		"Wednesday",
		"Thursday",
		"Friday",
		"Saturday"}
	// → `day`: It's one of the
	// values of Weekday constants.
	// If the constant is Sunday,
	// then day is 0.
	//
	// prevent panicking in case of
	// `day` is out of range of Weekday
	if day < Sunday || day > Saturday {
		return "Unknown"
	}
	// return the name of a Weekday
	// constant from the names array
	// above.
	return names[day]
	//fmt.Println(names[day])
	//fmt.Printf("Which day it is? %s\n", Sunday)
	// Which day it is? Sunday
}
