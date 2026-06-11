#!/bin/bash

set -euo pipefail

# Check argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <log_directory>"
    exit 1
fi

LOG_DIR="$1"

# Check if directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory '$LOG_DIR' does not exist"
    exit 1
fi

echo "Processing logs in: $LOG_DIR"

# 🔹 Compress .log files older than 7 days
compressed_count=$(find "$LOG_DIR" -type f -name "*.log" -mtime +7 ! -name "*.gz" -print -exec gzip {} \; 2>/dev/null | wc -l)

# 🔹 Delete .gz files older than 30 days
deleted_count=$(find "$LOG_DIR" -type f -name "*.gz" -mtime +30 -print -delete | wc -l)

# 🔹 Output results
echo "----------------------------------------"
echo "Files compressed: $compressed_count"
echo "Files deleted:    $deleted_count"
echo "Log rotation completed."
