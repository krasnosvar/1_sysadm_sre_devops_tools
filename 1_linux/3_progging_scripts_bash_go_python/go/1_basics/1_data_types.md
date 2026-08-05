# Типы данных в Go

## Содержание

### Простые типы
- [Булевы типы](#булевы-типы)
  - bool
- [Числовые типы](#числовые-типы)
  - Целые числа со знаком: int8, int16, int32, int64, int
  - Целые числа без знака: uint8, uint16, uint32, uint64, uint
  - Специальные: byte, rune, uintptr
  - Числа с плавающей точкой: float32, float64
  - Комплексные числа: complex64, complex128
- [Строковый тип](#строковый-тип)
  - string

### Составные типы
- [Массивы](#массивы)
  - [n]T
- [Структуры](#структуры)
  - struct

### Ссылочные типы
- [Слайсы](#слайсы)
  - []T
- [Map](#map)
  - map[K]V
- [Указатели](#указатели)
  - *T
- [Функции](#функции)
  - func
- [Интерфейсы](#интерфейсы)
  - interface
- [Каналы](#каналы)
  - chan T

### Специальные типы
- error
- context.Context
- any (interface{})

### Дополнительно
- [Приведение типов](#приведение-типов)
- [Таблица нулевых значений](#таблица-нулевых-значений)
- [Размеры типов](#размеры-типов-64-bit)




## Булевы типы

### bool
```go
var b bool              // false (нулевое значение)
b = true
b = false

// Операторы: &&, ||, !
if b && !false {}
```

**Нюансы:**
- Нет автоматического приведения к bool (0, nil, "" не конвертируются в false)
- Нельзя использовать числа вместо bool
```go
if 1 {}        // ошибка компиляции
if x != 0 {}   // правильно
```

## Числовые типы

### Целые числа со знаком
```go
int8    // -128 до 127
int16   // -32768 до 32767
int32   // -2147483648 до 2147483647
int64   // -9223372036854775808 до 9223372036854775807
int     // зависит от платформы (32 или 64 бита)
```

### Целые числа без знака
```go
uint8   // 0 до 255
uint16  // 0 до 65535
uint32  // 0 до 4294967295
uint64  // 0 до 18446744073709551615
uint    // зависит от платформы (32 или 64 бита)
```

### Специальные целочисленные типы
```go
byte    // alias для uint8
rune    // alias для int32 (Unicode code point)
uintptr // беззнаковое целое для хранения указателя
```

**Нюансы:**
- int и int32 - РАЗНЫЕ типы (нужно явное приведение)
- Нулевое значение: 0
- Переполнение: wraparound без ошибки
```go
var x int32 = 100
var y int = 100
// x == y  // ошибка компиляции
int(x) == y  // правильно

var z int8 = 127
z++
fmt.Println(z)  // -128 (переполнение)
```

### Числа с плавающей точкой
```go
float32  // IEEE-754 32-bit
float64  // IEEE-754 64-bit
```

**Нюансы:**
- Нулевое значение: 0.0
- По умолчанию литералы - float64
- Нельзя сравнивать на равенство напрямую
```go
var f float64 = 0.1 + 0.2
fmt.Println(f == 0.3)  // false (проблема точности)

// Правильно:
const epsilon = 1e-9
if math.Abs(f - 0.3) < epsilon {}
```

### Комплексные числа
```go
complex64   // float32 real + float32 imag
complex128  // float64 real + float64 imag
```
```go
c := 1 + 2i
fmt.Println(real(c))  // 1
fmt.Println(imag(c))  // 2
```

## Строковый тип

### string
```go
var s string            // "" (нулевое значение)
s = "Hello"
s = `многострочная
строка`
```

**Структура:**
```go
type string struct {
    ptr *byte  // указатель на данные
    len int    // длина в байтах
}
```

**Нюансы:**
- Неизменяемы (immutable)
- UTF-8 encoded
- len() возвращает байты, не символы
- Индексация возвращает byte, не rune
```go
s := "Привет"
fmt.Println(len(s))           // 12 (байты, не 6 символов)
fmt.Println(s[0])             // 208 (байт, не 'П')
fmt.Println([]rune(s)[0])     // 1055 (код символа 'П')

// Итерация:
for i, r := range s {
    fmt.Printf("%d: %c\n", i, r)  // i - индекс байта, r - rune
}

// Сравнение: лексикографическое
"a" < "b"  // true
```

## Массивы

### [n]T
```go
var arr [5]int                    // [0 0 0 0 0]
arr := [3]int{1, 2, 3}
arr := [...]int{1, 2, 3}          // размер выводится автоматически
arr := [5]int{0: 10, 4: 20}       // [10 0 0 0 20]
```

**Нюансы:**
- Размер - часть типа: [3]int и [4]int - разные типы
- Значение-тип (передается копия)
- Нулевое значение: массив с нулевыми элементами
- Сравнимы (если элементы сравнимы)
```go
a := [2]int{1, 2}
b := [2]int{1, 2}
fmt.Println(a == b)  // true

var arr [3]int
fmt.Println(arr)  // [0 0 0]
```

## Слайсы

### []T
```go
var s []int                       // nil
s := []int{1, 2, 3}
s := make([]int, 5)               // len=5, cap=5
s := make([]int, 5, 10)           // len=5, cap=10
```

**Структура:**
```go
type slice struct {
    ptr *array  // указатель на массив
    len int     // длина
    cap int     // емкость
}
```

**Нюансы:**
- Нулевое значение: nil
- nil slice и пустой slice - разные вещи
- Передается по значению, но данные общие
- Не сравнимы (кроме nil)
```go
var nilSlice []int        // nil
emptySlice := []int{}     // не nil
madeSlice := make([]int, 0)  // не nil

nilSlice == nil     // true
emptySlice == nil   // false

// Сравнение:
// s1 == s2  // ошибка компиляции (кроме nil)
```

**Операции:**
```go
s := []int{1, 2, 3}
s = append(s, 4)           // добавление
s = append(s, 5, 6, 7)     // несколько элементов
s = append(s, []int{8, 9}...)  // другой слайс

s = s[1:3]                 // срез [2, 3]
s = s[:2]                  // первые 2
s = s[1:]                  // все кроме первого

copy(dst, src)             // копирование

len(s)                     // длина
cap(s)                     // емкость
```

**Важно:**
```go
// Слайсы делят базовый массив:
arr := [5]int{1, 2, 3, 4, 5}
s1 := arr[0:3]
s2 := arr[2:5]
s1[2] = 99
fmt.Println(s2[0])  // 99 (изменился общий массив)

// append может создать новый массив:
s := []int{1, 2, 3}
s2 := append(s, 4)  // s2 может указывать на новый массив
s[0] = 99
// s2[0] может быть 1 или 99 (зависит от cap)
```

## Map

### map[K]V
```go
var m map[string]int              // nil
m := map[string]int{}             // пустая map
m := make(map[string]int)
m := make(map[string]int, 100)    // с хинтом размера
```

**Нюансы:**
- Нулевое значение: nil
- nil map - только чтение, запись вызовет panic
- Ключи должны быть comparable
- Порядок итерации случайный
- Не потокобезопасна
```go
var m map[string]int  // nil
val := m["key"]       // 0 (можно читать)
m["key"] = 1          // panic!

m = make(map[string]int)
m["key"] = 1          // OK

// Проверка существования:
val, ok := m["key"]
if ok {
    fmt.Println("Найдено:", val)
}

// Удаление:
delete(m, "key")

// Нельзя использовать как ключ: slice, map, function
// map[[]int]string  // ошибка компиляции
```

## Структуры

### struct
```go
type Person struct {
    Name string
    Age  int
}

var p Person                      // {Name:"", Age:0}
p := Person{"Alice", 30}
p := Person{Name: "Alice", Age: 30}
p := Person{Name: "Alice"}        // Age: 0
```

**Нюансы:**
- Нулевое значение: структура с нулевыми полями
- Сравнимы если все поля сравнимы
- Экспортируемые поля начинаются с заглавной буквы
- Анонимные поля (встраивание)
```go
type Address struct {
    City string
}

type Person struct {
    Name string
    Address  // анонимное поле
}

p := Person{Name: "Alice", Address: Address{City: "NY"}}
fmt.Println(p.City)  // доступ к полю встроенной структуры

// Сравнение:
p1 := Person{Name: "Alice", Age: 30}
p2 := Person{Name: "Alice", Age: 30}
fmt.Println(p1 == p2)  // true (если все поля сравнимы)
```

**Теги:**
```go
type User struct {
    Name string `json:"name" db:"user_name"`
    Age  int    `json:"age,omitempty"`
}
```

## Указатели

### *T
```go
var p *int                        // nil
x := 42
p = &x                            // адрес x
fmt.Println(*p)                   // 42 (разыменование)
*p = 100                          // изменение через указатель
```

**Нюансы:**
- Нулевое значение: nil
- Нет арифметики указателей
- Автоматическое разыменование для структур
```go
type Person struct {
    Name string
}

p := &Person{Name: "Alice"}
fmt.Println(p.Name)  // автоматически (*p).Name
```

**new vs make:**
```go
// new: выделяет память, возвращает указатель
p := new(int)        // *int, значение 0
s := new([]int)      // *[]int, значение nil

// make: инициализирует slice, map, chan
s := make([]int, 5)  // []int, готов к использованию
m := make(map[string]int)
```

## Функции

### func
```go
var f func(int) int               // nil

f := func(x int) int {
    return x * 2
}

// Нулевое значение: nil
if f == nil {
    fmt.Println("функция не задана")
}
```

**Нюансы:**
- Функции - first-class граждане
- Сравнимы только с nil
- Замыкания захватывают переменные по ссылке
```go
// Замыкание:
func counter() func() int {
    i := 0
    return func() int {
        i++
        return i
    }
}

c := counter()
fmt.Println(c())  // 1
fmt.Println(c())  // 2
```

**Вариативные параметры:**
```go
func sum(nums ...int) int {
    total := 0
    for _, n := range nums {
        total += n
    }
    return total
}

sum(1, 2, 3)
```

**Множественное возвращение:**
```go
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("деление на ноль")
    }
    return a / b, nil
}

result, err := divide(10, 2)
```

**Именованные возвращаемые значения:**
```go
func split(sum int) (x, y int) {
    x = sum * 4 / 9
    y = sum - x
    return  // неявный возврат x, y
}
```

## Интерфейсы

### interface
```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

var r Reader                      // nil
```

**Структура:**
```go
type interface struct {
    type *type  // тип конкретного значения
    data *data  // указатель на данные
}
```

**Нюансы:**
- Нулевое значение: nil
- Неявная реализация (утиная типизация)
- nil интерфейс != интерфейс с nil значением
```go
var r Reader                 // nil интерфейс
var buf *bytes.Buffer        // nil указатель
r = buf                      // не nil интерфейс!

r == nil                     // false
```

**Проверка типа:**
```go
// Type assertion:
s := r.(string)              // panic если не string
s, ok := r.(string)          // безопасно

// Type switch:
switch v := r.(type) {
case string:
    fmt.Println("string:", v)
case int:
    fmt.Println("int:", v)
default:
    fmt.Println("unknown")
}
```

**Пустой интерфейс:**
```go
var any interface{}          // любой тип
any = 42
any = "hello"
any = []int{1, 2, 3}

// Go 1.18+:
var any any                  // alias для interface{}
```

## Каналы

### chan T
```go
var ch chan int               // nil
ch := make(chan int)          // небуферизованный
ch := make(chan int, 5)       // буферизованный (cap=5)
```

**Нюансы:**
- Нулевое значение: nil
- Операции с nil каналом блокируются навсегда
- Закрытие: close(ch)
- Направленные каналы
```go
ch := make(chan int)

// Отправка:
ch <- 42

// Получение:
val := <-ch
val, ok := <-ch  // ok=false если закрыт

// Закрытие:
close(ch)

// Nil канал:
var ch chan int
ch <- 1   // блокируется навсегда
<-ch      // блокируется навсегда
```

**Направленные каналы:**
```go
func send(ch chan<- int) {  // только отправка
    ch <- 42
}

func receive(ch <-chan int) {  // только получение
    val := <-ch
}
```

**Select:**
```go
select {
case val := <-ch1:
    fmt.Println("ch1:", val)
case ch2 <- 42:
    fmt.Println("отправлено в ch2")
case <-time.After(1 * time.Second):
    fmt.Println("timeout")
default:
    fmt.Println("ничего не готово")
}
```

## Специальные типы

### error
```go
type error interface {
    Error() string
}

var err error = errors.New("ошибка")
```

### context.Context
```go
ctx := context.Background()
ctx, cancel := context.WithCancel(ctx)
ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
```

## Приведение типов
```go
// Явное приведение:
var i int = 42
var f float64 = float64(i)
var u uint = uint(i)

// Не работает для string <-> []byte напрямую:
s := "hello"
b := []byte(s)     // копирование
s = string(b)      // копирование

// Небезопасное приведение:
import "unsafe"
s := "hello"
ptr := unsafe.Pointer(&s)
```

## Таблица нулевых значений

| Тип | Нулевое значение | Сравнимый | Изменяемый |
|-----|-----------------|-----------|-----------|
| bool | false | ✅ | ✅ |
| int, uint, float | 0 | ✅ | ✅ |
| string | "" | ✅ | ❌ |
| array | массив нулей | ✅* | ✅ |
| struct | нулевые поля | ✅* | ✅ |
| pointer | nil | ✅ | ✅ |
| slice | nil | ❌** | ✅ |
| map | nil | ❌** | ✅ |
| chan | nil | ✅ | ✅ |
| func | nil | ❌** | ❌ |
| interface | nil | ✅ | - |

\* - если элементы/поля сравнимы  
\*\* - сравнимы только с nil

## Размеры типов (64-bit)
```go
bool:        1 byte
int8/uint8:  1 byte
int16/uint16: 2 bytes
int32/uint32: 4 bytes
int64/uint64: 8 bytes
int/uint:    8 bytes (platform dependent)
float32:     4 bytes
float64:     8 bytes
complex64:   8 bytes
complex128:  16 bytes
string:      16 bytes (ptr + len)
slice:       24 bytes (ptr + len + cap)
map:         8 bytes (pointer)
chan:        8 bytes (pointer)
interface:   16 bytes (type + data)
pointer:     8 bytes
```
