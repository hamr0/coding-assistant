#!/bin/bash
# Runtime Configuration - Edit settings here
# This file is sourced by all scripts
#
# To switch models:
#   1. Download: ./download-model.sh <model-id>
#   2. Change ACTIVE_MODEL below
#   3. Restart server/chat

# Active model (must match MODEL_ID in models.conf)
ACTIVE_MODEL="qwen2.5-coder-7b"

# Model parameters
N_THREADS=7              # Leave 1 thread for system
CONTEXT_SIZE=8192        # Context window size
TEMPERATURE=0.7          # Lower = more focused, higher = more creative
TOP_P=0.95              # Nucleus sampling
REPEAT_PENALTY=1.1      # Penalize repetition

# Server settings
SERVER_HOST="127.0.0.1"
SERVER_PORT=8080

# Paths (relative to script location)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_DIR="${SCRIPT_DIR}/models"
LLAMA_CPP_DIR="${SCRIPT_DIR}/llama.cpp"

# Get model filename from models.conf
get_model_file() {
    local model_id="$1"
    local model_file=$(grep "^${model_id}|" "${SCRIPT_DIR}/models.conf" | cut -d'|' -f3)
    echo "${model_file}"
}

# Get full model path
MODEL_FILE=$(get_model_file "$ACTIVE_MODEL")
MODEL_PATH="${MODELS_DIR}/${MODEL_FILE}"
