# AI Coding Agents: Ecosystem, Plugins, and Best Practices

A practical guide for working efficiently with modern agentic AI
coding assistants (such as Google Antigravity CLI / `agy`, Gemini
CLI, and Claude Code), optimizing token usage with the Model Context
Protocol (MCP), and managing infrastructure stacks (Python, Golang,
Docker, Kubernetes, AWS).

---

## 1. Essential Plugins and Customizations

Modern coding agents support plugins, skills, and extensions to
guide coding philosophy, streamline testing, and fetch real-time
documentation.

### Core Philosophy & Engineering Plugins

* **Ponytail (`DietrichGebert/ponytail`)**
  - **Philosophy:** "Lazy Senior Developer" mode. Strictly enforces
    YAGNI (You Aren't Gonna Need It), prioritizes the smallest
    working diff, and rejects premature abstractions, unnecessary
    wrappers, and speculative features.
  - **Levels:** `lite`, `full` (default), `ultra`.
  - **Bundled Skills:** `/ponytail`, `/ponytail-review`,
    `/ponytail-audit`, `/ponytail-debt`, `/ponytail-gain`.
  - **Installation:**
    ```bash
    agy plugin install https://github.com/DietrichGebert/ponytail
    ```

* **Superpowers (`obra/superpowers`)**
  - **Philosophy:** Systematic, disciplined software engineering.
  - **Features:** Rigorous Test-Driven Development (TDD) cycles,
    deep root-cause debugging workflows, and structured design
    interviews before writing any production code.
  - **Installation:**
    ```bash
    agy plugin install superpowers@antigravity-plugins-partners
    ```

* **Context7 (`context7`)**
  - **Features:** Real-time documentation and API lookup for modern
    frameworks and libraries (React, FastAPI, Gin, Tailwind, etc.).
    Prevents hallucinated or outdated methods.

* **Code Review & Standards:**
  - **`qodo`** / **`coderabbit`**: Automated deep code reviews,
    edge-case analysis, and security sanity checks before commits.
  - **`modern-web-guidance-plugin`**: Up-to-date web standards,
    accessibility (a11y), and React performance best practices.

---

## 2. Infrastructure Tooling: Python, Go, Docker, K8s, AWS

For system administration, DevOps, and backend development, combine
specialized skills with Model Context Protocol (MCP) servers:

### Kubernetes & Docker
* **Kubernetes MCP Server (`kubernetes-mcp-server`)**
  - Direct integration with local `~/.kube/config`.
  - Native tools for listing pods, inspecting events, fetching logs,
    and applying manifests.
  - Setup:
    ```bash
    agy mcp add k8s npx -y kubernetes-mcp-server@latest
    ```
* **Docker MCP Server (`@modelcontextprotocol/server-docker`)**
  - Structured management of containers, images, volumes, and
    compose stacks without manual stdout parsing.
  - Setup:
    ```bash
    agy mcp add docker npx -y @modelcontextprotocol/server-docker
    ```

### AWS Cloud
* **AWS Labs MCP Servers (`awslabs`)**
  - Official MCP tools for Amazon EKS, CloudWatch, S3, and
    CloudFormation, utilizing local `~/.aws/credentials`.
  - Setup:
    ```bash
    agy mcp add aws-eks npx -y @awslabs/eks-mcp-server
    ```

### Golang & Python Tooling
* **Python:** Fast linters (`ruff`), dependency management (`uv`),
  and automated TDD via `pytest`.
* **Golang:** Standard tooling integration (`golangci-lint`,
  `go test -race`, `go bench`) and strict adherence to idiomatic
  Go patterns (explicit error handling, proper context propagation).

---

## 3. Token Economics & The MCP Context Trap

A common question: *Do connected MCP servers consume tokens when
idle, and will querying cluster status pollute the context?*

### Idle Overhead vs. Active Usage

1. **In Idle (Lazy Loading):**
   - In modern agents like Antigravity, MCP tools use **Lazy
     Loading**.
   - Only tool names and minimal markers are passed in the initial
     system prompt. Detailed JSON parameter schemas are read from
     disk on-demand when a tool is called.
   - Idle MCP servers have negligible token overhead.

2. **The Context Bloat Trap:**
   - When you invoke a tool (e.g., `get_pods` or `describe_instances`),
     the raw output (often 5,000–15,000 tokens of verbose JSON) is
     appended to the conversation history.
   - **This entire output is re-sent on every subsequent turn** of
     the conversation, degrading model attention and consuming
     tokens.

### Strategies to Prevent Context Pollution

1. **The Subagent Pattern (Best Practice):**
   - Delegate heavy inspection tasks to an isolated subagent.
   - The subagent interacts with the MCP server, parses through
     megabytes of logs or cluster JSON, and reports back a 2-line
     summary to the parent conversation.
   - The thousands of raw tokens are discarded when the subagent
     terminates, keeping the main coding session lean and focused.

2. **Targeted CLI Filters over Raw MCP Dumps:**
   - Instead of pulling an entire cluster state through MCP, use
     concise shell commands with built-in server-side filtering:
     ```bash
     kubectl get pods -n prod --field-selector=status.phase!=Running
     aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId'
     ```
   - Returns only 3 lines of output (~30 tokens) instead of thousands.

3. **Context Compaction:**
   - Coding agents feature automated compaction as token limits
     approach.
   - Use `/compact` manually after large diagnostic steps to summarize
     history and discard bulky intermediate outputs.

4. **Dynamic Toggling:**
   - Enable infrastructure servers only when troubleshooting:
     ```bash
     agy mcp disable k8s
     agy mcp enable k8s
     ```

5. **Lifecycle Output Truncation via Hooks:**
   - Configure a `PostToolUse` lifecycle hook in `hooks.json` to
     automatically truncate terminal and tool output exceeding
     predefined line limits.

---

## 4. Best Practices for Working with AI Coding Agents

To get the most reliable output from agentic AI assistants:

### 1. The Rule of Single-Variable Iteration
* Execute one discrete sub-step at a time.
* Verify each change against working data or tests before moving
  to the next.
* Never apply multiple independent refactorings simultaneously.

### 2. Deterministic Verification over Model Hallucination
* Let code and automated tools perform calculations, validations,
  and diff checks.
* Require tests (`pytest`, `go test`) or sanity assertions after
  every non-trivial code change.

### 3. Fail-Fast Configuration
* Enforce strict, mandatory parameters in environments and scripts
  (e.g., `${VAR:?error message}`).
* Avoid silent fallbacks that hide missing configuration.

### 4. Maintain Documentation as Code
* Keep project rules, architectural decisions, and measured
  benchmarks recorded in version-controlled markdown files (such
  as `AGENTS.md` or `GEMINI.md`).
* Explicitly define line-length constraints (e.g., 70–80 chars) to
  guarantee readable diffs and terminal reviews across different
  screen configurations.
