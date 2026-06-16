# Local / client tools

Everything you use on your own machine — cloud services you open in a browser,
AI editors and CLI agents, and models you run locally and offline.

> See also: [2_server_tools.md](2_server_tools.md) for self-hosted, always-on,
> multi-user setups, and the [README](README.md) for an overview.

## 1. LLM web services

* [Gemini](https://gemini.google.com)
* [Claude](https://claude.ai)
* [ChatGPT](https://chatgpt.com)
* [Perplexity](https://www.perplexity.ai) — AI search
* [Microsoft Copilot](https://copilot.microsoft.com)
* [DeepSeek](https://www.deepseek.com/en)
* [Qwen Chat](https://chat.qwen.ai)
* [Mistral Le Chat](https://mistral.ai/)
* [Grok](https://grok.com)
* [Yandex Alice](https://alice.yandex.ru)
* [Prompt Analysis and Optimization](https://promptessor.com/prompt/new)

## 2. AI IDEs / editors

* [Cursor](https://www.cursor.com/)
* [Google Antigravity](https://antigravity.google/) — agentic IDE
* [Devin Desktop](https://devin.ai/) — formerly Windsurf, now Cognition's IDE with built-in agent management ([announcement](https://devin.ai/blog/windsurf-is-now-devin-desktop))
* [VS Code](https://code.visualstudio.com/) + [GitHub Copilot / copilot-chat](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat)
* [VSCodium](https://vscodium.com/) — telemetry-free VS Code build
* [Zed](https://zed.dev/) — fast Rust editor with built-in AI
* [JetBrains AI Assistant / Junie](https://www.jetbrains.com/ai/)

## 3. CLI / terminal AI coding agents

* [opencode](https://opencode.ai/) — open-source terminal coding agent, model-agnostic
* [Claude Code](https://claude.com/product/claude-code) — Anthropic's agentic CLI (`npx @anthropic-ai/claude-code`)
* [Codex CLI](https://openai.com/codex/) — OpenAI's coding agent (`npx @openai/codex`)
* [Gemini CLI](https://github.com/google-gemini/gemini-cli) — Google's open-source agent (`npx @google/gemini-cli`)
* [Warp](https://www.warp.dev/) — AI-native terminal with agent mode
* [Aider](https://aider.chat/) — git-aware pair-programming in the terminal
* [Cline](https://cline.bot/) / [Roo Code](https://roocode.com/) — autonomous agents (VS Code extensions)

## 4. Local LLM runners / model servers

Download open models and run them; most expose an OpenAI-compatible API on
`localhost` so your editors and CLI agents can use them.

* [LM Studio](https://lmstudio.ai/) — desktop GUI + `lms` CLI, OpenAI-compatible local server
* [Ollama](https://ollama.com/) — simple model runner / API (`ollama run llama3`)
* [llama.cpp](https://github.com/ggml-org/llama.cpp) — the underlying inference engine (GGUF)
* [GPT4All](https://www.nomic.ai/gpt4all) — offline chat desktop app
* [Jan](https://jan.ai/) — open-source offline ChatGPT alternative
* [LocalAI](https://localai.io/) — drop-in OpenAI-compatible API (also runs on a server)

## 5. Local AI personal assistants

Apps that wrap a model with chat, your documents (RAG), and tools — a private
"assistant" that works without the cloud.

* [OpenAgent](https://www.openagentai.org/) — single-binary self-hosted assistant, MCP + 30+ providers, dashboard on `:14000` (runs on a PC or a server)
* [Hermes Agent](https://hermes-agent.nousresearch.com/) — Nous Research's open-source (MIT) self-hosted agent with persistent memory + learning loop, 40+ tools, desktop app, CLI/Telegram/Discord/Slack ([github](https://github.com/NousResearch/hermes-agent))

* [AnythingLLM](https://anythingllm.com/) — desktop app: chat with your docs, agents, local or remote models
* [Khoj](https://khoj.dev/) — AI second brain over your notes/docs (self-hostable, runs locally)
* [Leon](https://getleon.ai/) — open-source personal voice/text assistant
* [Reor](https://www.reorproject.org/) — local AI note-taking app with built-in RAG

## 6. Local coding agents

Agents that read/run code directly on your machine, optionally against a local model.

* [Open Interpreter](https://www.openinterpreter.com/) — natural-language agent that runs code locally
* [Aider](https://aider.chat/) — terminal pair-programmer; works with local models via Ollama/LM Studio
* [Continue](https://www.continue.dev/) — open-source IDE assistant that can point at a local model

## Hardware notes (for local models)

* **RAM/VRAM is the limit.** Rough guide for quantized (Q4) models: 7–8B ≈ 6–8 GB,
  13–14B ≈ 10–12 GB, 30B+ ≈ 24 GB+. CPU-only works but is slow.
* GPU acceleration: NVIDIA (CUDA) is best supported; AMD (ROCm/Vulkan) and Apple
  Silicon (Metal) also work in LM Studio / Ollama / llama.cpp.
* Prefer **GGUF** quantized models for CPU/consumer GPUs; pick the largest that
  fits with headroom for context.
