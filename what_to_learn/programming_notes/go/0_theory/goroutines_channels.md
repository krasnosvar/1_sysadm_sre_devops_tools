###### goroutines channels mutex concurrency

* Get number of currently running/active goroutines
* https://golangbyexample.com/number-currently-running-active-goroutines/
```
fmt.Println(runtime.NumGoroutine())
```

* Limit the Total Number of goroutines in Golang
* https://calmops.com/golang/golang-limit-total-number-of-goroutines/
```
When the waitChan is full(reach the limit of MAX_CONCURRENT_JOBS), 
the for loop blocks and waiting for one of the running goroutines to be completed, 
once a goroutine is completed, <-waitChan executed, a position in waitChan is released, 
then the for loop can continue to start another goroutine.

So the result is that the number of goroutines you will have is at most MAX_CONCURRENT_JOBS at the same time.


package main

import (
	"fmt"
	"math/rand"
	"time"
)

// change this for your situation, 20 or 30, 1,000 or 10,000 may be too high
const MAX_CONCURRENT_JOBS = 2

func main() {

	waitChan := make(chan struct{}, MAX_CONCURRENT_JOBS)
	count := 0
	for {
		waitChan <- struct{}{}
		count++
		go func(count int) {
			job(count)
			<-waitChan
		}(count)
	}
}

func job(index int) {
	fmt.Println(index, "begin doing something")
	time.Sleep(time.Duration(rand.Intn(10) * int(time.Second)))
	fmt.Println(index, "done")
}
```
