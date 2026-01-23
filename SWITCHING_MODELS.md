# Switching Models

Simple guide to switch between models.

## Available Models

Run this to see all available models:
```bash
./download-model.sh
```

Output:
```
MODEL_ID                  QUANTIZATION    SIZE       TEMPLATE
qwen2.5-coder-7b          Q4_K_M          4GB        chatml
qwen2.5-coder-3b          Q4_K_M          2GB        chatml
deepseek-coder-6.7b       Q4_K_M          4GB        deepseek
codellama-7b              Q4_K_M          4GB        llama2
```

## Switch Models - 3 Steps

### Step 1: Download the model (if needed)

```bash
cd ~/PycharmProjects/coding-assistant
./download-model.sh qwen2.5-coder-3b
```

Skip if already downloaded.

### Step 2: Update configs

**Server config:**
```bash
nano config.sh
# Change line: ACTIVE_MODEL="qwen2.5-coder-3b"
```

**OpenCode config:**
```bash
nano ~/.config/opencode/opencode.json
# Change model ID to match, e.g.:
# "qwen2.5-coder-3b": { "name": "Qwen2.5 Coder 3B" }
```

### Step 3: Restart server

```bash
# In server terminal, type: x
# Then start again:
./server.sh
```

## Quick Switch Script

Copy-paste this to switch in one go:

```bash
# Set the model you want
MODEL="qwen2.5-coder-3b"
DISPLAY_NAME="Qwen2.5 Coder 3B"

cd ~/PycharmProjects/coding-assistant

# Download if needed
./download-model.sh $MODEL

# Update server config
sed -i "s/ACTIVE_MODEL=.*/ACTIVE_MODEL=\"$MODEL\"/" config.sh

# Update OpenCode config
cat > ~/.config/opencode/opencode.json <<EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "provider": {
    "llamacpp": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "llama.cpp (local)",
      "options": {
        "baseURL": "http://127.0.0.1:8080/v1"
      },
      "models": {
        "$MODEL": {
          "name": "$DISPLAY_NAME"
        }
      }
    }
  }
}
EOF

echo "Switched to $MODEL"
echo "Restart server: type x, then ./server.sh"
```

## What Happens Automatically

When you change `ACTIVE_MODEL` in config.sh:
- **Model file**: Loaded from models.conf
- **Chat template**: Loaded from models.conf (chatml, deepseek, llama2, etc.)
- **Parameters**: Use settings from config.sh (temp, threads, context)

You don't need to manually set the chat template - it's automatic per model.

## Model Recommendations

| Need | Model | Why |
|------|-------|-----|
| **Speed** | qwen2.5-coder-3b | 2x faster, smaller |
| **Quality** | qwen2.5-coder-7b | Best coding quality |
| **Alternative** | deepseek-coder-6.7b | Different style |

## Troubleshooting

### Model not found error
```bash
./download-model.sh MODEL_ID
```

### Hallucinations after switching
Check that OpenCode model ID matches config.sh ACTIVE_MODEL exactly.

### Template not working
Check `models.conf` has the correct template for your model.

## Adding New Models

1. Find GGUF file on HuggingFace
2. Add to `models.conf`:
   ```
   model-id|HF_REPO|filename.gguf|Q4_K_M|SIZE|TEMPLATE
   ```
3. Download: `./download-model.sh model-id`
4. Switch using steps above

**Common templates:**
- `chatml` - Qwen, many instruct models
- `llama2` - Llama, CodeLlama
- `llama3` - Llama 3
- `mistral-v1` - Mistral
- `deepseek` - DeepSeek v1
- `deepseek2` - DeepSeek v2
