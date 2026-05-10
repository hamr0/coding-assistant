# coding-assistant

<p align="center">
  <img src="https://img.shields.io/github/package-json/v/hamr0/coding-assistant?label=version&color=2a4f8c" alt="version (auto from package.json)">
  <img src="https://img.shields.io/badge/license-Apache%202.0-2a4f8c" alt="license: Apache 2.0">
</p>

A small **shell wrapper around [`llama.cpp`](https://github.com/ggerganov/llama.cpp)** for running quantized coding LLMs on your laptop. Six bash scripts and one config file. No GPU, no Docker, no Python, no orchestration framework — just `cmake`, a `.gguf` model file, and `llama.cpp`'s own `llama-cli` and `llama-server` binaries doing the work.

```bash
./setup.sh                              # One-time: clone + build llama.cpp
./download-model.sh qwen2.5-coder-7b    # Pick a model from models.conf
./chat.sh                               # Interactive terminal chat
./server.sh                             # OR: OpenAI-compatible API server
```

That's the whole thing.

## What it does

- **Builds llama.cpp from source** (CMake, Release, all cores). One-time `setup.sh`.
- **Downloads quantized models from Hugging Face** by ID, indexed in `models.conf`. Built-in: `qwen2.5-coder-7b`, `qwen2.5-coder-3b`, `deepseek-coder-6.7b`, `codellama-7b`. Add more by appending one line to `models.conf`.
- **Runs them in a terminal chat** (`chat.sh` → `llama-cli --conversation`).
- **Or exposes them on `http://127.0.0.1:8080/v1`** (`server.sh` → `llama-server`) — OpenAI-compatible, so OpenCode and any other OpenAI-API client can point at it as their base URL.
- **Switches models in one line** — `nano config.sh` and change `ACTIVE_MODEL`. No re-config in your editor / CLI tool: it always sees the same endpoint.

## What it isn't

- **Not a framework.** No agents, no tool calling, no RAG, no embeddings, no fine-tuning. If you want any of that, point another tool at the API server.
- **Not a llama.cpp replacement.** It calls the upstream `llama-cli` and `llama-server` binaries with sensible defaults. Anything `llama.cpp` doesn't support, this doesn't either.
- **Not a model converter / quantizer.** It downloads pre-quantized GGUF files from Hugging Face. To make your own, use `llama.cpp`'s `convert_hf_to_gguf.py` directly.
- **Not a GPU stack.** CPU-only by design (CMake build, no `LLAMA_CUDA` flag). Add the flag to `setup.sh` if you have CUDA — but that's a fork, not a config option.
- **Not packaged.** No Docker image, no `apt install`, no npm package. It's a clone-and-run repo.

## Quickstart

Prereqs: Linux (tested on Fedora; Debian/Ubuntu fine), `git`, `cmake`, `gcc`, `g++`. About 4 GB free RAM for a 7B Q4_K_M model and 4–8 GB disk.

```bash
sudo dnf install gcc-c++ cmake git    # Fedora/RHEL (gcc-c++ ships separately from gcc)
sudo apt install build-essential cmake git    # Debian/Ubuntu
```

```bash
git clone https://github.com/hamr0/coding-assistant.git
cd coding-assistant
./setup.sh                              # ~5 min: clone + build llama.cpp
./download-model.sh qwen2.5-coder-7b    # ~4 GB GGUF from HuggingFace
./chat.sh                               # Talk to it
```

For an OpenAI-compatible API instead of terminal chat:

```bash
./server.sh                             # Listens on 127.0.0.1:8080
```

Then point your client at `http://127.0.0.1:8080/v1` (no API key needed). [`docs/CLI_TOOLS_SETUP.md`](docs/CLI_TOOLS_SETUP.md) walks through OpenCode and Droid wiring. **Heads-up:** Droid's CLI doesn't currently work with local models — documented there.

## Configuration

Everything tunable lives in [`config.sh`](config.sh):

| Setting | Default | Notes |
|---|---|---|
| `ACTIVE_MODEL` | `qwen2.5-coder-7b` | Must match a `MODEL_ID` in `models.conf` |
| `N_THREADS` | `6` | Leave 1 thread for the system |
| `CONTEXT_SIZE` | `4096` | Increase for long sessions; costs RAM |
| `TEMPERATURE` | `0.5` | `0` = deterministic, `1.0` = creative |
| `TOP_P` | `0.95` | Nucleus sampling cap |
| `REPEAT_PENALTY` | `1.1` | Discourage loops |
| `SERVER_HOST` / `SERVER_PORT` | `127.0.0.1:8080` | Local-only by default |

Performance trade-offs (threads vs. context vs. quantization vs. memory) are in [`docs/PERFORMANCE_TUNING.md`](docs/PERFORMANCE_TUNING.md).

## Adding a model

`models.conf` is the registry — one line per model:

```
MODEL_ID|HF_REPO|FILENAME|QUANTIZATION|SIZE|CHAT_TEMPLATE
```

Example:

```
qwen2.5-coder-14b|Qwen/Qwen2.5-Coder-14B-Instruct-GGUF|qwen2.5-coder-14b-instruct-q4_k_m.gguf|Q4_K_M|8GB|chatml
```

Then `./download-model.sh qwen2.5-coder-14b`. Chat templates supported via the upstream `--chat-template` flag: `chatml`, `deepseek`, `llama2`, `mistral-v1`, etc.

## Files

| Path | Purpose |
|---|---|
| `setup.sh` | One-time `llama.cpp` clone + CMake Release build |
| `download-model.sh` | Pull a `.gguf` from Hugging Face per `models.conf` |
| `chat.sh` | Interactive terminal chat (`llama-cli`) |
| `server.sh` | OpenAI-compatible API (`llama-server`) on `127.0.0.1:8080` |
| `test-model.sh` | Sanity check a downloaded model |
| `config.sh` | Runtime knobs (sourced by every script) |
| `models.conf` | Model registry |
| `models/` | Downloaded GGUFs land here (gitignored) |
| `llama.cpp/` | Built by `setup.sh` (gitignored) |
| `docs/` | Full documentation |

## Going further

- [`docs/QUICKSTART.md`](docs/QUICKSTART.md) — cheat sheet
- [`docs/CLI_TOOLS_SETUP.md`](docs/CLI_TOOLS_SETUP.md) — OpenCode + Droid wiring (with the Droid-vs-local-models caveat)
- [`docs/SWITCHING_MODELS.md`](docs/SWITCHING_MODELS.md) — model-switch workflow
- [`docs/PERFORMANCE_TUNING.md`](docs/PERFORMANCE_TUNING.md) — threads / context / quantization trade-offs
- [`CHANGELOG.md`](CHANGELOG.md) — version history

## License

[Apache 2.0](LICENSE) with [`NOTICE`](NOTICE) preservation.
