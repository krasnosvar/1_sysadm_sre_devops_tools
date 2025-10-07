package main

import (
	"fmt"
	"time"
)

// var IntetfaceMap map[interface{}]interface{}

func main() {
	username := "Den"
	IntetfaceMap := map[interface{}]interface{}{
		"username": username,
		"exp":      time.Now().Add(time.Hour * 24).Unix(),
		1:          22,
		2:          []string{"den", "admin"},
	}
	fmt.Println(IntetfaceMap)
	// Type assertion to get the underlying slice
	if s, ok := IntetfaceMap[2].([]string); ok {
		// Now len() can be called on the concrete slice 's'
		length := len(s)
		fmt.Printf("The length of the slice is: %d\n", length)
	} else {
		fmt.Println("The interface does not contain a []int slice.")
	}

}

// map[exp:1758346336 username:Den 1:22 2:[den admin]]
// The length of the slice is: 2
