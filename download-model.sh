#!/bin/bash
# Model Downloader - Download GGUF models from HuggingFace
# Usage: ./download-model.sh <model-id>
# List available models: ./download-model.sh
# Example: ./download-model.sh qwen2.5-coder-7b
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

# Usage
if [ $# -eq 0 ]; then
    echo "Usage: $0 <model-id>"
    echo ""
    echo "Available models:"
    echo ""
    printf "%-22s %-10s %-8s %-12s %s\n" "MODEL_ID" "QUANT" "SIZE" "TEMPLATE" "REPO"
    printf "%-22s %-10s %-8s %-12s %s\n" "--------" "-----" "----" "--------" "----"
    while IFS='|' read -r model_id repo filename quant size template; do
        if [[ ! "$model_id" =~ ^# ]] && [ -n "$model_id" ]; then
            printf "%-22s %-10s %-8s %-12s %s\n" "$model_id" "$quant" "$size" "$template" "$repo"
        fi
    done < "${SCRIPT_DIR}/models.conf"
    echo ""
    echo "Example: $0 qwen2.5-coder-7b"
    echo ""
    echo "See SWITCHING_MODELS.md for how to switch between models."
    exit 0
fi

MODEL_ID="$1"

# Parse models.conf
MODEL_LINE=$(grep "^${MODEL_ID}|" "${SCRIPT_DIR}/models.conf" || true)
if [ -z "$MODEL_LINE" ]; then
    echo "ERROR: Model '$MODEL_ID' not found in models.conf"
    echo "Run '$0' without arguments to see available models"
    exit 1
fi

IFS='|' read -r model_id hf_repo filename quant size <<< "$MODEL_LINE"

echo "=== Downloading Model ==="
echo "Model ID:      $model_id"
echo "Repository:    $hf_repo"
echo "Filename:      $filename"
echo "Quantization:  $quant"
echo "Size:          ~$size"
echo ""

# Check if already downloaded
if [ -f "${MODELS_DIR}/${filename}" ]; then
    echo "✓ Model already exists: ${MODELS_DIR}/${filename}"
    echo ""
    read -p "Re-download? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping download."
        exit 0
    fi
fi

# Download using wget or curl
DOWNLOAD_URL="https://huggingface.co/${hf_repo}/resolve/main/${filename}"
echo "Downloading from: $DOWNLOAD_URL"
echo ""

mkdir -p "$MODELS_DIR"

if command -v wget &> /dev/null; then
    wget -c -O "${MODELS_DIR}/${filename}" "$DOWNLOAD_URL"
elif command -v curl &> /dev/null; then
    curl -L -C - -o "${MODELS_DIR}/${filename}" "$DOWNLOAD_URL"
else
    echo "ERROR: Neither wget nor curl found. Please install one."
    exit 1
fi

echo ""
echo "✓ Download complete: ${MODELS_DIR}/${filename}"
echo ""
echo "To use this model:"
if [ "$MODEL_ID" != "$ACTIVE_MODEL" ]; then
    echo "  1. Edit config.sh and set: ACTIVE_MODEL=\"$MODEL_ID\""
    echo "  2. Restart server or chat"
else
    echo "  - This is already your active model"
    echo "  - Start chatting: ./chat.sh"
    echo "  - Start server:   ./server.sh"
fi
echo ""
