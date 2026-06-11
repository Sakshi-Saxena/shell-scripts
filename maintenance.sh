#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/maintenance.log"

# 🔹 Logging function (adds timestamp)
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# 🔹 Log rotation function
log_rotate() {
    local LOG_DIR="$1"

    if [ ! -d "$LOG_DIR" ]; then
        log "ERROR: Log directory $LOG_DIR does not exist"
        return 1
    fi

    log "Starting log rotation for $LOG_DIR"

    compressed=$(find "$LOG_DIR" -type f -name "*.log" -mtime +7 \
        -exec gzip {} \; -print 2>/dev/null | wc -l)

    deleted=$(find "$LOG_DIR" -type f -name "*.gz" -mtime +30 \
        -print -delete 2>/dev/null | wc -l)

    log "Compressed files: $compressed"
    log "Deleted files: $deleted"
}

# 🔹 Backup function
backup() {
    local SRC="$1"
    local DEST="$2"

    if [ ! -d "$SRC" ]; then
        log "ERROR: Source directory $SRC does not exist"
        return 1
    fi

    mkdir -p "$DEST"

    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    ARCHIVE="$DEST/backup-$TIMESTAMP.tar.gz"

    log "Creating backup for $SRC"

    tar -czf "$ARCHIVE" -C "$(dirname "$SRC")" "$(basename "$SRC")"

    if [ ! -f "$ARCHIVE" ]; then
        log "ERROR: Backup failed"
        return 1
    fi

    SIZE=$(du -h "$ARCHIVE" | awk '{print $1}')
    log "Backup created: $ARCHIVE (Size: $SIZE)"

    deleted=$(find "$DEST" -type f -name "backup-*.tar.gz" -mtime +14 \
        -print -delete 2>/dev/null | wc -l)

    log "Old backups deleted: $deleted"
}

# 🔹 Main function
main() {
    log "===== Maintenance Started ====="

    log_rotate "../test_logs"
    backup "../test_source" "../backups"

    log "===== Maintenance Completed ====="
}

# 🔹 Run and log everything
main >> "$LOG_FILE" 2>&1
