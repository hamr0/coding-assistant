# Performance Tuning Guide

How to make your local coding assistant faster.

## Quick Performance Comparison

| Model | Quantization | Size | Speed (tokens/sec) | Quality | Best For |
|-------|--------------|------|-------------------|---------|----------|
| **qwen2.5-coder-7b** | Q4_K_M | 4GB | 5-15 | Excellent | Best quality, slower |
| **qwen2.5-coder-3b** | Q4_K_M | 2GB | 15-30 | Very Good | **Recommended** - fast & good |
| qwen2.5-coder-7b | Q3_K_M | 3GB | 8-20 | Good | Faster, lower quality |
| deepseek-coder-6.7b | Q4_K_M | 4GB | 6-16 | Excellent | Alternative to Qwen |
| codellama-7b | Q4_K_M | 4GB | 5-15 | Very Good | Good at following instructions |

Speed tested on i7-8665U (8 threads, 31GB RAM).

## Where to Adjust Parameters

All configuration is in **one file**: `config.sh`

```bash
nano ~/PycharmProjects/coding-assistant/config.sh
```

After any change, restart the server: `Ctrl+C` then `./server.sh`

## Parameter Guide

### 1. ACTIVE_MODEL (Biggest Impact)

**What it does:** Selects which model to use.

**Location:** `config.sh` line 11
```bash
ACTIVE_MODEL="qwen2.5-coder-7b"
```

**Available options:**
```bash
# Fastest (Recommended for speed)
ACTIVE_MODEL="qwen2.5-coder-3b"

# Best quality (Default)
ACTIVE_MODEL="qwen2.5-coder-7b"

# Alternative models
ACTIVE_MODEL="deepseek-coder-6.7b"
ACTIVE_MODEL="codellama-7b"
```

**To try a different model:**
```bash
# 1. Download it first
./download-model.sh qwen2.5-coder-3b

# 2. Edit config.sh
nano config.sh
# Change ACTIVE_MODEL="qwen2.5-coder-3b"

# 3. Restart
./server.sh
```

### 2. N_THREADS (CPU Usage)

**What it does:** How many CPU threads to use for generation.

**Location:** `config.sh` line 14
```bash
N_THREADS=7
```

**Options:**
```bash
N_THREADS=7   # Default - leaves 1 thread for system
N_THREADS=8   # Max - use all threads (may slow down system)
N_THREADS=6   # Conservative - keeps system more responsive
N_THREADS=4   # Light usage - for background running
```

**Rule of thumb:** Your CPU has 8 threads. Use 7 for best performance, or less if you need system responsiveness.

### 3. CONTEXT_SIZE (Memory & Speed)

**What it does:** How much conversation history the model remembers.

**Location:** `config.sh` line 15
```bash
CONTEXT_SIZE=8192
```

**Options:**
```bash
CONTEXT_SIZE=8192   # Default - full context, slower
CONTEXT_SIZE=4096   # Half - faster, still good for most tasks
CONTEXT_SIZE=2048   # Quarter - fastest, limited context
CONTEXT_SIZE=16384  # Double - very slow, only for long conversations
```

**Impact:**
- Larger = slower processing, more RAM, better long conversations
- Smaller = faster, less RAM, might forget earlier context

**Recommendation:** Start with 4096 for speed, increase if you need longer context.

### 4. TEMPERATURE (Output Randomness)

**What it does:** Controls creativity vs consistency.

**Location:** `config.sh` line 16
```bash
TEMPERATURE=0.7
```

**Options:**
```bash
TEMPERATURE=0.3   # Very focused, deterministic, slightly faster
TEMPERATURE=0.5   # Balanced, good for code
TEMPERATURE=0.7   # Default - creative, natural responses
TEMPERATURE=0.9   # More creative, less predictable
```

**Impact:** Lower = slightly faster generation, more predictable output.

**Recommendation:** Use 0.5 for coding tasks.

### 5. TOP_P (Sampling Strategy)

**What it does:** Alternative to temperature for controlling randomness.

**Location:** `config.sh` line 17
```bash
TOP_P=0.95
```

**Options:**
```bash
TOP_P=0.90   # More focused
TOP_P=0.95   # Default - balanced
TOP_P=1.00   # Maximum diversity
```

**Impact:** Minimal performance impact. Lower = more focused responses.

### 6. REPEAT_PENALTY (Avoid Repetition)

**What it does:** Penalizes repeated tokens.

**Location:** `config.sh` line 18
```bash
REPEAT_PENALTY=1.1
```

