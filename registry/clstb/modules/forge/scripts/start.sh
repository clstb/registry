#!/bin/bash

set -o errexit
set -o pipefail

command_exists() {
  command -v "$1" > /dev/null 2>&1
}

if command_exists forge; then
  FORGE_CMD=forge
elif [ -f "$HOME/.local/bin/forge" ]; then
  FORGE_CMD="$HOME/.local/bin/forge"
else
  echo "Error: Forge is not installed. Please enable install_forge or install it manually."
  exit 1
fi

MODULE_DIR="$HOME/.forge-module"
mkdir -p "$MODULE_DIR"

if [ ! -z "$FORGE_TASK_PROMPT" ]; then
  echo "Starting with a prompt"
  PROMPT_FILE="$MODULE_DIR/prompt.txt"
  echo -n "$FORGE_TASK_PROMPT" > "$PROMPT_FILE"
  FORGE_ARGS=(--prompt-file "$PROMPT_FILE")
else
  echo "Starting without a prompt"
  FORGE_ARGS=()
fi

agentapi server --term-width 67 --term-height 1190 -- \
  bash -c "$(printf '%q ' "$FORGE_CMD" "${FORGE_ARGS[@]}")"