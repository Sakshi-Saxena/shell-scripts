#!/bin/bash

set -euo pipefail

# 🔹 Check arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <backup_directory>"
    exit 1
fi

SRC="$1"
DEST="$2"

# 🔹 Validate source directory
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory '$SRC' does not exist"
    exit 1
fi

# 🔹 Create destination if not exists
mkdir -p "$DEST"

# 🔹 Timestamp
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="$DEST/backup-$TIMESTAMP.tar.gz"

echo "Creating backup..."

# 🔹 Create archive
tar -czf "$ARCHIVE" -C "$(dirname "$SRC")" "$(basename "$SRC")"

# 🔹 Verify archive
if [ ! -f "$ARCHIVE" ]; then
    echo "Error: Backup failed!"
    exit 1
fi

# 🔹 Print archive details
SIZE=$(du -h "$ARCHIVE" | awk '{print $1}')
echo "Backup created: $ARCHIVE"
echo "Size: $SIZE"

# 🔹 Delete old backups (>14 days)
echo "Cleaning old backups..."
deleted_count=$(find "$DEST" -type f -name "backup-*.tar.gz" -mtime +14 -print -delete | wc -l)

echo "Old backups deleted: $deleted_count"

echo "Backup process completed successfully."
