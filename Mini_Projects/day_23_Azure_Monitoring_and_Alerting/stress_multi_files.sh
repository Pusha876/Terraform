#!/bin/bash
# Script to create multiple large files in a loop to stress test disk space

STRESS_DIR="/tmp/multi_file_stress_test"
mkdir -p "$STRESS_DIR"

NUM_FILES=20
FILE_SIZE_MB=100

for i in $(seq 1 $NUM_FILES); do
  echo "Creating $STRESS_DIR/file_$i (${FILE_SIZE_MB}MB) ..."
  dd if=/dev/zero of="$STRESS_DIR/file_$i" bs=1M count=$FILE_SIZE_MB status=none
  sync
  sleep 1
  df -h "$STRESS_DIR"
done

echo "Multiple file disk stress test completed. Files created in $STRESS_DIR."
