#!/bin/bash
# API Server - Start OpenAI-compatible API server
# Usage: ./server.sh
# Runs at http://127.0.0.1:8080/v1 (configure in config.sh)

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
echo "Template: $CHAT_TEMPLATE"
echo "Address:  http://${SERVER_HOST}:${SERVER_PORT}"
echo "Threads:  $N_THREADS"
echo "Context:  $CONTEXT_SIZE"
echo "Temp:     $TEMPERATURE"
echo ""
echo "Configure OpenCode/Droid to use:"
echo "  API Base URL: http://${SERVER_HOST}:${SERVER_PORT}/v1"
echo ""

# Start server in background
"${LLAMA_CPP_DIR}/build/bin/llama-server" \
    --model "$MODEL_PATH" \
    --host "$SERVER_HOST" \
    --port "$SERVER_PORT" \
    --ctx-size "$CONTEXT_SIZE" \
    --threads "$N_THREADS" \
    --temp "$TEMPERATURE" \
    --top-p "$TOP_P" \
    --repeat-penalty "$REPEAT_PENALTY" \
    --chat-template "$CHAT_TEMPLATE" \
    --log-disable &

SERVER_PID=$!
echo "Server PID: $SERVER_PID"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Set up trap to handle Ctrl+C
cleanup() {
    echo ""
    echo "Stopping server..."
    kill $SERVER_PID 2>/dev/null
    wait $SERVER_PID 2>/dev/null
    echo "Server stopped."
    exit 0
}

trap cleanup SIGINT

# Wait for server process
wait $SERVER_PID
