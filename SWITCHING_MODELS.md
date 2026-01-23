# Switching Models

## Available Models

```bash
./download-model.sh
```

## Switch Models - 3 Steps

```bash
# 1. Download (if not already downloaded)
./download-model.sh qwen2.5-coder-3b

# 2. Edit config
nano ~/PycharmProjects/coding-assistant/config.sh
# Change: ACTIVE_MODEL="qwen2.5-coder-3b"

# 3. Restart server
# Type 'x' in server terminal, then:
./server.sh
```

That's it. OpenCode/Droid configs don't need to change.

## What's Automatic

- Model file path (from models.conf)
- Chat template (from models.conf)
- OpenCode uses generic "local" name - works with any model

## Model Recommendations

| Need | Model | Why |
|------|-------|-----|
| **Speed** | qwen2.5-coder-3b | 2x faster |
| **Quality** | qwen2.5-coder-7b | Best results |

## Adding New Models

1. Find GGUF on HuggingFace
2. Add to `models.conf`:
   ```
   model-id|REPO|filename.gguf|Q4_K_M|SIZE|TEMPLATE
   ```
3. Download: `./download-model.sh model-id`
4. Switch using steps above

Common templates: `chatml`, `llama2`, `llama3`, `mistral-v1`, `deepseek`
