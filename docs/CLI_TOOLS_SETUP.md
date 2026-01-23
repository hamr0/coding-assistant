# CLI Tools Setup (OpenCode)

Guide to configure OpenCode to use your local llama.cpp server.

> **Note:** Droid (Factory CLI) currently doesn't support local models - see section below.

## Prerequisites

1. Complete the setup: `./setup.sh`
2. Download a model: `./download-model.sh qwen2.5-coder-7b`
3. Start the server: `./server.sh`

Keep the server running while using OpenCode.

## OpenCode Configuration

**File Location:** `~/.config/opencode/opencode.json`

Create the directory if it doesn't exist:
```bash
mkdir -p ~/.config/opencode
```

**Configuration:**
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "llamacpp": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Local Model",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "local": {
          "name": "Local Model"
        }
      }
    }
  }
}
```

**Create the file:**
```bash
cat > ~/.config/opencode/opencode.json <<'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "llamacpp": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Local Model",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "local": {
          "name": "Local Model"
        }
      }
    }
  }
}
EOF
```

**Note:** Using generic "local" model name means you never need to update this config when switching models.

## Droid CLI Configuration

> **⚠️ Known Issue:** Droid (Factory CLI) currently does not work with local models. It ignores the `base_url` and routes requests through Factory's remote servers. Use OpenCode instead for local models.

**File Location:** `~/.factory/settings.json` (managed through Droid UI)

If Factory fixes this issue in the future, add a custom model through Droid's settings with:
- Base URL: `http://127.0.0.1:8080/v1`
- Provider: `generic-chat-completion-api`
- API Key: `not-needed`

## Server Parameters (config.sh)

All server settings are in `config.sh`. Edit and restart server to apply:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `ACTIVE_MODEL` | `qwen2.5-coder-7b` | Model ID (from models.conf) |
| `N_THREADS` | `6` | CPU threads (leave 1 for system) |
| `CONTEXT_SIZE` | `4096` | Context window (higher = more memory) |
| `TEMPERATURE` | `0.5` | Creativity (0.1-1.0, lower = focused) |
| `TOP_P` | `0.95` | Nucleus sampling |
| `REPEAT_PENALTY` | `1.1` | Reduce repetition |
| `SERVER_PORT` | `8080` | API server port |

## OpenCode Configuration Details

| Setting | Value | Notes |
|---------|-------|-------|
| **Base URL** | `http://127.0.0.1:8080/v1` | Must match `SERVER_PORT` in config.sh |
| **Model Name** | `local` | Generic name - works with any model |
| **API Key** | not needed | Local server has no auth |

## Switching Models

See [SWITCHING_MODELS.md](SWITCHING_MODELS.md) for details.

Quick version:
```bash
./download-model.sh MODEL_ID        # Download
nano config.sh                       # Change ACTIVE_MODEL
./server.sh                          # Restart (type x first if running)
```

OpenCode config doesn't need to change - it uses a generic "local" model name.

## Verification

**Test server is running:**
```bash
curl http://127.0.0.1:8080/v1/models
```

Should return:
```json
{
  "object": "list",
  "data": [...]
}
```

**Test chat completion:**
```bash
curl http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Say hello"}],
    "temperature": 0.7,
    "max_tokens": 100
  }'
```

## Troubleshooting

### "Connection refused"
- Server not running: Start with `./server.sh`
- Wrong port: Check `SERVER_PORT` in `config.sh`

### Generic or wrong responses

If the model ignores your question or gives unexpected responses:

1. Check server is running: `curl http://127.0.0.1:8080/v1/models`
2. Restart server: type `x` in server terminal, then `./server.sh`
3. If using specific model name in OpenCode config, ensure it matches `ACTIVE_MODEL` in config.sh

### Stopping the Server

**Normal shutdown:** Type `x` and press Enter in the server terminal.

**If stuck:** Find and kill the process:
```bash
# Find the process
ps aux | grep llama-server

# Kill it
pkill llama-server

# Force kill if needed
pkill -9 llama-server
```

**Note:** Ctrl+C doesn't work with llama-server. Use `x` + Enter instead.

### Slow responses
- Try smaller model: `qwen2.5-coder-3b`
- Reduce `CONTEXT_SIZE` in config.sh

### Port already in use
1. Change `SERVER_PORT` in `config.sh` (e.g., to `8081`)
2. Update `baseURL` in OpenCode config
3. Restart server

## Quick Setup Command

Copy-paste to set up OpenCode:

```bash
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.json <<'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "llamacpp": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Local Model",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "local": {
          "name": "Local Model"
        }
      }
    }
  }
}
EOF
echo "OpenCode configured. Start server with: ./server.sh"
```

## Usage Workflow

1. Start server (once per session):
   ```bash
   cd ~/PycharmProjects/coding-assistant
   ./server.sh
   ```

2. Use OpenCode normally - it connects to your local model

3. Stop server when done: type `x` and Enter in server terminal

## Performance Tips

- Close other applications while using the local model
- Your hardware (i7-8665U, 7 threads) will generate 5-15 tokens/second
- First response takes 2-5 seconds to load context
- Smaller models (3B) are faster but less capable
