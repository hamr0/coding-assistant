#!/bin/bash
# CLI Chat - Interactive terminal chat with the model
# Usage: ./chat.sh
# Press Ctrl+C to exit
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

# Check if llama.cpp is built
if [ ! -f "${LLAMA_CPP_DIR}/build/bin/llama-cli" ]; then
    echo "ERROR: llama.cpp not built. Run ./setup.sh first."
    exit 1
fi

# Check if model exists
if [ ! -f "$MODEL_PATH" ]; then
    echo "ERROR: Model not found: $MODEL_PATH"
    echo ""
    echo "Download it first:"
    echo "  ./download-model.sh $ACTIVE_MODEL"
    exit 1
fi

# Interactive chat
echo "=== Coding Assistant Chat ==="
echo "Model:   $ACTIVE_MODEL"
echo "Threads: $N_THREADS"
echo "Context: $CONTEXT_SIZE"
echo ""
echo "Type your questions or code requests."
echo "Press Ctrl+C to exit."
echo ""

"${LLAMA_CPP_DIR}/build/bin/llama-cli" \
    --model "$MODEL_PATH" \
    --threads "$N_THREADS" \
    --ctx-size "$CONTEXT_SIZE" \
    --temp "$TEMPERATURE" \
    --top-p "$TOP_P" \
    --repeat-penalty "$REPEAT_PENALTY" \
    --interactive \
    --log-disable
