# Coding Assistant

<p align="center">
  <img src="https://img.shields.io/github/package-json/v/hamr0/coding-assistant?label=version&color=2a4f8c" alt="version (auto from package.json)">
  <img src="https://img.shields.io/badge/license-Apache%202.0-2a4f8c" alt="license: Apache 2.0">
</p>

Lightweight `llama.cpp` wrapper for quantized local SLM deployment.
No GPU required.

```bash
./setup.sh                              # One-time: build llama.cpp
./download-model.sh qwen2.5-coder-7b    # Download model (~4GB)
./chat.sh                               # Chat in terminal
```

For OpenCode / Droid, run `./server.sh` to start an
OpenAI-compatible API on `http://127.0.0.1:8080/v1`.

Full documentation lives in [`docs/README.md`](docs/README.md).
Model switching, performance tuning, CLI-tool setup, quantization,
and chat templates are covered there.
