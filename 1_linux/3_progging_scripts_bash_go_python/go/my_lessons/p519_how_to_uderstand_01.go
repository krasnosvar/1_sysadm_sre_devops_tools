package main

import "fmt"

func main() {
	fmt.Printf("%3d: %08b\n", 0, 0)
	fmt.Printf("%3d: %08b\n", 1, 1)
	fmt.Printf("%3d: %08b\n", 2, 2)
	fmt.Printf("%3d: %08b\n", 3, 3)
	fmt.Printf("%3d: %08b\n", 4, 4)
	fmt.Printf("%3d: %08b\n", 5, 5)
	fmt.Printf("%3d: %08b\n", 6, 6)
	fmt.Printf("%3d: %08b\n", 7, 7)
	fmt.Printf("%3d: %08b\n", 8, 8)
	fmt.Printf("%3d: %b\n", 10, 10)
}

//   0: 00000000
//   1: 00000001
//   2: 00000010
//   3: 00000011
//   4: 00000100
//   5: 00000101
//   6: 00000110
//   7: 00000111
//   8: 00001000
