# Структура установки Go

## Содержание

### Основные директории
- [bin/](#bin)
- [src/](#src)
- [pkg/](#pkg)
- [api/](#api)
- [doc/](#doc)
- [lib/](#lib)
- [misc/](#misc)
- [test/](#test)

### Файлы конфигурации
- [VERSION](#version)
- [go.env](#goenv)
- [codereview.cfg](#codereviewcfg)

### Документы
- [README.md, LICENSE, PATENTS, SECURITY.md](#документы)

---

## bin/

Исполняемые файлы Go toolchain.
```bash
/usr/local/go/bin/
├── go          # основная команда Go
├── gofmt       # форматирование кода
└── godoc       # (в старых версиях) документация
```

**Что здесь:**
- `go` - главная команда (компилятор, сборщик, менеджер пакетов)
- `gofmt` - форматирование Go кода

**Использование:**
```bash
/usr/local/go/bin/go version
/usr/local/go/bin/gofmt -w main.go
```

**Обычно добавляется в PATH:**
```bash
export PATH=$PATH:/usr/local/go/bin
```

## src/

Исходный код Go toolchain и стандартной библиотеки.
```bash
/usr/local/go/src/
├── cmd/                    # исходники команд go, gofmt и т.д.
│   ├── go/                 # компилятор и toolchain
│   ├── gofmt/
│   ├── compile/            # компилятор
│   ├── link/               # линкер
│   └── ...
│
├── runtime/                # Go runtime (планировщик, GC, и т.д.)
│   ├── proc.go             # goroutine scheduler
│   ├── mgc.go              # garbage collector
│   ├── malloc.go           # аллокатор памяти
│   ├── panic.go            # panic/recover
│   └── ...
│
├── builtin/                # встроенные функции (make, len, append)
│   └── builtin.go
│
├── fmt/                    # стандартная библиотека: форматирование
├── net/                    # сеть
├── http/                   # HTTP
├── os/                     # OS интерфейсы
├── io/                     # ввод/вывод
├── encoding/               # кодирование (json, xml и т.д.)
├── database/               # database/sql
├── crypto/                 # криптография
├── testing/                # тестирование
└── ...                     # вся стандартная библиотека
```

### Ключевые поддиректории:

#### cmd/
Исходники команд Go toolchain.
```bash
cmd/
├── go/                     # главная команда go
│   ├── main.go
│   ├── build.go            # go build
│   ├── run.go              # go run
│   ├── test.go             # go test
│   └── ...
├── compile/                # компилятор Go
├── link/                   # линкер
├── asm/                    # ассемблер
├── gofmt/                  # форматирование
└── ...
```

#### runtime/
Ядро Go - runtime system.
```bash
runtime/
├── proc.go                 # планировщик goroutine (M:N scheduling)
├── mgc.go                  # garbage collector (concurrent mark-sweep)
├── malloc.go               # аллокатор памяти
├── chan.go                 # каналы
├── select.go               # select statement
├── panic.go                # panic/recover механизм
├── stack.go                # управление стеком goroutine
├── netpoll.go              # сетевой poller (epoll/kqueue)
├── signal_unix.go          # обработка сигналов
└── ...
```

**Что делает runtime:**
- Управление goroutine (планирование, контекст)
- Garbage collection
- Управление памятью (аллокация, освобождение)
- Каналы и select
- Обработка panic/recover
- Интерфейсы (динамическая диспетчеризация)
- Reflection
- Сетевой poller для async I/O

#### builtin/
Встроенные функции и типы.
```go
// builtin/builtin.go
package builtin

func append(slice []Type, elems ...Type) []Type
func copy(dst, src []Type) int
func delete(m map[Type]Type1, key Type)
func len(v Type) int
func cap(v Type) int
func make(t Type, size ...IntegerType) Type
func new(Type) *Type
func panic(v any)
func recover() any
// ...
```

**Особенность:**
- Это только документация
- Реализация в компиляторе и runtime

#### Стандартная библиотека
Весь остальной код в `src/` - это стандартная библиотека.
```bash
src/
├── fmt/                    # форматирование
├── net/http/               # HTTP клиент/сервер
├── encoding/json/          # JSON
├── database/sql/           # SQL интерфейс
├── os/                     # файловая система
├── io/                     # ввод/вывод
├── sync/                   # примитивы синхронизации
├── context/                # контексты
└── ...
```

## pkg/

Скомпилированные объектные файлы для toolchain.
```bash
/usr/local/go/pkg/
└── tool/
    └── linux_amd64/        # или другая платформа
        ├── compile         # компилятор
        ├── link            # линкер
        ├── asm             # ассемблер
        ├── cgo             # cgo tool
        └── ...
```

**Что здесь:**
- Скомпилированные инструменты для конкретной платформы
- `compile` - компилятор Go → объектные файлы
- `link` - линкер объектных файлов → исполняемый файл
- `asm` - ассемблер
- `cgo` - для интеграции с C

**Архитектура:**
```
GOOS_GOARCH/
- linux_amd64
- darwin_amd64
- windows_amd64
- linux_arm64
- ...
```

**Процесс компиляции:**
```
main.go
    ↓ (compile)
main.o (объектный файл)
    ↓ (link)
main (исполняемый файл)
```

## api/

API compatibility файлы.
```bash
/usr/local/go/api/
├── go1.txt                 # API Go 1.0
├── go1.1.txt               # изменения в Go 1.1
├── go1.2.txt
├── ...
├── go1.21.txt              # текущая версия
├── next/                   # будущие изменения
└── except.txt              # исключения
```

**Назначение:**
- Отслеживание изменений публичного API
- Проверка обратной совместимости
- Go 1 compatibility promise

**Формат:**
```
pkg encoding/json, method (*Decoder) Buffered() io.Reader
pkg net/http, type Request struct
pkg os, func Getenv(string) string
```

**Использование:**
```bash
# Проверить изменения API
go tool api -c /usr/local/go/api/go1.21.txt
```

## doc/

Документация Go.
```bash
/usr/local/go/doc/
├── go1.21.html             # release notes
├── install.html            # инструкция по установке
├── effective_go.html       # Effective Go
├── faq.html                # FAQ
├── code.html               # How to Write Go Code
├── godoc.html              # godoc документация
└── articles/               # статьи
    ├── wiki/               # пример wiki
    └── ...
```

**Ключевые документы:**
- `effective_go.html` - лучшие практики Go
- `code.html` - как организовать Go проект
- `faq.html` - часто задаваемые вопросы
- Release notes для каждой версии

**Доступ:**
```bash
# Локально
firefox /usr/local/go/doc/effective_go.html

# Онлайн
https://go.dev/doc/
```

## lib/

Библиотеки времени компиляции.
```bash
/usr/local/go/lib/
└── time/
    └── zoneinfo.zip        # база данных часовых поясов
```

**Что здесь:**
- `zoneinfo.zip` - IANA Time Zone Database
- Используется пакетом `time` для работы с временными зонами

**Использование:**
```go
loc, _ := time.LoadLocation("America/New_York")
t := time.Now().In(loc)
```

**Встроена в binary:**
- При сборке может быть встроена в исполняемый файл
- Или использоваться из системы

## misc/

Вспомогательные скрипты и конфигурации.
```bash
/usr/local/go/misc/
├── android/                # поддержка Android
├── chrome/                 # расширения для Chrome
├── cgo/                    # примеры cgo
├── git/                    # git hooks
├── ios/                    # поддержка iOS
├── wasm/                   # WebAssembly поддержка
├── swtch/                  # инструменты разработчиков
└── ...
```

**Примеры:**
- `cgo/` - примеры использования cgo
- `wasm/` - поддержка компиляции в WebAssembly
- `android/`, `ios/` - кросс-компиляция для мобильных платформ

## test/

Тесты компилятора и runtime.
```bash
/usr/local/go/test/
├── fixedbugs/              # тесты для исправленных багов
├── bench/                  # бенчмарки
├── codegen/                # тесты кодогенерации
├── run.go                  # runner для тестов
└── *.go                    # тестовые файлы
```

**Назначение:**
- Тестирование самого компилятора
- Регрессионные тесты
- Проверка оптимизаций

**Запуск:**
```bash
cd /usr/local/go/src
./run.bash  # или run.bat на Windows
```

## Файлы конфигурации

### VERSION

Версия Go.
```bash
cat /usr/local/go/VERSION
# go1.21.4
```

**Использование:**
```bash
go version
# go version go1.21.4 linux/amd64
```

### go.env

Переменные окружения по умолчанию.
```bash
cat /usr/local/go/go.env
# GO111MODULE=
# GOPROXY=https://proxy.golang.org,direct
# GOSUMDB=sum.golang.org
```

**Переопределение:**
```bash
# Глобально
go env -w GOPROXY=https://goproxy.io,direct

# Локально (для проекта)
export GOPROXY=https://goproxy.io,direct
```

### codereview.cfg

Конфигурация для code review (для разработки самого Go).
```
issuerepo: golang/go
branch: master
```

## Документы

### README.md
Основная информация о Go.

### LICENSE
BSD-style лицензия.

### PATENTS
Патентный грант от Google.

### SECURITY.md
Политика безопасности и как сообщать об уязвимостях.

### CONTRIBUTING.md
Руководство по контрибуции в Go.

## Переменные окружения

Основные переменные, связанные со структурой Go:
```bash
# Где установлен Go
GOROOT=/usr/local/go

# Рабочее пространство (модули и кеш)
GOPATH=$HOME/go

# Кеш модулей
GOMODCACHE=$GOPATH/pkg/mod

# Кеш сборки
GOCACHE=$HOME/.cache/go-build

# Архитектура
GOOS=linux
GOARCH=amd64

# Бинарники Go toolchain
PATH=$PATH:$GOROOT/bin

# Бинарники установленных программ
PATH=$PATH:$GOPATH/bin
```

**Проверка:**
```bash
go env GOROOT
go env GOPATH
go env GOCACHE
```

## Процесс компиляции
```
Исходный код (main.go)
        ↓
    [go build]
        ↓
/usr/local/go/pkg/tool/linux_amd64/compile
        ↓
main.o (объектный файл)
        ↓
/usr/local/go/pkg/tool/linux_amd64/link
        ↓
Встраивание runtime (/usr/local/go/src/runtime/)
        ↓
main (исполняемый файл)
```

**Команды:**
```bash
# Компиляция
go build main.go

# Подробный вывод
go build -x main.go

# Вывод покажет:
# /usr/local/go/pkg/tool/linux_amd64/compile -o main.o main.go
# /usr/local/go/pkg/tool/linux_amd64/link -o main main.o
```

## Runtime в исполняемом файле

Каждый Go binary содержит:
- Скомпилированный код программы
- Go runtime (из `/usr/local/go/src/runtime/`)
- Используемые части стандартной библиотеки

**Размер:**
```bash
# Простой "Hello World"
-rwxr-xr-x 1 user user 1.8M main

# Включает:
# - код программы (~10KB)
# - runtime (~1.5MB)
# - части fmt, os и т.д. (~300KB)
```

**Статическая линковка:**
- Go по умолчанию статически линкует всё
- Нет зависимостей от системных библиотек (кроме libc для cgo)

## Полезные команды
```bash
# Где установлен Go
go env GOROOT

# Версия
go version

# Все переменные окружения
go env

# Путь к инструменту compile
go env GOTOOLDIR

# Информация о сборке
go build -x main.go

# Размер секций в binary
go tool nm main | grep -i runtime

# Дизассемблировать
go tool objdump main

# Посмотреть зависимости
go list -f '{{.Deps}}' main.go
```

## Структура GOPATH (для справки)

Рабочее пространство пользователя (НЕ установка Go):
```bash
$GOPATH/                    # обычно ~/go
├── bin/                    # установленные программы (go install)
├── pkg/
│   └── mod/                # кеш модулей
│       ├── cache/          # скачанные архивы
│       └── github.com/     # распакованные модули
└── src/                    # (устарело) исходники в GOPATH режиме
```

**Разница:**
- `/usr/local/go/` - установка Go (GOROOT)
- `~/go/` - рабочее пространство пользователя (GOPATH)

## Кросс-компиляция

Go поддерживает компиляцию для разных платформ из коробки:
```bash
# Компиляция для Linux на macOS
GOOS=linux GOARCH=amd64 go build main.go

# Компиляция для Windows
GOOS=windows GOARCH=amd64 go build main.go

# Компиляция для ARM
GOOS=linux GOARCH=arm64 go build main.go

# Список поддерживаемых платформ
go tool dist list
```

**Как это работает:**
- `/usr/local/go/pkg/tool/` содержит инструменты для всех платформ
- Компилятор и линкер генерируют код для целевой платформы
- Runtime имеет platform-specific код в `src/runtime/`
