# Run on a server (Docker, always-on, multi-user)

Self-hosted platforms best deployed on a server (usually via Docker/compose):
shared by a team, always available, often GPU-backed.

> See also: [1_local_tools.md](1_local_tools.md) for single-machine/offline tools,
> and the [README](README.md) for an overview.

## 1. Self-hosted chat UIs

A web frontend for your models / providers, with users, history and RAG.

* [Open WebUI](https://github.com/open-webui/open-webui) — popular self-hosted chat UI for local/remote models (Docker)
* [LibreChat](https://www.librechat.ai/) — multi-provider chat platform, multi-user, plugins (Docker/compose)

## 2. AI agent / workflow builders

Visual / low-code platforms to build, deploy and orchestrate AI agents and automations.

* [Sim](https://www.sim.ai/) — open-source visual AI agent & workflow builder, 1000+ integrations ([github](https://github.com/simstudioai/sim))
* [n8n](https://n8n.io/) — general workflow automation with AI nodes (Docker, always-on)
* [Flowise](https://flowiseai.com/) — low-code builder for LLM apps & agents
* [Dify](https://dify.ai/) — LLMOps platform: agents, RAG, prompt/eval tooling
* [Langflow](https://www.langflow.org/) — visual builder on top of LangChain
* [Activepieces](https://www.activepieces.com/) — open-source automation with AI steps

## 3. Self-hosted code completion servers

Drop-in replacements for GitHub Copilot: serve code completions to the whole
team from one box with a GPU.

* [Tabby](https://tabby.tabbyml.com/) — self-hosted AI coding assistant; VS Code / JetBrains / vim plugins, OpenAI-compatible API ([github](https://github.com/TabbyML/tabby))

## 4. Model serving & gateways

Run open models at scale, or put one API in front of many providers.

* [vLLM](https://github.com/vllm-project/vllm) — high-throughput model serving for production (GPU); OpenAI-compatible API
* [SGLang](https://github.com/sgl-project/sglang) — fast structured generation runtime; often outperforms vLLM on throughput for Llama/Qwen/Gemma
* [Ollama](https://ollama.com/) — also runs as a shared server on a box with a GPU
* [LocalAI](https://localai.io/) — OpenAI-compatible API for local models (CPU/GPU)
* [Hugging Face TGI](https://github.com/huggingface/text-generation-inference) — Text Generation Inference server
* [LiteLLM](https://www.litellm.ai/) — proxy/gateway exposing 100+ providers behind one OpenAI-compatible API
* [OpenRouter](https://openrouter.ai/) — hosted gateway alternative (not self-hosted)

## Notes

* Most of these ship a `docker compose` quickstart — clone the repo and bring it up.
* For GPU serving, install the NVIDIA Container Toolkit so containers can see the GPU.
* Put it behind a reverse proxy (Traefik/Caddy/nginx) with TLS + auth before exposing it.
