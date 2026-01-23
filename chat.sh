#!/bin/bash
# CLI Chat - Interactive terminal chat or one-shot questions
# Usage: ./chat.sh                                    (interactive mode)
#        ./chat.sh "your question here"               (one-shot mode)
# Press Ctrl+C to exit interactive mode
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

# Handle one-shot mode (with prompt argument)
if [ $# -gt 0 ]; then
    PROMPT="$*"
    echo "=== One-Shot Mode ==="
    echo "Model: $ACTIVE_MODEL"
    echo ""
    "${LLAMA_CPP_DIR}/build/bin/llama-cli" \
        --model "$MODEL_PATH" \
        --threads "$N_THREADS" \
        --ctx-size "$CONTEXT_SIZE" \
        --temp "$TEMPERATURE" \
        --top-p "$TOP_P" \
        --repeat-penalty "$REPEAT_PENALTY" \
        --prompt "$PROMPT" \
        --log-disable
    exit 0
fi

# Interactive mode
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
