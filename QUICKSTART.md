# Quick Start Cheat Sheet

**Forgot everything? Start here.**

## First Time Setup

```bash
cd ~/PycharmProjects/coding-assistant

# 1. Build llama.cpp (one-time, takes ~5 minutes)
./setup.sh

# 2. Download model (one-time, ~4GB)
./download-model.sh qwen2.5-coder-7b

# 3. Start using it
./chat.sh
```

## Daily Usage

### Chat in Terminal
```bash
./chat.sh
```

### Ask One Question
```bash
./chat.sh "Write a Python function to reverse a string"
```

### Start API Server (for OpenCode/Droid)
```bash
./server.sh
```
Then configure your IDE to use: `http://127.0.0.1:8080/v1`

## Common Tasks

### List Available Models
```bash
./download-model.sh
```

### Download Different Model
```bash
./download-model.sh qwen2.5-coder-3b  # Smaller, faster
```

### Switch Active Model
1. Open `config.sh` in any editor
2. Change this line:
   ```bash
   ACTIVE_MODEL="qwen2.5-coder-3b"
   ```
3. Save and restart chat/server

### Change Settings (threads, temperature, etc.)
Edit `config.sh` - all settings are there with comments

## Troubleshooting

### Error: "llama.cpp not built"
→ Run `./setup.sh`

### Error: "Model not found"
→ Run `./download-model.sh qwen2.5-coder-7b`

### Too slow
→ Try smaller model: `./download-model.sh qwen2.5-coder-3b`
→ Edit `config.sh`: reduce `CONTEXT_SIZE` to 4096

### Server port already in use
→ Edit `config.sh`: change `SERVER_PORT=8081`

## File Guide

- **models.conf** - Add new models here (one line per model)
- **config.sh** - Change settings here (active model, threads, etc.)
- **README.md** - Full documentation (read when you have time)

## That's It!

Really, it's just:
1. `./setup.sh` (once)
2. `./download-model.sh qwen2.5-coder-7b` (once per model)
3. `./chat.sh` or `./server.sh` (daily use)
