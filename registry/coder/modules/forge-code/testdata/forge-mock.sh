#!/bin/bash

if [[ "$1" == "--version" ]]; then
  echo "forge version v1.0.0"
  exit 0
fi

set -e

while true; do
  echo "$(date) - forge-mock"
  sleep 15
done
