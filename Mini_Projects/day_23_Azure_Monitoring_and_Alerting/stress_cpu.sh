#!/bin/bash
# Simple CPU stress test script for Linux VM

# Install stress if not present
if ! command -v stress &> /dev/null; then
  echo "Installing stress..."
  sudo apt-get update && sudo apt-get install -y stress
fi

echo "Starting CPU stress test for 5 minutes (4 CPU workers)..."
stress --cpu 4 --timeout 300

echo "CPU stress test completed."