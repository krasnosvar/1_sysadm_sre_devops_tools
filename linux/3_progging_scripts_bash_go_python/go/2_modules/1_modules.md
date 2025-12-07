# Модули в Go

## Содержание

### Основы
- [Что такое модуль](#что-такое-модуль)
- [Что такое пакет](#что-такое-пакет)
- [Go modules vs GOPATH](#go-modules-vs-gopath)

### Основные команды
- [go mod init](#go-mod-init)
- [go mod tidy](#go-mod-tidy)
- [go get](#go-get)
- [go mod download](#go-mod-download)
- [go mod vendor](#go-mod-vendor)
- [go list](#go-list)

### Структура модуля
- [go.mod](#gomod)
- [go.sum](#gosum)
- [Структура директорий](#структура-директорий)

### Версионирование
- [Semantic Versioning](#semantic-versioning)
- [Псевдоверсии](#псевдоверсии)
- [Major версии](#major-версии)

### Кеш и хранилище
- [Где хранятся модули](#где-хранятся-модули)
- [Очистка кеша](#очистка-кеша)

### Приватные модули
- [Работа с приватными репозиториями](#работа-с-приватными-репозиториями)

---

## Что такое модуль

**Модуль** - это коллекция связанных пакетов Go, которые версионируются вместе как единое целое.

Модуль определяется файлом `go.mod` в корневой директории.
```
mymodule/
├── go.mod          # определяет модуль
├── go.sum          # контрольные суммы зависимостей
├── main.go
└── internal/
    └── helper.go
```

## Что такое пакет

**Пакет** - это директория с `.go` файлами, которые начинаются с `package <name>`.

Пакет - это единица компиляции и переиспользования кода.
```go
// file: internal/helper.go
package internal

func Help() string {
    return "помощь"
}
```

**Связь:**
- Модуль может содержать много пакетов
- Пакет принадлежит одному модулю
- Модуль - это единица версионирования
- Пакет - это единица импорта

## Go modules vs GOPATH

### GOPATH (старый подход, до Go 1.11)
```
$GOPATH/
├── src/
│   ├── github.com/user/project/
│   └── golang.org/x/tools/
├── pkg/
└── bin/
```
- Все проекты в одном месте
- Нет версионирования
- Проблемы с воспроизводимостью сборки

### Go Modules (современный подход, Go 1.11+)
```
~/projects/myapp/
├── go.mod
├── go.sum
└── main.go
```
- Проект может быть где угодно
- Версионирование зависимостей
- Воспроизводимые сборки
- Изоляция проектов

## Основные команды

### go mod init

Инициализирует новый модуль.
```bash
# Создание модуля
go mod init github.com/user/project

# Создается go.mod:
# module github.com/user/project
# 
# go 1.21
```

**Когда использовать:**
- При создании нового проекта
- При миграции с GOPATH на modules

### go mod tidy

Добавляет отсутствующие и удаляет неиспользуемые зависимости.
```bash
go mod tidy
```

**Что делает:**
- Анализирует импорты в коде
- Добавляет недостающие зависимости в `go.mod`
- Удаляет неиспользуемые зависимости
- Обновляет `go.sum`

**Когда использовать:**
- После добавления/удаления импортов
- Перед коммитом
- При синхронизации зависимостей

### go get

Добавляет, обновляет или удаляет зависимости.
```bash
# Добавить/обновить до последней версии
go get github.com/gin-gonic/gin

# Конкретная версия
go get github.com/gin-gonic/gin@v1.9.0

# Конкретный коммит
go get github.com/gin-gonic/gin@abc1234

# Обновить все зависимости
go get -u ./...

# Удалить зависимость
go get github.com/gin-gonic/gin@none
```

**Флаги:**
- `-u` - обновить до последней minor/patch версии
- `-u=patch` - обновить только patch версии
- `@latest` - последняя версия
- `@none` - удалить зависимость

### go mod download

Скачивает модули в локальный кеш.
```bash
# Скачать все зависимости
go mod download

# Скачать конкретный модуль
go mod download github.com/gin-gonic/gin
```

**Когда использовать:**
- В CI/CD для предварительной загрузки
- Для заполнения кеша

### go mod vendor

Копирует зависимости в директорию `vendor/`.
```bash
go mod vendor
```

**Результат:**
```
myproject/
├── go.mod
├── go.sum
├── vendor/
│   ├── github.com/gin-gonic/gin/
│   └── modules.txt
└── main.go
```

**Когда использовать:**
- Для хранения зависимостей в репозитории
- Для работы без доступа к интернету
- Для гарантии доступности зависимостей

**Использование vendor:**
```bash
go build -mod=vendor
```

### go list

Показывает информацию о пакетах и модулях.
```bash
# Все зависимости
go list -m all

# Доступные версии модуля
go list -m -versions github.com/gin-gonic/gin

# Информация о конкретном модуле
go list -m -json github.com/gin-gonic/gin

# Все пакеты в модуле
go list ./...
```

## Структура модуля

### go.mod

Основной файл модуля.
```go
module github.com/user/myproject

go 1.21

require (
    github.com/gin-gonic/gin v1.9.1
    github.com/lib/pq v1.10.9
)

require (
    // Косвенные зависимости (indirect)
    github.com/gin-contrib/sse v0.1.0 // indirect
    github.com/go-playground/validator/v10 v10.14.0 // indirect
)

replace (
    // Замена модуля (например, для локальной разработки)
    github.com/user/mylib => ../mylib
    
    // Замена версии
    github.com/old/module v1.0.0 => github.com/new/module v2.0.0
)

exclude (
    // Исключение конкретной версии (редко используется)
    github.com/broken/module v1.5.0
)

retract (
    // Отзыв версии (для владельцев модуля)
    v1.0.0 // баг в этой версии
)
```

**Директивы:**
- `module` - путь модуля (обязательно)
- `go` - минимальная версия Go
- `require` - зависимости
- `replace` - замена модуля/версии
- `exclude` - исключение версии
- `retract` - отзыв собственной версии

### go.sum

Контрольные суммы для верификации модулей.
```
github.com/gin-gonic/gin v1.9.1 h1:4idEAncQnU5cB7BeOkPtxjfCSye0AAm1R0RVIqJ+Jmg=
github.com/gin-gonic/gin v1.9.1/go.mod h1:hPrL7YrpYKXt5YId3A/Tnip5kqbEAP+KLuI3SUcPTeU=
```

**Формат:**
```
<module> <version> <hash-algorithm>:<hash>
<module> <version>/go.mod <hash-algorithm>:<hash>
```

**Для чего:**
- Проверка целостности модулей
- Защита от подмены зависимостей
- Воспроизводимость сборки

**Важно:**
- Коммитить в репозиторий
- Не редактировать вручную
- Обновляется автоматически

### Структура директорий
```
myproject/
├── go.mod              # определение модуля
├── go.sum              # контрольные суммы
├── main.go             # точка входа
├── README.md
│
├── internal/           # приватные пакеты (нельзя импортировать извне)
│   └── config/
│       └── config.go
│
├── pkg/                # публичные пакеты (можно импортировать)
│   └── utils/
│       └── utils.go
│
├── cmd/                # несколько исполняемых файлов
│   ├── server/
│   │   └── main.go
│   └── client/
│       └── main.go
│
├── api/                # API definitions (proto, OpenAPI)
├── web/                # веб-ресурсы
├── scripts/            # скрипты сборки
├── docs/               # документация
└── vendor/             # vendored зависимости (опционально)
```

**Правила:**
- `internal/` - пакеты доступны только внутри модуля
- `pkg/` - переиспользуемые пакеты
- `cmd/` - исполняемые приложения
- Один пакет = одна директория

## Версионирование

### Semantic Versioning

Go использует **semver**: `vMAJOR.MINOR.PATCH`
```
v1.2.3
│ │ │
│ │ └─ PATCH: исправления багов (обратно совместимые)
│ └─── MINOR: новая функциональность (обратно совместимая)
└───── MAJOR: breaking changes (несовместимые изменения)
```

**Примеры:**
```bash
v1.0.0  # первый релиз
v1.1.0  # добавлена новая функция
v1.1.1  # исправлен баг
v2.0.0  # breaking change
```

**Правила:**
- Версии начинаются с `v`
- `v0.x.x` - нестабильный API
- `v1.x.x` - стабильный API
- `v2+` требует нового import path

### Псевдоверсии

Для коммитов без тегов.
```
v0.0.0-20230101120000-abc123def456
│ │ │  │              │
│ │ │  │              └─ короткий хеш коммита
│ │ │  └──────────────── timestamp (UTC)
│ │ └───────────────────── базовая версия
│ └─────────────────────── minor
└───────────────────────── major
```

**Пример:**
```bash
go get github.com/user/repo@abc123  # коммит
# Добавится как псевдоверсия:
# github.com/user/repo v0.0.0-20230515120000-abc123def456
```

### Major версии

При breaking changes (v2+) меняется import path.

**v1:**
```go
module github.com/user/mylib

// import:
import "github.com/user/mylib"
```

**v2:**
```go
module github.com/user/mylib/v2

// import:
import "github.com/user/mylib/v2"
```

**Структура репозитория (опция 1 - major subdirectory):**
```
mylib/
├── go.mod          # module github.com/user/mylib
├── v2/
│   └── go.mod      # module github.com/user/mylib/v2
```

**Структура репозитория (опция 2 - major branch):**
```bash
# ветка v1
git checkout v1
# module github.com/user/mylib

# ветка v2
git checkout v2
# module github.com/user/mylib/v2
```

## Где хранятся модули

### Кеш модулей
```bash
$GOPATH/pkg/mod/
```

**По умолчанию:**
- Linux/Mac: `~/go/pkg/mod/`
- Windows: `%USERPROFILE%\go\pkg\mod\`

**Структура:**
```
$GOPATH/pkg/mod/
├── cache/                                    # кеш загрузок
│   └── download/
│       └── github.com/
│           └── gin-gonic/
│               └── gin/
│                   └── @v/
│                       ├── v1.9.1.zip
│                       ├── v1.9.1.mod
│                       └── v1.9.1.info
│
└── github.com/
    └── gin-gonic/
        └── gin@v1.9.1/                       # распакованный модуль
            ├── go.mod
            └── *.go
```

**Особенности:**
- Модули доступны только для чтения
- Версии изолированы друг от друга
- Переиспользуются между проектами

### Переменные окружения
```bash
# Где хранить модули
export GOPATH=$HOME/go

# Где кеш модулей (Go 1.15+)
export GOMODCACHE=$GOPATH/pkg/mod

# Прокси для загрузки модулей
export GOPROXY=https://proxy.golang.org,direct

# Проверка контрольных сумм
export GOSUMDB=sum.golang.org

# Приватные модули (не через прокси)
export GOPRIVATE=github.com/mycompany/*
```

### Очистка кеша
```bash
# Очистить весь кеш модулей
go clean -modcache

# Удалить кеш сборки
go clean -cache

# Удалить все
go clean -modcache -cache -testcache
```

**Когда очищать:**
- При проблемах с зависимостями
- При нехватке места на диске
- После изменения GOPROXY/GOPRIVATE

## Работа с приватными репозиториями

### GOPRIVATE
```bash
# Один репозиторий
export GOPRIVATE=github.com/mycompany/myrepo

# Несколько репозиториий
export GOPRIVATE=github.com/mycompany/*,gitlab.com/myorg/*

# Вся организация
export GOPRIVATE=github.com/mycompany
```

### Аутентификация Git

**SSH ключи (рекомендуется):**
```bash
# ~/.gitconfig
[url "ssh://git@github.com/"]
    insteadOf = https://github.com/
```

**Personal Access Token:**
```bash
# ~/.netrc (Linux/Mac)
machine github.com
    login <username>
    password <token>

# ~/_netrc (Windows)
```

**Git credentials:**
```bash
git config --global credential.helper store
git config --global url."https://<token>@github.com/".insteadOf "https://github.com/"
```

### Пример настройки для GitHub
```bash
# 1. Настроить GOPRIVATE
export GOPRIVATE=github.com/mycompany

# 2. Настроить SSH
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# 3. Настроить git
git config --global url."ssh://git@github.com/".insteadOf "https://github.com/"

# 4. Проверить
go get github.com/mycompany/privaterepo
```

## Полезные команды
```bash
# Показать зависимости в виде графа
go mod graph

# Объяснить, почему нужен модуль
go mod why github.com/gin-gonic/gin

# Проверить, что все зависимости доступны
go mod verify

# Обновить go.mod до текущих версий Go
go mod edit -go=1.21

# Заменить модуль на локальную версию
go mod edit -replace=github.com/user/lib=../lib

# Показать путь к модулю в кеше
go list -m -f '{{.Dir}}' github.com/gin-gonic/gin
```

## Типичные сценарии

### Создание нового проекта
```bash
mkdir myproject
cd myproject
go mod init github.com/user/myproject
touch main.go
go mod tidy
```

### Добавление зависимости
```bash
# Добавить импорт в код:
# import "github.com/gin-gonic/gin"

go mod tidy
# или
go get github.com/gin-gonic/gin
```

### Обновление зависимостей
```bash
# Обновить конкретную зависимость
go get -u github.com/gin-gonic/gin

# Обновить все зависимости
go get -u ./...

# Обновить только patch версии
go get -u=patch ./...
```

### Откат к предыдущей версии
```bash
go get github.com/gin-gonic/gin@v1.9.0
go mod tidy
```

### Работа с replace
```bash
# Для локальной разработки
go mod edit -replace=github.com/user/lib=../lib

# В go.mod появится:
# replace github.com/user/lib => ../lib
```

### Миграция с GOPATH
```bash
cd $GOPATH/src/github.com/user/project
go mod init github.com/user/project
go mod tidy
```
