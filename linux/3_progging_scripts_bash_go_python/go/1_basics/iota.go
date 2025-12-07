// iota идентификатор Go используется в объявлениях констант для упрощения определений увеличивающихся чисел.
// Сделаем дни недели с использованием iota - теперь это выглядит проще (особенно если много данных):

const (
	Sunday = iota
	Monday
	Tuesday
	Wednesday
	Thursday
	Friday
	Saturday
)

func main() {
	fmt.Println(Sunday)   // вывод 0
	fmt.Println(Saturday) // вывод 6
}
