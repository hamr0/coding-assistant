# Local Coding Assistant

Run coding LLMs locally with llama.cpp. No GPU required.

## Quick Start

```bash
./setup.sh                              # One-time: build llama.cpp
./download-model.sh qwen2.5-coder-7b    # Download model (~4GB)
./chat.sh                               # Chat in terminal
```

## For OpenCode

```bash
./server.sh                             # Start API server
```

Then configure OpenCode to use `http://127.0.0.1:8080/v1`

See [CLI_TOOLS_SETUP.md](CLI_TOOLS_SETUP.md) for setup details.

## Switch Models

```bash
./download-model.sh                     # List available models
./download-model.sh qwen2.5-coder-3b    # Download another
nano config.sh                          # Change ACTIVE_MODEL
```

## Configuration

Edit `config.sh`:

| Setting | Default | Description |
|---------|---------|-------------|
| `ACTIVE_MODEL` | qwen2.5-coder-7b | Model to use |
| `N_THREADS` | 6 | CPU threads |
| `CONTEXT_SIZE` | 4096 | Context window |
| `TEMPERATURE` | 0.5 | Creativity (0-1) |
| `SERVER_PORT` | 8080 | API port |

## Files

| File | Purpose |
|------|---------|
| `config.sh` | Runtime settings |
| `models.conf` | Available models |
| `setup.sh` | Build llama.cpp |
| `download-model.sh` | Get models |
| `server.sh` | API server |
| `chat.sh` | Terminal chat |

## More Docs

- [QUICKSTART.md](QUICKSTART.md) - Cheat sheet
- [CLI_TOOLS_SETUP.md](CLI_TOOLS_SETUP.md) - OpenCode setup
- [SWITCHING_MODELS.md](SWITCHING_MODELS.md) - Model switching
- [PERFORMANCE_TUNING.md](PERFORMANCE_TUNING.md) - Optimization
