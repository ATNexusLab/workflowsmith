#!/usr/bin/env bash
# Mantém apenas os últimos 30 dias de logs do Copilot CLI.
# Uso: ./scripts/clean-logs.sh
# Sugestão de cron (semanal): 0 3 * * 0 /home/theo/.copilot/scripts/clean-logs.sh
set -euo pipefail
LOG_DIR="$(cd "$(dirname "$0")/.." && pwd)/logs"
[ -d "$LOG_DIR" ] || { echo "logs/ não encontrado em $LOG_DIR"; exit 0; }
find "$LOG_DIR" -type f -mtime +30 -delete
echo "Logs antigos removidos. Restantes: $(find "$LOG_DIR" -type f | wc -l)"
