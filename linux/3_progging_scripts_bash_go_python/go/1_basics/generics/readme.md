Go Generics Practice Tasks
1. Generic Min/Max

Write a generic function Min that returns the smallest of two values.

Then write Max.

Constraints: T comparable.

Example:

fmt.Println(Min(3, 7))          // 3
fmt.Println(Max("apple", "go")) // go

2. Generic Sum

Define a constraint Number that allows int | float64.

Write a function Sum[T Number]([]T) T that adds up slice elements.

Example:

fmt.Println(Sum([]int{1, 2, 3}))       // 6
fmt.Println(Sum([]float64{1.5, 2.5})) // 4

3. Generic Map Function

Write a function:

func Map[T any, R any](vals []T, f func(T) R) []R


It applies f to every element.

Example:

nums := []int{1, 2, 3}
squared := Map(nums, func(x int) int { return x * x })
fmt.Println(squared) // [1 4 9]