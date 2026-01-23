#!/bin/bash
# API Server - Start OpenAI-compatible API server
# Usage: ./server.sh
# Runs at http://127.0.0.1:8080/v1 (configure in config.sh)
# Use this for OpenCode/Droid integration
# Press Ctrl+C to stop
set -e

# Handle Ctrl+C properly
trap 'echo ""; echo "Shutting down server..."; exit 0' SIGINT SIGTERM

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

# Check if llama.cpp is built
if [ ! -f "${LLAMA_CPP_DIR}/build/bin/llama-server" ]; then
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

echo "=== Starting OpenAI-Compatible API Server ==="
echo "Model:    $ACTIVE_MODEL"
echo "File:     $MODEL_FILE"
echo "Address:  http://${SERVER_HOST}:${SERVER_PORT}"
echo "Threads:  $N_THREADS"
echo "Context:  $CONTEXT_SIZE"
echo ""
echo "Configure OpenCode/Droid to use:"
echo "  API Base URL: http://${SERVER_HOST}:${SERVER_PORT}/v1"
echo ""
echo "Press Ctrl+C to stop"
echo ""

exec "${LLAMA_CPP_DIR}/build/bin/llama-server" \
    --model "$MODEL_PATH" \
    --host "$SERVER_HOST" \
    --port "$SERVER_PORT" \
    --ctx-size "$CONTEXT_SIZE" \
    --threads "$N_THREADS" \
    --chat-template auto \
    --log-disable
