package main

import "fmt"

func main() {
	// https://www.reddit.com/r/golang/comments/11cotpl/iterate_over_2_arrays/
	firstArray := []string{"host1", "host2"}
	secondArray := []string{"something", "something2", "something3", "something4", "something5", "something6"}

	for i, el := range secondArray {
		fmt.Printf("%s, %s\n", firstArray[i%len(firstArray)], el)
	}

}

// Output:
// host1, something
// host2, something2
// host1, something3
// host2, something4
// host1, something5
// host2, something6
