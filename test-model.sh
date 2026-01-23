#!/bin/bash
# Quick test script to verify model works correctly

cd "$(dirname "$0")"
source config.sh

echo "Testing model: $ACTIVE_MODEL"
echo "Model file: $MODEL_PATH"
echo ""

if [ ! -f "$MODEL_PATH" ]; then
    echo "ERROR: Model file not found!"
    exit 1
fi

echo "Running simple test with llama-cli..."
echo ""

echo "What is 2+2?" | "${LLAMA_CPP_DIR}/build/bin/llama-cli" \
    --model "$MODEL_PATH" \
    --threads 4 \
    --ctx-size 2048 \
    --temp 0.7 \
    -n 100 \
    --log-disable 2>&1 | tail -20
