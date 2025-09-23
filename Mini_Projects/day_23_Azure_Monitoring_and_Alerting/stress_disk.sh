#!/bin/bash
# Simple disk space stress test script for Linux VM

# Directory to use for test files
STRESS_DIR="/tmp/disk_stress_test"
mkdir -p "$STRESS_DIR"

# Create 5 files of 1GB each
for i in {1..5}; do
  echo "Creating $STRESS_DIR/largefile_$i (1GB) ..."
  dd if=/dev/zero of="$STRESS_DIR/largefile_$i" bs=1M count=1024 status=progress
  sync
  sleep 1
  df -h "$STRESS_DIR"
done

echo "Disk stress test completed. Files created in $STRESS_DIR."
