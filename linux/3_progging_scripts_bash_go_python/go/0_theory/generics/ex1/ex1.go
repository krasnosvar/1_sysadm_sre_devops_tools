// 1. Generic Min/Max

// Write a generic function Min that returns the smallest of two values.

// Then write Max.

// Constraints: T comparable.

// Example:

// fmt.Println(Min(3, 7))          // 3
// fmt.Println(Max("apple", "go")) // go

package main

import (
	"fmt"

	"golang.org/x/exp/constraints" // Если ты не хочешь тянуть golang.org/x/exp/constraints (например, в проде), можно сделать свою обертку:
)

type Ordered interface {
	~int | ~float64 | ~string
}

func Min2[T Ordered](a, b T) T {
	if a < b {
		return a
	}
	return b
}

func Min[T constraints.Ordered](a, b T) T {
	if a < b {
		return a
	}
	return b
}

func Max[T constraints.Ordered](a, b T) T {
	if a > b {
		return a
	}
	return b
}

func main() {
	fmt.Println(Min(3, 7))          // 3
	fmt.Println(Max("apple", "go")) // go
	fmt.Println(Min2(3, 7))         // 3
}
