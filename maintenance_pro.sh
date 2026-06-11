#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/maintenance.log"

# 🔐 CONFIG (update these)
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/XXXX/XXXX/XXXX"
ALERT_EMAIL="your-email@example.com"

# 🔹 Logging
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# 🔹 Alert function (Slack + Email)
send_alert() {
    local MESSAGE="$1"

    log "ALERT: $MESSAGE"

    # Slack alert
    curl -s -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"🚨 $MESSAGE\"}" \
        "$SLACK_WEBHOOK_URL" >/dev/null || true

    # Email alert
    echo "$MESSAGE" | mail -s "🚨 Maintenance Script Alert" "$ALERT_EMAIL" || true
}

# 🔹 Error handler
handle_error() {
    local EXIT_CODE=$?
    send_alert "Script failed with exit code $EXIT_CODE. Check logs at $LOG_FILE"
    exit $EXIT_CODE
}

trap handle_error ERR

# 🔹 Log rotation
log_rotate() {
    local LOG_DIR="$1"

    [ -d "$LOG_DIR" ] || { send_alert "Log dir missing: $LOG_DIR"; return 1; }

    log "Rotating logs in $LOG_DIR"

    find "$LOG_DIR" -type f -name "*.log" -mtime +7 \
        -exec gzip {} \; 2>/dev/null || true

    find "$LOG_DIR" -type f -name "*.gz" -mtime +30 \
        -delete 2>/dev/null || true

    log "Log rotation completed"
}

# 🔹 Backup
backup() {
    local SRC="$1"
    local DEST="$2"

    [ -d "$SRC" ] || { send_alert "Source missing: $SRC"; return 1; }

    mkdir -p "$DEST"

    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    ARCHIVE="$DEST/backup-$TIMESTAMP.tar.gz"

    log "Creating backup..."

    tar -czf "$ARCHIVE" -C "$(dirname "$SRC")" "$(basename "$SRC")"

    if [ ! -f "$ARCHIVE" ]; then
        send_alert "Backup failed for $SRC"
        return 1
    fi

    SIZE=$(du -h "$ARCHIVE" | awk '{print $1}')
    log "Backup created: $ARCHIVE (Size: $SIZE)"

    find "$DEST" -type f -name "backup-*.tar.gz" -mtime +14 \
        -delete 2>/dev/null || true

    log "Old backups cleaned"
}

# 🔹 Main
main() {
    log "===== Maintenance Started ====="

   
    log_rotate "~/test_logs"
    backup "~/test_source" "~/backups" 

    log "===== Maintenance Completed Successfully ====="
}

# 🔹 Run with logging
main >> "$LOG_FILE" 2>&1
