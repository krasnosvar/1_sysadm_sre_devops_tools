package main

import (
	"log"
	"os"
	"runtime/pprof"
	"time"
)

// Функция, которая делает бесполезную, но интенсивную работу
func slowFunction() {
	_ = make([]int, 1000000) // Аллокация памяти
	for i := 0; i < 100000000; i++ {
		_ = i * i // Вычисление, чтобы занять CPU
	}
}

func main() {
	// 1. Сбор CPU-профиля в файл cpu.prof
	fCPU, err := os.Create("cpu.prof")
	if err != nil {
		log.Fatal(err)
	}
	defer fCPU.Close()

	if err := pprof.StartCPUProfile(fCPU); err != nil {
		log.Fatal(err)
	}
	defer pprof.StopCPUProfile()

	// Вызываем нашу "медленную" функцию
	log.Println("Запуск медленных вычислений...")
	start := time.Now()
	for i := 0; i < 5; i++ {
		slowFunction()
	}
	log.Printf("Вычисления завершены за %v\n", time.Since(start))

	// 2. Сбор профиля кучи (памяти) в файл mem.prof
	fMem, err := os.Create("mem.prof")
	if err != nil {
		log.Fatal(err)
	}
	defer fMem.Close()

	// Записываем текущее состояние кучи
	if err := pprof.Lookup("heap").WriteTo(fMem, 0); err != nil {
		log.Fatal(err)
	}
}
