#!/bin/bash
# Сохраняет факты из сессий TG-бота в Agent OS KB через mem-add.sh
# Вызывается вручную или по расписанию
# Использование: kb-bridge.sh "<текст для сохранения>" "<тег>"

TEXT="${1}"
TAG="${2:-tg-bot}"

if [ -z "$TEXT" ]; then
  echo "Usage: kb-bridge.sh <text> [tag]"
  exit 1
fi

MEM_ADD="/Users/hoyas/Workspace/agent-os/scripts/mem-add.sh"

if [ ! -f "$MEM_ADD" ]; then
  echo "ERROR: mem-add.sh not found at $MEM_ADD"
  exit 1
fi

bash "$MEM_ADD" "$TEXT" "$TAG"
echo "Saved to KB: $TAG"
