#!/bin/bash
# Синхронизирует новые memories из claudeclaw-new в Agent OS mem-add
# Запускается по cron каждые 30 минут
# Использует watermark (last_synced_id) чтобы не дублировать

DB="/Users/hoyas/Workspace/claudeclaw-new/store/claudeclaw.db"
MEM_ADD="/Users/hoyas/Workspace/agent-os/scripts/mem-add.sh"
WATERMARK_FILE="/Users/hoyas/Workspace/claudeclaw-new/store/sync-watermark.txt"

if [ ! -f "$DB" ]; then exit 0; fi
if [ ! -f "$MEM_ADD" ]; then exit 0; fi

LAST_ID=$(cat "$WATERMARK_FILE" 2>/dev/null || echo "0")

# Берём новые memories с importance >= 0.5
ROWS=$(sqlite3 "$DB" "SELECT id, content FROM memories WHERE id > $LAST_ID AND importance >= 0.5 ORDER BY id ASC LIMIT 20;" 2>/dev/null)

if [ -z "$ROWS" ]; then exit 0; fi

MAX_ID=$LAST_ID
while IFS='|' read -r id content; do
  if [ -n "$content" ]; then
    bash "$MEM_ADD" "$content" "tg-bot-memory" 2>/dev/null
    MAX_ID=$id
  fi
done <<< "$ROWS"

echo "$MAX_ID" > "$WATERMARK_FILE"
echo "[sync-to-agent-os] Synced up to id=$MAX_ID"
