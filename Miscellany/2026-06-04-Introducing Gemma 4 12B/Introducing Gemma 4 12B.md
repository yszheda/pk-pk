---
title: "Introducing Gemma 4 12B: a unified, encoder-free multimodal model"
source: https://blog.google/innovation-and-ai/technology/developers-tools/introducing-gemma-4-12b/
author:
  - "[[Olivier Lacombe]]"
published: 2026-06-04
created: 2026-06-04
description: An overview of Gemma 4 12B, a model designed to bring high-performance multimodal intelligence directly to your laptop.
tags:
  - ToRead
  - ai
  - llm
  - machine-learning
  - multimodal
  - open-source
---
Today, we are introducing Gemma 4 12B, our latest model designed to bring agentic multimodal intelligence directly to laptops. Bridging the gap between our edge-friendly E4B and our more advanced 26B Mixture of Experts (MoE), Gemma 4 12B packages powerful capabilities inside a reduced memory footprint. It is also our first mid-sized model to feature native audio inputs.

Thanks to the developer community, [Gemma 4](https://blog.google/innovation-and-ai/technology/developers-tools/gemma-4/) models have now crossed 150 million downloads. You’ve built everything from [wearable robotic arms](https://www.youtube.com/watch?v=OhaIA3bYwmg) for physical assistance to [enterprise-grade AI security](https://deepmind.google/models/gemma/gemmaverse/hirundo/). We're excited to see what you build with this latest addition.

Here’s an overview of what makes Gemma 4 12B unique:

- **Novel unified architecture:** No multimodal encoders. The vision and audio inputs flow directly into the LLM backbone.
- **Advanced reasoning:** Benchmark performance nearing our 26B model, unlocking powerful multi-step reasoning and agentic workflows.
- **Laptop ready:** Small enough to run locally with just 16GB of VRAM or unified memory.
- **Open and accessible:** Released under an Apache 2.0 license with support across the developer ecosystem.
- **Drafter-ready:** Gemma 4 12B comes equipped with Multi-Token Prediction (MTP) drafters to reduce latency.

Together, these features bring advanced multimodal capabilities to everyday hardware without sacrificing speed or reasoning. Let's now take a closer look at how Gemma 4 12B achieves this.

### Run state-of-the-art agents locally

Gemma 4 12B delivers performance nearing our larger 26B MoE model on standard benchmarks, but at less than half the total memory footprint. Small enough to run locally on consumer laptops with 16GB of RAM, it unlocks powerful multimodal and agentic experiences right on your machine.

![Gemma 4 12B Benchmark](https://storage.googleapis.com/gweb-uniblog-publish-prod/images/1920x1080_xMVEyWv.width-1000.format-webp.webp)

Gemma 4 12B Benchmark

## Experience a uniquely efficient, unified architecture

What makes Gemma 4 12B stand out is its streamlined approach to processing visual and audio inputs. Traditional multimodal models typically rely on separate encoders to translate images and audio before passing those representations to the language model. Because these split encoders add latency and increase memory usage, we trained Gemma 4 12B with an encoder-free architecture to integrate audio and vision input directly.

Here is how Gemma 4 12B processes multimodal inputs natively:

- **Vision:** We replaced Gemma 4’s vision encoder with a lightweight embedding module consisting of a single matrix multiplication, positional embedding and normalizations. This allows the LLM backbone to take over visual processing.
- **Audio:** We simplified audio processing even further. We removed the audio encoder entirely and projected the raw audio signal into the same dimensional space as text tokens.

For developers who want a breakdown, head over to our companion Gemma 4 12B [Developer Guide](https://developers.googleblog.com/gemma-4-12b-the-developer-guide/).

![HoverNotes Icon](chrome-extension://fhdmbhgpabjkadpaafomaabbdckofphm/assets/icons/hover-notes-icon-white.svg)

HoverNotes Icon

![](https://www.youtube.com/watch?v=Q5a7dAREbXM)

See native audio processing in action: Watch Gemma 4 12B transcribe, format, and translate voice inputs entirely offline using the Google AI Edge Eloquent app.

## Get started today

- **Try it yourself**: Experiment with a couple of clicks in [LM Studio](https://lmstudio.ai/models/gemma-4), [Ollama](https://ollama.com/library/gemma4), [Google AI Edge Gallery App](https://developers.google.com/edge/gallery), the [Google AI Edge Eloquent](https://ai.google.dev/edge/eloquent) app and the [LiteRT-LM CLI](https://ai.google.dev/edge/litert-lm/cli)
- **Download the weights**: Download the pre-trained and instruction-tuned checkpoints directly from [Hugging Face](https://huggingface.co/collections/google/gemma-4) and [Kaggle](https://www.kaggle.com/models/google/gemma-4).
- **Integrate & learn:** Review the [developer documentation](https://ai.google.dev/gemma/docs/core) and the [quick start notebook](https://ai.google.dev/gemma/docs/capabilities/text/basic).
- **Use your favorite development tools**: Implement local inference pipelines with [Hugging Face Transformers](https://huggingface.co/google/gemma-4-12B-it), [llama.cpp](https://huggingface.co/collections/ggml-org/gemma-4), [MLX](https://huggingface.co/collections/mlx-community/gemma-4), [SGLang](https://docs.sglang.io/cookbook/autoregressive/Google/Gemma4), and [vLLM](https://docs.vllm.ai/projects/recipes/en/latest/Google/Gemma4.html), or fine-tune with efficiency using [Unsloth](https://unsloth.ai/docs/models/gemma-4).
- **Unlock Agentic Development with Gemma Skills:** To support agents to build with the latest Gemma advancements, we are releasing our official [Skills Repository](https://github.com/google-gemma/gemma-skills). This is a library of skills designed specifically to enable agents to build with Gemma models.
- **Deploy your way:** Spin up endpoints in production using Google Cloud. Deploy your way through [Gemini Enterprise Agent Platform Model Garden](https://console.cloud.google.com/agent-platform/publishers/google/model-garden/gemma4;publisherModelVersion=gemma-4-12b-it), [Cloud Run](https://codelabs.developers.google.com/codelabs/cloud-run/cloud-run-gpu-rtx-pro-6000-gemma4-vllm) and [GKE](https://docs.cloud.google.com/kubernetes-engine/docs/tutorials/serve-gemma-gpu-vllm).