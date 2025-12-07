# Примеры реального применения sync.Mutex в Go

## 1. Глобальный мьютекс для общей структуры

``` go
var mu sync.Mutex
var counter int

func Inc() {
    mu.Lock()
    counter++
    mu.Unlock()
}
```

## 2. Мьютекс внутри структуры (как поле)

``` go
type SafeMap struct {
    mu  sync.Mutex
    m   map[string]int
}

func (s *SafeMap) Set(k string, v int) {
    s.mu.Lock()
    s.m[k] = v
    s.mu.Unlock()
}
```

## 3. Мьютекс как приёмник (метод)

``` go
type Counter struct {
    mu sync.Mutex
    n  int
}

func (c *Counter) Add(x int) {
    c.mu.Lock()
    c.n += x
    c.mu.Unlock()
}
```

## 4. Локальный мьютекс в функции

``` go
func Process() {
    mu := sync.Mutex{}
    mu.Lock()
    fmt.Println("locked section")
    mu.Unlock()
}
```

## 5. Мьютекс на каждую запись (sharding)

``` go
type Sharded struct {
    mu  [256]sync.Mutex
    arr [256]int
}

func (s *Sharded) Add(i int) {
    idx := i % 256
    s.mu[idx].Lock()
    s.arr[idx]++
    s.mu[idx].Unlock()
}
```
