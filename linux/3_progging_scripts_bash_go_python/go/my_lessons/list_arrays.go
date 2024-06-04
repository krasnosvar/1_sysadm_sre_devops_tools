package main

import "fmt"

func main() {
	// https://www.reddit.com/r/golang/comments/11cotpl/iterate_over_2_arrays/
	firstArray := []string{"host1", "host2"}
	secondArray := []string{"something", "something2", "something3", "something4", "something5", "something6"}

	// for _, host := range firstArray {
	// 	for _, thing := range secondArray {
	// 		fmt.Printf("%s, %s\n", host, thing)
	// 	}
	// }
	for i, el := range secondArray {
		fmt.Printf("%s, %s\n", firstArray[i%len(firstArray)], el)
	}

}
