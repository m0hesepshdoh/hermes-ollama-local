#!/bin/bash
set -e

echo "=== Spinning up IaC Local Agent Environment ==="
docker compose up -d

echo "=== Waiting for Ollama to be ready ==="
until curl -s http://localhost:11434/api/tags > /dev/null; do
  sleep 2
done

echo "=== Pulling Local Models ==="
docker exec -it ollama ollama pull llama3.2:1b
docker exec -it ollama ollama pull llama3.1:8b

echo "=== Configuring Hermes Agent Provider ==="
docker exec -it hermes_agent hermes config set providers.default ollama
docker exec -it hermes_agent hermes config set providers.ollama.base_url http://ollama:11434/v1

echo "=== Setup Complete! ==="
echo "Run: docker exec -it hermes_agent hermes chat --model ollama/llama3.2:1b"