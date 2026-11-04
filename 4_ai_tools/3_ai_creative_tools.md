# AI creative tools — image, video, audio, 3D

AI generation tools for visual and audio content. Not coding-specific, but
useful for DevOps docs, presentations, demos, and personal projects.

> See also: [1_local_tools.md](1_local_tools.md) for coding/LLM tools,
> [4_ai_assistants_online.md](4_ai_assistants_online.md) for personal assistants.

Free tiers marked **[free]**; open-source/self-hostable marked **[OSS]**.

---

## 1. AI image generation

### Web services (no GPU required)

* [Microsoft Designer / Image Creator](https://designer.microsoft.com/) **[free]** — DALL-E 3 via Copilot, no account needed
* [Ideogram](https://ideogram.ai/) **[freemium]** — excellent text rendering in images
* [Adobe Firefly](https://firefly.adobe.com/) **[freemium]** — commercially safe, integrated with Photoshop
* [Stable Diffusion on HuggingFace Spaces](https://huggingface.co/spaces) **[free]** — dozens of free hosted SD/FLUX spaces
* [Flux.1 on fal.ai](https://fal.ai/models/fal-ai/flux/schnell) **[freemium]** — FLUX.1 Schnell, fast and free tier
* [Recraft](https://www.recraft.ai/) **[freemium]** — vector art, icons, UI-ready images

### Local (run on your own GPU/CPU)

* [ComfyUI](https://github.com/comfyanonymous/ComfyUI) **[OSS]** — node-based workflow engine; supports SD, FLUX, SDXL, video, audio
* [Fooocus](https://github.com/lllyasviel/Fooocus) **[OSS]** — dead-simple Midjourney-style desktop app (just point it at models)
* [InvokeAI](https://github.com/invoke-ai/InvokeAI) **[OSS]** — polished desktop app + API; SDXL, FLUX, ControlNet
* [AUTOMATIC1111 / stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui) **[OSS]** — most popular SD UI, massive extension ecosystem
* [Draw Things](https://drawthings.ai/) **[free]** — macOS/iOS app with Apple Silicon GPU acceleration

### Model hubs

* [Civitai](https://civitai.com/) — community checkpoints, LoRAs, embeddings
* [HuggingFace Models](https://huggingface.co/models?pipeline_tag=text-to-image) — FLUX, SD, Kandinsky, etc.

---

## 2. AI video generation

### Web services

* [Kling](https://klingai.com/) **[freemium]** — high-quality video gen, generous daily free credits
* [Hailuo / MiniMax](https://hailuoai.video/) **[freemium]** — realistic motion, free tier
* [Runway](https://runwayml.com/) **[freemium]** — Gen-3 Alpha, professional-grade
* [Pika](https://pika.art/) **[freemium]** — easy-to-use, good for short clips
* [Sora](https://sora.com/) **[freemium]** — OpenAI's video model (ChatGPT Plus required for HD)
* [Vidu](https://www.vidu.io/) **[freemium]** — cinematic style, free tier
* [Luma Dream Machine](https://lumalabs.ai/dream-machine) **[freemium]** — smooth motion, free daily quota

### Local / open-source

* [Wan Video](https://github.com/Wan-Video/Wan2.1) **[OSS]** — Alibaba's open-weight video model (14B/1.3B); runs via ComfyUI
* [CogVideoX](https://github.com/THUDM/CogVideo) **[OSS]** — Zhipu AI's open video model
* [AnimateDiff](https://github.com/guoyww/AnimateDiff) **[OSS]** — animate SD images; integrates into ComfyUI/A1111

---

## 3. AI audio & music

### Music generation

* [Suno](https://suno.com/) **[freemium]** — full songs with vocals from a text prompt; 50 credits/day free
* [Udio](https://www.udio.com/) **[freemium]** — high-quality music gen, free tier
* [Mureka](https://mureka.ai/) **[freemium]** — music gen, free tier
* [AudioCraft](https://github.com/facebookresearch/audiocraft) **[OSS]** — Meta's open-source toolkit (MusicGen, AudioGen, MAGNeT)

### Voice / TTS

* [ElevenLabs](https://elevenlabs.io/) **[freemium]** — realistic voice cloning and TTS; 10k chars/mo free
* [Kokoro](https://github.com/hexgrad/kokoro) **[OSS]** — fast, high-quality open-source TTS; runs locally
* [Coqui TTS](https://github.com/coqui-ai/TTS) **[OSS]** — open-source multi-lingual TTS library

### Speech-to-text (STT)

* [Whisper](https://github.com/openai/whisper) **[OSS]** — OpenAI's open-source STT; excellent accuracy, runs locally
* [Faster Whisper](https://github.com/SYSTRAN/faster-whisper) **[OSS]** — optimized Whisper for CPU/GPU, significantly faster
* [Deepgram](https://deepgram.com/) **[freemium]** — production STT API, pay-per-use

---

## 4. AI image / video editing

* [Adobe Firefly](https://firefly.adobe.com/) **[freemium]** — generative fill, expand, recolor in Photoshop / standalone
* [Stable Diffusion inpainting](https://github.com/AUTOMATIC1111/stable-diffusion-webui) **[OSS]** — fill/replace regions in A1111 or ComfyUI
* [Topaz Labs](https://www.topazlabs.com/) — AI upscaling, denoising, sharpening (paid, but best-in-class)
* [upscayl](https://github.com/upscayl/upscayl) **[OSS]** — free local AI image upscaler (Real-ESRGAN)

---

## 5. AI 3D generation

* [Tripo](https://www.tripo3d.ai/) **[freemium]** — text/image → 3D mesh; free tier
* [Meshy](https://www.meshy.ai/) **[freemium]** — text/image → 3D, texturing; free tier
* [Shap-E](https://github.com/openai/shap-e) **[OSS]** — OpenAI's open text-to-3D model
