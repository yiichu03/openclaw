#!/usr/bin/env bash
set -euo pipefail

# Wrapper: publish today's digests after the generation step has produced the source files.
# Intended for cron chaining: run generator first, then this script.

DATE="${1:-$(date +%F)}"
REPO="$HOME/prog/OpenClaw/yiichu03.github.io"
GIT_NAME="yiichu03"
GIT_EMAIL="yiichu03@gmail.com"

CN_SRC="$HOME/prog/OpenClaw/docs/Chinese/robotics_digest_${DATE}.md"
EN_SRC="$HOME/prog/OpenClaw/docs/English/robotics_digest_${DATE}.md"

if [[ ! -f "$CN_SRC" ]]; then
  echo "ERROR: CN digest not found (generation likely failed or not run yet): $CN_SRC" >&2
  exit 10
fi

if [[ ! -f "$EN_SRC" ]]; then
  echo "ERROR: EN digest not found (generation likely failed or not run yet): $EN_SRC" >&2
  exit 11
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

exec "$SCRIPT_DIR/publish_daily_robotics_news.sh" \
  --date "$DATE" \
  --repo "$REPO" \
  --cn-src "$CN_SRC" \
  --en-src "$EN_SRC" \
  --git-name "$GIT_NAME" \
  --git-email "$GIT_EMAIL"
