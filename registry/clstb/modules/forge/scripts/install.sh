#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" > /dev/null 2>&1
}

set -o nounset

echo "--------------------------------"
echo "install: $ARG_INSTALL"
echo "forge_version: $ARG_FORGE_VERSION"
echo "--------------------------------"

set +o nounset

if [ "${ARG_INSTALL}" = "true" ]; then
  echo "Installing Forge..."
  if [ "${ARG_FORGE_VERSION}" = "latest" ]; then
    curl -fsSL https://forgecode.dev/install.sh | bash
  else
    curl -fsSL https://forgecode.dev/install.sh | bash -s -- --version "${ARG_FORGE_VERSION}"
  fi
  echo "Forge installed"
else
  echo "Skipping Forge installation"
fi

if command_exists forge; then
  FORGE_CMD=forge
elif [ -f "$HOME/.local/bin/forge" ]; then
  FORGE_CMD="$HOME/.local/bin/forge"
else
  echo "Error: Forge is not installed. Please enable install_forge or install it manually."
  exit 1
fi