**Options:**
```bash
REPEAT_PENALTY=1.0   # No penalty (might repeat)
REPEAT_PENALTY=1.1   # Default - balanced
REPEAT_PENALTY=1.2   # Strong penalty (more diverse, might be less coherent)
```

**Impact:** Minimal performance impact.

### 7. SERVER_PORT (Network)

**What it does:** Which port the API server listens on.

**Location:** `config.sh` line 21-22
```bash
SERVER_HOST="127.0.0.1"
SERVER_PORT=8080
```

**Change if:** Port 8080 is already in use.
```bash
SERVER_PORT=8081   # Alternative port
```

## Quantization Explained

**What is quantization?** Compressing model weights to use less memory and run faster.

**Available quantizations** (from HuggingFace):

| Quantization | Size vs Original | Quality | Speed | When to Use |
|--------------|------------------|---------|-------|-------------|
| **Q4_K_M** | ~25% | Excellent | Good | **Recommended** - best balance |
| Q3_K_M | ~20% | Good | Better | When you need more speed |
| Q2_K | ~15% | Fair | Best | Only if desperate for speed |
| Q5_K_M | ~30% | Excellent+ | Slower | When quality > speed |
| Q6_K | ~40% | Near-perfect | Slowest | Max quality, slow |

**For coding:** Stick with **Q4_K_M** - it's the sweet spot.

**To try different quantization:**

### Finding Available Quantizations

1. Go to the model's HuggingFace repo (check `models.conf` for the repo name)
2. Click "Files and versions" tab
3. Look for `.gguf` files - the quantization is in the filename

**Example repos:**
- Qwen: https://huggingface.co/Qwen/Qwen2.5-Coder-7B-Instruct-GGUF/tree/main
- DeepSeek: https://huggingface.co/TheBloke/deepseek-coder-6.7b-instruct-GGUF/tree/main
- CodeLlama: https://huggingface.co/TheBloke/CodeLlama-7B-Instruct-GGUF/tree/main

**Common filenames you'll see:**
```
qwen2.5-coder-7b-instruct-q2_k.gguf      # Smallest, fastest, lowest quality
qwen2.5-coder-7b-instruct-q3_k_m.gguf    # Small, fast
qwen2.5-coder-7b-instruct-q4_k_m.gguf    # <-- Default, best balance
qwen2.5-coder-7b-instruct-q5_k_m.gguf    # Larger, better quality
qwen2.5-coder-7b-instruct-q6_k.gguf      # Large, high quality
qwen2.5-coder-7b-instruct-q8_0.gguf      # Largest, near-original quality
```

### Adding a Different Quantization

Add to `models.conf`:
```bash
qwen2.5-coder-7b-q3|Qwen/Qwen2.5-Coder-7B-Instruct-GGUF|qwen2.5-coder-7b-instruct-q3_k_m.gguf|Q3_K_M|3GB
```

Then download and switch:
```bash
./download-model.sh qwen2.5-coder-7b-q3
nano config.sh  # Change ACTIVE_MODEL
./server.sh
```

## Recommended Configurations

### Fast & Good (Recommended)

Best balance of speed and quality:

```bash
ACTIVE_MODEL="qwen2.5-coder-3b"
N_THREADS=7
CONTEXT_SIZE=4096
TEMPERATURE=0.5
```

**Expected:** 15-30 tokens/sec, good code quality.

### Maximum Quality (Slower)

When quality matters more than speed:

```bash
ACTIVE_MODEL="qwen2.5-coder-7b"
N_THREADS=7
CONTEXT_SIZE=8192
TEMPERATURE=0.7
```

**Expected:** 5-15 tokens/sec, excellent code quality.

### Speed Demon (Fastest)

Maximum speed, acceptable quality:

```bash
ACTIVE_MODEL="qwen2.5-coder-3b"
N_THREADS=8
CONTEXT_SIZE=2048
TEMPERATURE=0.3
```

**Expected:** 20-35 tokens/sec, good enough for most tasks.

### Balanced (Middle Ground)

Default configuration:

```bash
ACTIVE_MODEL="qwen2.5-coder-7b"
N_THREADS=7
CONTEXT_SIZE=4096
TEMPERATURE=0.5
```

**Expected:** 8-18 tokens/sec, very good quality.

## Step-by-Step: Try Something Different

### Example: Switch to Faster 3B Model

