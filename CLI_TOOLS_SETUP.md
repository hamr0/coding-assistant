# CLI Tools Setup (OpenCode & Droid)

Guide to configure OpenCode and Droid CLI tools to use your local llama.cpp server.

## Prerequisites

1. Complete the setup: `./setup.sh`
2. Download a model: `./download-model.sh qwen2.5-coder-7b`
3. Start the server: `./server.sh`

Keep the server running while using OpenCode/Droid.

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
      "name": "llama.cpp (local)",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "qwen2.5-coder-7b": {
          "name": "Qwen2.5 Coder 7B"
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
      "name": "llama.cpp (local)",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "qwen2.5-coder-7b": {
          "name": "Qwen2.5 Coder 7B"
        }
      }
    }
  }
}
EOF
```

## Droid CLI Configuration

**File Location:** `~/.config/droid/config.json`

Create the directory if it doesn't exist:
```bash
mkdir -p ~/.config/droid
```

**Configuration:**
```json
{
  "custom_models": [
    {
      "model_display_name": "Qwen2.5 Coder 7B [Local]",
      "model": "qwen2.5-coder-7b",
      "base_url": "http://127.0.0.1:8080/v1",
      "api_key": "not-needed",
      "provider": "generic-chat-completion-api",
      "max_tokens": 8000
    }
  ]
}
```

**Create the file:**
```bash
cat > ~/.config/droid/config.json <<'EOF'
{
  "custom_models": [
    {
      "model_display_name": "Qwen2.5 Coder 7B [Local]",
      "model": "qwen2.5-coder-7b",
      "base_url": "http://127.0.0.1:8080/v1",
      "api_key": "not-needed",
      "provider": "generic-chat-completion-api",
      "max_tokens": 8000
    }
  ]
}
EOF
```

## Configuration Details

| Setting | Value | Notes |
|---------|-------|-------|
| **Base URL** | `http://127.0.0.1:8080/v1` | Local server endpoint |
| **Port** | `8080` | Configured in `config.sh` |
| **Model Name** | `qwen2.5-coder-7b` | Must match `ACTIVE_MODEL` in `config.sh` |
| **Max Tokens** | `8000` | Matches `CONTEXT_SIZE=8192` |
| **API Key** | `not-needed` | Local server doesn't require auth |

## Using Different Models

If you switch models (e.g., to `qwen2.5-coder-3b`):

1. Update `config.sh`:
   ```bash
   ACTIVE_MODEL="qwen2.5-coder-3b"
   ```

2. Update OpenCode/Droid config files:
   - Change `"model": "qwen2.5-coder-3b"`
   - Change display name accordingly

3. Restart the server:
   ```bash
   ./server.sh
   ```

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

### "Model not found"
- Model name mismatch: Ensure config files use same model name as `ACTIVE_MODEL` in `config.sh`

### Slow responses
- Try smaller model: `qwen2.5-coder-3b`
- Reduce `CONTEXT_SIZE` in `config.sh`
- Reduce `max_tokens` in OpenCode/Droid config

### Port already in use
1. Change `SERVER_PORT` in `config.sh` (e.g., to `8081`)
2. Update `baseURL` in OpenCode/Droid configs
3. Restart server

## Quick Setup Commands

Copy-paste to set up both in one go:

```bash
# Create OpenCode config
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.json <<'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "llamacpp": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "llama.cpp (local)",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "qwen2.5-coder-7b": {
          "name": "Qwen2.5 Coder 7B"
        }
      }
    }
  }
}
EOF

# Create Droid config
mkdir -p ~/.config/droid
cat > ~/.config/droid/config.json <<'EOF'
{
  "custom_models": [
    {
      "model_display_name": "Qwen2.5 Coder 7B [Local]",
      "model": "qwen2.5-coder-7b",
      "base_url": "http://127.0.0.1:8080/v1",
      "api_key": "not-needed",
      "provider": "generic-chat-completion-api",
      "max_tokens": 8000
    }
  ]
}
EOF

echo "Configuration created. Start server with: ./server.sh"
```

## Usage Workflow

1. Start server (once per session):
   ```bash
   cd ~/PycharmProjects/coding-assistant
   ./server.sh
   ```

2. Use OpenCode/Droid normally - they'll connect to your local model

3. Stop server when done: `Ctrl+C`

## Performance Tips

- Close other applications while using the local model
- Your hardware (i7-8665U, 7 threads) will generate 5-15 tokens/second
- First response takes 2-5 seconds to load context
- Smaller models (3B) are faster but less capable
