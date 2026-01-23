# Minimal Local Coding Assistant

Zero-bloat setup for running coding LLMs locally with llama.cpp.

## System Requirements

- **CPU**: Multi-core (8 threads recommended)
- **RAM**: 8GB+ (31GB for comfortable 7B models)
- **Disk**: 5-10GB per model
- **OS**: Linux, macOS, or WSL2
- **Tools**: git, cmake, gcc/g++, wget or curl

No GPU required - runs on CPU.

## Quick Start

```bash
# 1. One-time setup (clone and build llama.cpp)
./setup.sh

# 2. Download a model (~4GB)
./download-model.sh qwen2.5-coder-7b

# 3. Start chatting
./chat.sh
```

## Usage

### CLI Chat (Interactive)

```bash
./chat.sh
```

Interactive mode for direct terminal usage.

### CLI Chat (One-Shot)

```bash
./chat.sh "Write a Python function to reverse a string"
```

Get a single response and exit.

### API Server

```bash
./server.sh
```

Starts OpenAI-compatible API server at `http://127.0.0.1:8080`

Configure OpenCode/Droid to use:
- **API Base URL**: `http://127.0.0.1:8080/v1`
- **Model**: (leave as default or set to `llama.cpp`)

Test with curl:

```bash
curl http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Hello"}],
    "temperature": 0.7
  }'
```

## Model Management

### List Available Models

```bash
./download-model.sh
```

Shows all models defined in `models.conf`.

### Download a Model

```bash
./download-model.sh qwen2.5-coder-7b
./download-model.sh qwen2.5-coder-3b
./download-model.sh deepseek-coder-6.7b
```

### Switch Active Model

1. Download the model (if not already downloaded)
2. Edit `config.sh` and change `ACTIVE_MODEL`:
   ```bash
   ACTIVE_MODEL="qwen2.5-coder-3b"
   ```
3. Restart server or chat

### Add New Models

Edit `models.conf` and add a line:

```
MODEL_ID|HF_REPO|FILENAME|QUANTIZATION|SIZE
```

Example:

```
starcoder2-7b|bigcode/starcoder2-7b-GGUF|starcoder2-7b.Q4_K_M.gguf|Q4_K_M|4GB
```

Then download:

```bash
./download-model.sh starcoder2-7b
```

## Configuration

Edit `config.sh` to customize:

- **ACTIVE_MODEL**: Which model to use
- **N_THREADS**: CPU threads (default: 7)
- **CONTEXT_SIZE**: Context window (default: 8192)
- **TEMPERATURE**: Creativity (default: 0.7)
- **SERVER_HOST**: API server host (default: 127.0.0.1)
- **SERVER_PORT**: API server port (default: 8080)

## Performance

### Expected Performance (Your Hardware: i7-8665U, 31GB RAM)

- **Model**: Qwen2.5-Coder-7B-Instruct Q4_K_M (~4GB)
- **Speed**: 5-15 tokens/second (CPU-only)
- **Latency**: 2-5 seconds for first token
- **Context**: 8K tokens (configurable)

### Tips

- Use Q4_K_M quantization for best speed/quality balance
- Try smaller models (3B) for faster responses
- Reduce context size if running low on RAM
- Close other applications while using

## Project Structure

```
coding-assistant/
├── models.conf          # Model registry (add models here)
├── config.sh            # Runtime configuration (edit settings here)
├── setup.sh             # One-time setup script
├── download-model.sh    # Download models by name
├── server.sh            # Launch API server
├── chat.sh              # CLI chat interface
├── README.md            # This file
├── .gitignore           # Ignore models and llama.cpp
├── models/              # Downloaded GGUF files
│   └── *.gguf          # (ignored by git)
└── llama.cpp/           # Cloned and built by setup.sh
    └── (ignored by git)
```

## Troubleshooting

### "llama.cpp not built"

Run `./setup.sh` first.

### "Model not found"

Download the model:

```bash
./download-model.sh qwen2.5-coder-7b
```

### Slow performance

- Try a smaller model (3B instead of 7B)
- Reduce `N_THREADS` in `config.sh`
- Reduce `CONTEXT_SIZE` to 4096 or 2048

### Server won't start / Port in use

Change `SERVER_PORT` in `config.sh` to another port (e.g., 8081).

### Out of memory

- Use smaller models (3B)
- Close other applications
- Reduce `CONTEXT_SIZE` in `config.sh`

## Model Recommendations

| Model | Size | Best For | Speed |
|-------|------|----------|-------|
| **qwen2.5-coder-7b** | 4GB | General coding, best quality | Medium |
| **qwen2.5-coder-3b** | 2GB | Quick responses, lower RAM | Fast |
| **deepseek-coder-6.7b** | 4GB | Code completion | Medium |
| **codellama-7b** | 4GB | Instruction following | Medium |

Start with **qwen2.5-coder-7b** for best results.

## OpenCode/Droid Integration

1. Start the server:
   ```bash
   ./server.sh
   ```

2. Configure your tool:
   - **API Endpoint**: `http://127.0.0.1:8080/v1`
   - **API Key**: (leave empty or use any value)
   - **Model**: `llama.cpp` or leave as default

3. Test code completion and generation

## Design Philosophy

- **Minimal**: Shell scripts only, no bloat
- **Simple**: Easy to understand and modify
- **Flexible**: Easy to add models and change settings
- **Local**: No cloud, no tracking, no API costs
- **Fast**: Direct llama.cpp, no overhead

## Updates

To update llama.cpp:

```bash
cd llama.cpp
git pull
rm -rf build
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release -j$(nproc)
```

## License

This setup uses [llama.cpp](https://github.com/ggerganov/llama.cpp) (MIT License).
Models have their own licenses - check HuggingFace repositories.