```bash
# 1. Stop current server (Ctrl+C if running)

# 2. Download the 3B model
cd ~/PycharmProjects/coding-assistant
./download-model.sh qwen2.5-coder-3b

# 3. Edit config
nano config.sh
# Find line: ACTIVE_MODEL="qwen2.5-coder-7b"
# Change to: ACTIVE_MODEL="qwen2.5-coder-3b"
# Save: Ctrl+O, Enter, Ctrl+X

# 4. Optionally reduce context for more speed
# Find line: CONTEXT_SIZE=8192
# Change to: CONTEXT_SIZE=4096

# 5. Restart server
./server.sh

# 6. Test in OpenCode - should be noticeably faster
```

### Example: Try DeepSeek Model

```bash
# 1. Download DeepSeek
./download-model.sh deepseek-coder-6.7b

# 2. Edit config
nano config.sh
# Change: ACTIVE_MODEL="deepseek-coder-6.7b"

# 3. Restart
./server.sh
```

### Example: Maximize Speed

```bash
# 1. Get 3B model if not already downloaded
./download-model.sh qwen2.5-coder-3b

# 2. Edit config.sh - set all these:
nano config.sh

ACTIVE_MODEL="qwen2.5-coder-3b"
N_THREADS=8
CONTEXT_SIZE=2048
TEMPERATURE=0.3

# 3. Restart
./server.sh
```

## Measuring Performance

### Check Speed

The model outputs tokens/sec at the end of each response:
```
[ Prompt: 3.5 t/s | Generation: 15.2 t/s ]
```

**What's good:**
- 5-10 t/s = Slow but usable
- 10-20 t/s = Good
- 20-30 t/s = Fast
- 30+ t/s = Very fast

### Compare Configurations

Test with the same prompt:

```bash
# In chat or via API:
"Write a Python function to reverse a string"
```

Note the generation speed and compare.

## Troubleshooting

### Still too slow after switching to 3B

1. Reduce context: `CONTEXT_SIZE=2048`
2. Use all threads: `N_THREADS=8`
3. Close other applications
4. Check CPU usage: `htop` (should be ~700% when generating)
5. Try a smaller quantization (Q3_K_M) - see [Quantization Explained](#quantization-explained)

### Model quality not good enough

1. Switch back to 7B: `ACTIVE_MODEL="qwen2.5-coder-7b"`
2. Increase context: `CONTEXT_SIZE=8192`
3. Try different model: `deepseek-coder-6.7b`

### Out of memory

1. Use smaller model: 3B instead of 7B
2. Reduce context: `CONTEXT_SIZE=2048`
3. Try a smaller quantization (Q3_K_M or Q2_K) - see [Quantization Explained](#quantization-explained)
4. Close other applications

### Responses feel "mechanical"

1. Increase temperature: `TEMPERATURE=0.7` or `0.9`
2. Increase top_p: `TOP_P=0.98`

## Quick Reference

**Config file:** `~/PycharmProjects/coding-assistant/config.sh`

**After changes:** Restart server (type `x` then Enter, then `./server.sh`)

**Download models:** `./download-model.sh <model-id>`

**List models:** `./download-model.sh`

**Check current config:** `cat config.sh`

**Test speed:** Watch the `[ Generation: X.X t/s ]` output

## Adding New Models

To add a model not in `models.conf`:

1. Find GGUF file on HuggingFace
2. Add to `models.conf`:
   ```
   MODEL_ID|HF_REPO|FILENAME|QUANTIZATION|SIZE
   ```
3. Download: `./download-model.sh MODEL_ID`
4. Edit `config.sh`: `ACTIVE_MODEL="MODEL_ID"`
5. Restart: `./server.sh`

Example - Adding Starcoder2:
```bash
# Add to models.conf:
starcoder2-7b|bigcode/starcoder2-7b-GGUF|starcoder2-7b.Q4_K_M.gguf|Q4_K_M|4GB

# Download and use:
./download-model.sh starcoder2-7b
nano config.sh  # Set ACTIVE_MODEL="starcoder2-7b"
./server.sh
```

## Summary

**For faster responses:**
1. **Switch to 3B model** (biggest impact)
2. **Reduce CONTEXT_SIZE to 4096**
3. **Use N_THREADS=8**

**For best quality:**
1. **Use 7B model**
2. **Keep CONTEXT_SIZE=8192**
3. **Use TEMPERATURE=0.7**

**The magic formula for your hardware:**
```bash
ACTIVE_MODEL="qwen2.5-coder-3b"
N_THREADS=7
CONTEXT_SIZE=4096
TEMPERATURE=0.5
```

Try it and see 2-3x speed improvement with still-excellent quality!
