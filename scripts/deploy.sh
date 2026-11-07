#!/usr/bin/env bash
set -euo pipefail

REMOTE="devops"
REMOTE_DIR="/var/www/devops-site"
SITE_URL="https://devops.local"
CA_CERT="${HOME}/devops.crt"
LOCAL_DIR="$(git rev-parse --show-toplevel)/site"

# 1. Разбор аргумента --dry-run
DRY_RUN=""
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN="--dry-run"
fi

# 2. Проверки по требованиям 4 и 5
if [[ ! -f "${LOCAL_DIR}/index.html" ]]; then
    echo "Ошибка: Файл ${LOCAL_DIR}/index.html не найден!" >&2
    exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
    echo "Ошибка: В репозитории есть незафиксированные изменения!" >&2
    exit 1
fi

# 3. Синхронизация (требование 8: не более одного SSH-соединения, BatchMode)
echo "Синхронизация ${LOCAL_DIR}/ на ${REMOTE}:${REMOTE_DIR}/"
rsync -avz --delete --chmod=D755,F644 ${DRY_RUN} -e "ssh -o BatchMode=yes -o ConnectTimeout=5" "${LOCAL_DIR}/" "${REMOTE}:${REMOTE_DIR}/"

# 4. При --dry-run — завершение с кодом 0 без проверки доступности
if [[ -n "${DRY_RUN}" ]]; then
    echo "Dry-run завершен. Изменения не вносились."
    exit 0
fi

# 5. Проверка доступности (требование 6)
if ! curl -f --cacert "${CA_CERT}" -s -o /dev/null "${SITE_URL}"; then
    echo "Ошибка: Сайт ${SITE_URL} недоступен после деплоя!" >&2
    exit 1
fi

# 7. Успешное завершение
echo "Деплой успешен. Коммит: $(git rev-parse --short HEAD)"
exit 0
