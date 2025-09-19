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

3. Modules commands

```
go mod init module-name          # Initialize new module
go mod init github.com/user/repo # Initialize with repository path

go mod why -m golang.org/x/sys   # check module dependencies


# Download Dependencies
go get package-name              # Download and add dependency
go get github.com/gin-gonic/gin  # Download specific package
go get ./...                     # Download all dependencies for current module
go get -u                        # Update all dependencies to latest minor/patch
go get -u=patch                  # Update to latest patch versions only
go get package@version           # Get specific version
go get package@latest            # Get latest version
go get package@none              # Remove dependency


Module Maintenance
go mod download                  # Download modules to local cache
go mod verify                    # Verify dependencies have expected content
go mod tidy                      # Add missing and remove unused modules
go mod vendor                    # Make vendored copy of dependencies
go mod graph                     # Print module requirement graph
go mod why package-name          # Explain why package is needed


Module Information
go list -m all                   # List all modules
go list -m -versions package     # List available versions of package
go list -u -m all               # List modules with updates available
go mod edit -go=1.21            # Change Go version requirement
go mod edit -require=package@v1.2.3  # Add requirement
go mod edit -droprequire=package     # Remove requirement


Working with Versions
go get package@v1.2.3           # Get specific version
go get package@master           # Get master branch
go get package@commit-hash      # Get specific commit
go get package@>=v1.2.3         # Get version >= 1.2.3
go get package@<v2.0.0          # Get version < 2.0.0


Module Replacement
go mod edit -replace=old@v1.0.0=new@v1.0.0     # Replace module
go mod edit -replace=package=./local-package    # Replace with local path
go mod edit -dropreplace=package                # Remove replacement


Cache Management
go clean -modcache              # Remove entire module cache
go clean -cache                 # Clean build cache


Module File Operations
go mod edit -fmt                # Format go.mod file
go mod edit -print              # Print go.mod in JSON format
go mod edit -json               # Print go.mod as JSON


Environment Variables
export GOPROXY=direct           # Set proxy (direct, off, or URL)
export GOSUMDB=off              # Disable checksum database
export GOPRIVATE=*.corp.com     # Set private module patterns
export GONOPROXY=*.corp.com     # Bypass proxy for patterns
export GONOSUMDB=*.corp.com     # Skip checksum for patterns


Common Workflows
# Start new project
go mod init myproject
go get needed-packages
go mod tidy

# Update dependencies
go get -u
go mod tidy

# Clean up unused dependencies
go mod tidy

# Work with local development
go mod edit -replace=package=../local-package
go mod tidy

# Prepare for production
go mod vendor    # Optional: create vendor directory
go mod verify    # Verify integrity


Troubleshooting
go clean -modcache              # Clear module cache
go mod download                 # Re-download modules
go get -d ./...                 # Download without installing
go list -m -json all            # Debug module information
```



4. Testing
```
# check tests coverage
go test ./... -cover
```
