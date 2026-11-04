# Local / client tools

Everything you use on your own machine — cloud services you open in a browser,
AI editors and CLI agents, and models you run locally and offline.

> See also: [2_server_tools.md](2_server_tools.md) for self-hosted, always-on,
> multi-user setups; [3_ai_creative_tools.md](3_ai_creative_tools.md) for image /
> video / audio generation; [4_ai_assistants_online.md](4_ai_assistants_online.md)
> for personal AI assistants; and the [README](README.md) for an overview.

Free tiers marked **[free]**; partially-free marked **[freemium]**; open-source marked **[OSS]**.

---

## 1. LLM web services

* [Claude](https://claude.ai) **[freemium]**
* [ChatGPT](https://chatgpt.com) **[freemium]**
* [Gemini](https://gemini.google.com) **[freemium]**
* [Microsoft Copilot](https://copilot.microsoft.com) **[free]** — GPT-4o, image gen, no account needed
* [Grok](https://grok.com) **[freemium]**
* [DeepSeek](https://www.deepseek.com/en) **[free]** — DeepSeek-V3/R1 chat
* [Mistral Le Chat](https://chat.mistral.ai/) **[free]** — Mistral Large, voice mode
* [HuggingFace Chat](https://huggingface.co/chat/) **[free]** — Llama, Qwen, Mistral and others, no account needed
* [Groq](https://groq.com) **[free]** — extremely fast inference on open models (Llama, Gemma, Mixtral)
* [Qwen Chat](https://chat.qwen.ai) **[free]**
* [Kimi](https://kimi.ai/) **[freemium]** — long context (1M tokens)
* [Z-ai](https://chat.z.ai) **[free]**
* [Perplexity](https://www.perplexity.ai) **[freemium]** — AI search with sources
* [Phind](https://www.phind.com/) **[free]** — AI search tuned for developers
* [Yandex Alice](https://alice.yandex.ru) **[free]**

---

## 2. AI model platforms & infrastructure

Central hubs for models, APIs, and compute. Useful when you need to discover,
compare, or run models without hosting your own server.

* [Hugging Face](https://huggingface.co/) **[freemium]** — the main hub for open models, datasets, and Spaces (hosted demos); `huggingface-cli` for downloads
* [Replicate](https://replicate.com/) **[freemium]** — run community models via API (Stable Diffusion, Llama, Whisper, etc.); pay-per-second
* [OpenRouter](https://openrouter.ai/) **[freemium]** — single OpenAI-compatible API across 200+ models; free models available
* [Together AI](https://www.together.ai/) **[freemium]** — fast inference for open models; $5 free credit at signup
* [Fireworks AI](https://fireworks.ai/) **[freemium]** — low-latency open model inference; free tier
* [Cerebras](https://inference.cerebras.ai/) **[free]** — very fast inference on Llama-3 via wafer-scale hardware
* [fal.ai](https://fal.ai/) **[freemium]** — GPU inference for image/video/audio models (FLUX, Wan Video, Whisper); free tier
* [Artificial Analysis](https://artificialanalysis.ai/) **[free]** — LLM quality / speed / price benchmarks across providers
* [LM Arena](https://lmarena.ai/leaderboard) **[free]** — crowdsourced model leaderboard (Chatbot Arena)

---

## 3. AI IDEs / editors

* [Cursor](https://www.cursor.com/) **[freemium]**
* [VS Code](https://code.visualstudio.com/) + [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat) **[freemium]** — free tier: 2k completions/mo
* [VSCodium](https://vscodium.com/) — telemetry-free VS Code build (use with any Copilot-compatible extension)
* [Zed](https://zed.dev/) **[free]** — fast Rust editor with built-in AI (free for individuals)
* [JetBrains AI Assistant / Junie](https://www.jetbrains.com/ai/) **[freemium]**
* [Google Antigravity](https://antigravity.google/) — agentic IDE by Google
* [Devin Desktop](https://devin.ai/) — formerly Windsurf, now Cognition's IDE with built-in agent management ([announcement](https://devin.ai/blog/windsurf-is-now-devin-desktop))

---

## 4. AI coding agents

Terminal agents, CLI tools, and IDE extensions that read/write code on your machine.

* [opencode](https://opencode.ai/) **[free/OSS]** — open-source terminal coding agent, model-agnostic
* [Claude Code](https://claude.com/product/claude-code) — Anthropic's agentic CLI (`npx @anthropic-ai/claude-code`)
* [Gemini CLI](https://github.com/google-gemini/gemini-cli) **[free]** — Google's open-source agent, generous free quota (`npx @google/gemini-cli`)
* [Codex CLI](https://openai.com/codex/) — OpenAI's coding agent (`npx @openai/codex`)
* [goose](https://block.github.io/goose/) **[free/OSS]** — Block's open-source extensible AI agent; works with any model via MCP
* [Aider](https://aider.chat/) **[free/OSS]** — git-aware pair-programming in the terminal; works with local models via Ollama/LM Studio
* [Plandex](https://plandex.ai/) **[free/OSS]** — AI coding engine for large multi-file tasks; self-hostable
* [Open Interpreter](https://www.openinterpreter.com/) **[free/OSS]** — natural-language agent that runs code locally
* [Continue](https://www.continue.dev/) **[free/OSS]** — open-source IDE assistant that can point at a local model
* [Cline](https://cline.bot/) / [Roo Code](https://roocode.com/) **[free/OSS]** — autonomous agents (VS Code extensions)

---

## 5. Local LLM runners / model servers

Download open models and run them; most expose an OpenAI-compatible API on
`localhost` so your editors and CLI agents can use them.

* [LM Studio](https://lmstudio.ai/) **[free]** — desktop GUI + `lms` CLI, OpenAI-compatible local server
* [Ollama](https://ollama.com/) **[free/OSS]** — simple model runner / API (`ollama run llama3`)
* [llama.cpp](https://github.com/ggml-org/llama.cpp) **[free/OSS]** — the underlying inference engine (GGUF)
* [GPT4All](https://www.nomic.ai/gpt4all) **[free]** — offline chat desktop app
* [Jan](https://jan.ai/) **[free/OSS]** — open-source offline ChatGPT alternative
* [LocalAI](https://localai.io/) **[free/OSS]** — drop-in OpenAI-compatible API (also runs on a server)

---

## 6. Local AI personal assistants

Apps that wrap a model with chat, your documents (RAG), and tools — a private
"assistant" that works without the cloud.

* [AnythingLLM](https://anythingllm.com/) **[free]** — desktop app: chat with your docs, agents, local or remote models
* [Khoj](https://khoj.dev/) **[free/OSS]** — AI second brain over your notes/docs (self-hostable, runs locally)
* [Hermes Agent](https://hermes-agent.nousresearch.com/) **[free/OSS MIT]** — Nous Research's self-hosted agent with persistent memory + learning loop, 40+ tools, desktop app, CLI/Telegram/Discord/Slack ([github](https://github.com/NousResearch/hermes-agent))
* [OpenAgent](https://www.openagentai.org/) **[free/OSS]** — single-binary self-hosted assistant, MCP + 30+ providers, dashboard on `:14000`
* [Reor](https://www.reorproject.org/) **[free/OSS]** — local AI note-taking app with built-in RAG
* [Leon](https://getleon.ai/) **[free/OSS]** — open-source personal voice/text assistant

---

## 7. Prompt engineering tools

Tools for writing, testing, analyzing, and optimizing prompts.

* [Promptessor](https://promptessor.com/prompt/new) **[free]** — prompt analysis and optimization
* [PromptPerfect](https://promptperfect.jina.ai/) **[freemium]** — AI-powered prompt optimizer for GPT, Claude, Midjourney
* [Anthropic Workbench](https://console.anthropic.com/workbench) **[freemium]** — Claude prompt playground with token counting and system prompt testing
* [OpenAI Playground](https://platform.openai.com/playground) **[freemium]** — GPT model playground with fine-grained parameter control
* [Google AI Studio](https://aistudio.google.com/) **[free]** — Gemini playground with structured prompts, grounding, and function calling
* [LangSmith](https://smith.langchain.com/) **[freemium]** — prompt tracing, evaluation, and dataset management for LLM apps
* [PromptLayer](https://promptlayer.com/) **[freemium]** — log, search, and version prompts in production
* [Agenta](https://agenta.ai/) **[free/OSS]** — open-source LLM prompt management and evaluation platform

---

## Hardware notes (for local models)

* **RAM/VRAM is the limit.** Rough guide for quantized (Q4) models: 7–8B ≈ 6–8 GB,
  13–14B ≈ 10–12 GB, 30B+ ≈ 24 GB+. CPU-only works but is slow.
* GPU acceleration: NVIDIA (CUDA) is best supported; AMD (ROCm/Vulkan) and Apple
  Silicon (Metal) also work in LM Studio / Ollama / llama.cpp.
* Prefer **GGUF** quantized models for CPU/consumer GPUs; pick the largest that
  fits with headroom for context.
