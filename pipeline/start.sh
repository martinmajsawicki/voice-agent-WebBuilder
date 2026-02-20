#!/bin/bash
# ============================================================
# START — Voice-WebBuilder-Agent pipeline
# Run:  cd pipeline && ./start.sh
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Load .env
if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)
    echo "Loaded .env"
else
    echo "Missing .env file! Copy .env.example -> .env and add your API key."
    exit 1
fi

# Check key
if [ "$ANTHROPIC_API_KEY" = "sk-ant-YOUR-API-KEY-HERE" ] || [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "Set a valid ANTHROPIC_API_KEY in .env!"
    exit 1
fi

echo ""
echo "============================================================"
echo "  Voice-WebBuilder-Agent — Starting pipeline"
echo "============================================================"
echo ""

# Start webhook server in background
python3 "$SCRIPT_DIR/webhook-server.py" &
SERVER_PID=$!
echo "Webhook server PID: $SERVER_PID"

# Wait for server to start
sleep 2

echo ""
echo "Starting ngrok..."
echo "   After launch, copy the https://...ngrok-free.dev URL"
echo "   and paste it in ElevenLabs -> Agent -> Tool -> URL"
echo ""
echo "   Photo upload on phone: https://[ngrok-url]/upload"
echo ""
echo "   Ctrl+C to stop everything"
echo "============================================================"
echo ""

# ngrok in foreground (Ctrl+C stops it)
ngrok http 5555

# After closing ngrok — kill webhook server
echo ""
echo "Stopping webhook server..."
kill $SERVER_PID 2>/dev/null
echo "Done. Everything stopped."
