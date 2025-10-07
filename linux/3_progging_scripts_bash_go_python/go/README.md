1. Useful Go links
[Go source code](https://cs.opensource.google/go/go)
[Uber Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md)
[collection Go code snippets, examples, and recipes](https://go-cookbook.com)


2. docs
* official documentation ( as source code)
* https://cs.opensource.google/go/go/+/refs/tags/go1.25.1:src/builtin/builtin.go
```
// rune is an alias for int32 and is equivalent to int32 in all ways. It is
// used, by convention, to distinguish character values from integer values.
type rune = int32

// any is an alias for interface{} and is equivalent to interface{} in all ways.
type any = interface{}
```

* cli local documentation commands
```
# check documentation for package "os"
go doc os


# check documentation for function "Sum256" in package "crypto/sha256" 
go doc crypto/sha256 Sum256

package sha256 // import "crypto/sha256"
func Sum256(data []byte) [Size]byte
    Sum256 returns the SHA256 checksum of the data.

```



comprehensive Go knowledge structure:
1. Go Basics

Variables & Constants
Data Types (int, string, bool, float, etc.)
Operators
Control Flow (if, switch, for)
Functions (parameters, returns, variadic, defer)
Pointers
Structs
Arrays & Slices
Maps
Interfaces
Error Handling
Packages & Imports (including _ blank identifier)
Go Modules (go.mod, go.sum, go mod tidy)
GOPATH vs Modules

2. Advanced Go Concepts

Methods (value vs pointer receivers)
Embedding & Composition
Type Assertions & Type Switches
Generics (type parameters, constraints)
Reflection
Unsafe Package
Build Tags & Conditional Compilation

3. Concurrency

Goroutines
Channels (buffered, unbuffered, directional)
Select Statement
Sync Package (Mutex, RWMutex, WaitGroup)
Context (WithTimeout, WithCancel, WithDeadline)
Race Conditions & Data Races
Atomic Operations
Worker Pools
Pipeline Patterns

4. Error Handling & Panic

Error Interface
Custom Errors
Error Wrapping (fmt.Errorf with %w)
errors.Is() & errors.As()
Panic & Recover
Best Practices for Error Handling

5. Testing

Unit Testing (testing package)
Table-Driven Tests
Subtests (t.Run)
Test Coverage (go test -cover)
Benchmarking
Example Tests
Testing with Mocks
Testify Package
Integration Testing
Test Fixtures & Setup/Teardown

6. Database

database/sql Package
Connection Pooling
Prepared Statements
Transactions
PostgreSQL (lib/pq, pgx)
SQLite (mattn/go-sqlite3, modernc.org/sqlite)
MongoDB (mongo-go-driver)
MySQL (go-sql-driver/mysql)
ORMs (GORM, sqlx, ent)
Migrations
Context with Database Operations

7. Web & HTTP

net/http Package
HTTP Handlers & HandlerFunc
ServeMux & Routing
Middleware Pattern
Request & Response
HTTP Methods (GET, POST, PUT, DELETE)
Query Parameters & Path Variables
JSON Encoding/Decoding
Form Data & File Uploads
Cookies & Sessions
CORS
HTTP Client (timeouts, custom transport)
Web Frameworks (Gin, Echo, Fiber, Chi)

8. REST API Development

RESTful Principles
API Versioning
Request Validation
Response Formatting
Status Codes
Authentication (JWT, OAuth2)
Authorization & Permissions
Rate Limiting
API Documentation (Swagger/OpenAPI)
Logging & Monitoring

9. Working with Data

JSON (encoding/json, custom marshaling)
XML
YAML
CSV (encoding/csv)
Protocol Buffers
MessagePack
Data Validation
Struct Tags

10. File & I/O Operations

Reading & Writing Files (os, io, ioutil)
Bufio Package
File Permissions
Directory Operations
Path & Filepath
Temporary Files
Embedding Files (embed package)
Streaming Large Files

11. Networking

TCP/UDP Sockets
net Package
HTTP/2 & HTTP/3
WebSockets
gRPC
Network Timeouts
Keep-Alive Connections

12. Security

crypto Package (hashing, encryption)
TLS/SSL
Password Hashing (bcrypt)
Input Sanitization
SQL Injection Prevention
XSS & CSRF Protection
Secure Headers
Secrets Management

13. Performance & Optimization

Profiling (pprof)
Memory Management
Garbage Collection
Benchmarking
Performance Tuning
Caching Strategies
Connection Pooling

14. Logging & Monitoring

log Package
Structured Logging (zap, zerolog, logrus)
Log Levels
Error Tracking (Sentry, Rollbar)
Metrics (Prometheus)
Tracing (OpenTelemetry, Jaeger)
Health Checks

15. Dependency Management

go get & go install
go mod vendor
Private Modules
Module Proxy
go.work (workspaces)
Semantic Versioning

16. Build & Deployment

go build & go install
Cross-Compilation (GOOS, GOARCH)
Build Tags
Linker Flags (-ldflags)
Reducing Binary Size
Docker & Containers
CI/CD Integration
Environment Variables

17. CLI Development

flag Package
cobra Package
urfave/cli
Terminal UI (bubbletea, termui)
Command-Line Parsing
Configuration Files

18. Time & Date

time Package
Parsing & Formatting
Timezones
Durations & Timeouts
Tickers & Timers
Time Comparisons

19. Standard Library Essentials

strings & strconv
fmt (formatting, printing)
regexp (regular expressions)
sort Package
math Package
encoding/base64
compress (gzip, zlib)
archive (tar, zip)
html/template & text/template

20. Design Patterns in Go

Singleton
Factory
Builder
Strategy
Observer
Dependency Injection
Repository Pattern
Service Layer Pattern

21. Best Practices & Idioms

Code Organization
Project Structure
Naming Conventions
Error Handling Patterns
Interface Design
Composition over Inheritance
Effective Go Guidelines
Code Comments & Documentation

22. Tools & Ecosystem

go fmt & gofmt
go vet
golint & golangci-lint
go doc & godoc
delve (debugger)
gopls (language server)
go generate
Air (live reload)

23. Advanced Topics

Assembly in Go
CGO (C interop)
Plugins
Syscalls
Memory-Mapped Files
Signal Handling
Process Management

24. Real-World Projects

Microservices Architecture
Message Queues (RabbitMQ, Kafka)
Caching (Redis, Memcached)
Background Jobs & Workers
API Gateway
Service Mesh
Event-Driven Architecture

25. Go Under the Hood - Runtime & Internals
Go Runtime

What is the Go Runtime?
Runtime vs Standard Library
runtime Package Overview
Runtime Initialization Process
GOMAXPROCS - Managing CPU Cores
Runtime Statistics (runtime.MemStats)
Forcing Garbage Collection (runtime.GC())
Stack Management
runtime.Caller() & Stack Traces

Go Scheduler (GMP Model)

G (Goroutine) - Lightweight threads
M (Machine/OS Thread) - OS-level threads
P (Processor) - Logical processor/context
How Goroutines are Scheduled
Work Stealing Algorithm
Preemptive Scheduling
Cooperative vs Preemptive Scheduling
Syscall Handling & Blocking Operations
Network Poller Integration
GOMAXPROCS Impact on Scheduling
Goroutine States (running, runnable, waiting)
Local Run Queues vs Global Run Queue

Memory Management

Stack vs Heap Allocation
Escape Analysis
How Go Decides Stack vs Heap
Stack Growth (contiguous stacks)
Memory Allocator (tcmalloc-based)
Span & Size Classes
Memory Arena
new() vs make()
Zero Values

Garbage Collection (GC)

Tri-Color Mark & Sweep Algorithm
Concurrent GC
Write Barriers
GC Phases (mark setup, marking, mark termination, sweep)
GC Pacer & Trigger
GC Tuning (GOGC environment variable)
GC Trace Analysis
Reducing GC Pressure
Object Pooling (sync.Pool)
Finalizers (runtime.SetFinalizer)

Channels Internals

Channel Data Structure (hchan)
Buffered vs Unbuffered Implementation
Send & Receive Operations
Channel Blocking & Parking Goroutines
Select Statement Implementation
Channel Closing Mechanics
Memory Layout of Channels

Interface Internals

Interface Data Structure (iface, eface)
Type & Value Pointers
Method Dispatch (vtable)
Type Assertions Implementation
Interface vs Concrete Type Performance
Empty Interface (interface{} / any)
Dynamic Dispatch Cost

Slice Internals

Slice Header Structure (ptr, len, cap)
Backing Array
Slice Growth Strategy
Copy-on-Write Behavior
Slice Memory Leaks
Slice vs Array Performance
append() Implementation

Map Internals

Hash Map Implementation
Bucket Structure
Load Factor & Rehashing
Map Growth Strategy
Hash Function
Collision Handling
Map Iteration Order (randomized)
Map Memory Layout
Concurrent Map Access Issues

String Internals

String Immutability
String Header (ptr, len)
String Interning
String Concatenation Performance
strings.Builder vs += vs fmt.Sprintf
Rune vs Byte
UTF-8 Encoding

Defer, Panic, Recover Internals

Defer Chain Implementation
Defer Performance Cost
Panic/Recover Stack Unwinding
Defer in Loops (gotcha)

Compilation & Linking

Go Compiler Phases
AST (Abstract Syntax Tree)
SSA (Static Single Assignment)
Compiler Optimizations

Inlining
Dead Code Elimination
Bounds Check Elimination
Escape Analysis


Assembly Output (go build -gcflags="-S")
Object Files & Linking
Static vs Dynamic Linking
Build Cache

Type System Internals

Type Identity
Type Representation
reflect Package Internals
Type Metadata
Method Sets

Profiling & Diagnostics

CPU Profiling
Memory Profiling (heap, allocs)
Block Profiling
Mutex Profiling
Goroutine Profiling
Trace Analysis (go tool trace)
pprof Tool
Reading Flame Graphs
Execution Tracer

Runtime Debugging

GODEBUG Environment Variable
gctrace - GC Tracing
schedtrace - Scheduler Tracing
Race Detector Implementation (-race)
Memory Sanitizer
Building Go from Source
Runtime Hacker's Guide

Performance Implications

Function Call Overhead
Inlining Decisions
Pointer vs Value Semantics
Cache Locality
False Sharing
Memory Alignment
Struct Padding
Hot Path Optimization

Advanced Runtime Topics

Signal Handling in Go
Cgo Performance Impact
Go Assembly (Plan 9 syntax)
Writing Assembly in Go
Compiler Directives (//go:)

//go:noinline
//go:nosplit
//go:linkname


Runtime Locks & Atomics
M:N Threading Model
OS Thread Limits

Tools for Understanding Internals

go build -gcflags="-m" - Escape Analysis
go tool compile -S - Assembly Output
go tool objdump - Disassemble Binary
go tool nm - Symbol Table
go tool pprof - Profiling
go tool trace - Execution Trace
dlv (Delve Debugger)

Reading Material & Resources

Go Runtime Source Code (runtime/ package)
Go Internal Documentation
GopherCon Talks on Internals
"Go Under the Hood" Book
Compiler & Runtime Papers
