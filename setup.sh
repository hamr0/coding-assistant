#!/bin/bash
# Setup Script - Run this ONCE to clone and build llama.cpp
# Usage: ./setup.sh
# Takes ~5 minutes depending on your CPU
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Minimal Coding Assistant Setup ==="
echo ""

# Check for required tools
echo "[1/4] Checking dependencies..."
for cmd in git make gcc g++; do
    if ! command -v $cmd &> /dev/null; then
        echo "ERROR: $cmd not found. Please install build-essential."
        exit 1
    fi
done
echo "✓ Dependencies OK"

# Clone llama.cpp
echo ""
echo "[2/4] Cloning llama.cpp..."
if [ -d "llama.cpp" ]; then
    echo "✓ llama.cpp already exists"
else
    git clone https://github.com/ggerganov/llama.cpp.git
    echo "✓ llama.cpp cloned"
fi

# Build llama.cpp
echo ""
echo "[3/4] Building llama.cpp (this may take a few minutes)..."
cd llama.cpp
make clean &> /dev/null || true
make -j$(nproc)
cd ..
echo "✓ llama.cpp built successfully"

# Make scripts executable
echo ""
echo "[4/4] Making scripts executable..."
chmod +x *.sh
echo "✓ Scripts are executable"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Download a model: ./download-model.sh qwen2.5-coder-7b"
echo "  2. Start chatting:   ./chat.sh"
echo "  3. Or start server:  ./server.sh"
echo ""
echo "To switch models:"
echo "  - Download:   ./download-model.sh <model-id>"
echo "  - Edit:       config.sh (change ACTIVE_MODEL)"
echo "  - Available:  ./download-model.sh (list all)"
echo ""
