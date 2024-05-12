package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"sort"
	"time"
)

// declaring vars
var (
	// declare slices(lists)
	//blank slice for fill in ReadLines func
	adminOnDutyList = []string{}
)

type dutyDatesCalendar struct {
	Year    int
	Month   string
	WeekNum int
	WeekDay string
	Day     int
}

// struct constructor
func newDutyDatesCalendar(year int, month string, weekNum int, weekDay string, day int) *dutyDatesCalendar {
	return &dutyDatesCalendar{

		Year:    year,
		Month:   month,
		WeekNum: weekNum,
		WeekDay: weekDay,
		Day:     day,
	}
}

func checkLeapYear() int {
	var daysInYear int
	checkedYear, _, _ := time.Now().Date()
	if checkedYear%4 == 0 && checkedYear%100 != 0 || checkedYear%400 == 0 {
		// The year is a leap year
		daysInYear = 366
	} else {
		daysInYear = 365
	}
	return daysInYear
}

// readLines reads a whole file into memory
// and returns a slice of its lines.
func readLines(path string) ([]string, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var SliceFromFile []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		SliceFromFile = append(SliceFromFile, scanner.Text())
	}
	// return SliceFromFile, scanner.Err()

	// crerate slice with admins list to rearrange in next slice in duty order
	var newSliceSorted []string
	for k, v := range SliceFromFile {
		if k > 3 {
			newSliceSorted = append(newSliceSorted, v)
		}
	}

	// create slice with new order, where 0 index - admin on duty now
	for k1, v1 := range newSliceSorted {
		if v1 == SliceFromFile[1] {
			// while in go with for-loop
			// https://go.dev/tour/flowcontrol/3
			// do while loop to iterate untill newSliceSorted will fill
			for len(adminOnDutyList) < len(newSliceSorted) {
				// iterate from DutyAdmin to end
				for _, v2 := range newSliceSorted[k1:] {
					adminOnDutyList = append(adminOnDutyList, v2)
				}
				// iterate from start to DutyAdmin
				for _, v3 := range newSliceSorted[:k1] {
					adminOnDutyList = append(adminOnDutyList, v3)
				}
			}
		}
	}
	//DEBUG
	fmt.Println(adminOnDutyList)

	// можно и return и принт поставить в функции ( она при вызове сделает принт и вернет ретерн для обратотки в следующем коде)
	fmt.Println("-----------------------------------------")
	fmt.Println("Admin On Duty NOW:", adminOnDutyList[0])
	fmt.Println("-----------------------------------------")

	return adminOnDutyList, scanner.Err()
}

func main() {
	// https://www.socketloop.com/tutorials/golang-loop-each-day-of-the-current-month-example
	// get the number of days of the current month
	t := time.Now()
	p := fmt.Println
	p("Date-time now:", t)

	// create map with dayNum {struct} - 331 {2023 November 48 Monday 27}
	mapDutyDatesCalendar := make(map[int]dutyDatesCalendar)

	for dayNum := t.YearDay(); dayNum <= checkLeapYear(); dayNum++ {
		// y := 0
		y := 1
		// get weekNumber
		_, weekNum := t.ISOWeek()
		year, month, day := t.Date()
		weekDay := t.Weekday()
		// use addDate func to add 1 day
		t = t.AddDate(0, 0, int(y))
		// fill struct
		addDataVar := newDutyDatesCalendar(year, month.String(), weekNum, weekDay.String(), day)
		// fill map with day as key and struct as value
		mapDutyDatesCalendar[dayNum] = *addDataVar
	}

	// sort mapDutyDatesCalendar to iterate over it
	// https://www.geeksforgeeks.org/how-to-sort-golang-map-by-keys-or-values/
	// By default Golang prints the map with sorted keys but while iterating over a map, it follows the order of the keys appearing as it is.
	// So, to sort the keys in a  map in Golang, we can create a slice of the keys and sort it and in turn sort the slice.
	// create slice
	keys := make([]int, 0, len(mapDutyDatesCalendar))
	for k4 := range mapDutyDatesCalendar {
		keys = append(keys, k4)
	}
	// use sort pkg
	sort.Ints(keys)

	lines, err := readLines("dutyList.txt")
	if err != nil {
		log.Fatalf("readLines: %s", err)
	}
	//DEBUG
	// fmt.Println(len(lines))

	// create list with saturdays
	saturDayList := make([]int, 0)
	for _, v5 := range keys {
		if mapDutyDatesCalendar[v5].WeekDay == "Saturday" {
			saturDayList = append(saturDayList, v5)
		}
	}

	// append week.now tak kak poschitaet s 0 index in dutyList
	saturDayList = append(saturDayList, saturDayList[0]-7)
	sort.Ints(saturDayList)
	//DEBUG
	// fmt.Println(saturDayList)

	// print sorted and append to output Admins on duty
	p("DayNum|", "Year|", "Month|", "WeekNum|", "WeekDay|", "Day|", "Admin on Duty")
	p("---------------------------------------------------------------------------------")

	// https://www.reddit.com/r/golang/comments/11cotpl/iterate_over_2_arrays/
	for i, v6 := range saturDayList {
		idAdmin := lines[i%len(lines)]
		// fmt.Printf("%s, %v\n", lines[i%len(lines)], v6)
		p(v6, "  |", mapDutyDatesCalendar[v6].Year, "|", mapDutyDatesCalendar[v6].Month, "|", mapDutyDatesCalendar[v6].WeekNum, "|", mapDutyDatesCalendar[v6].WeekDay, "|", mapDutyDatesCalendar[v6].Day, "|", idAdmin)
	}
}
