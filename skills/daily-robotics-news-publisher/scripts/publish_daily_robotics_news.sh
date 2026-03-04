#!/usr/bin/env bash
set -euo pipefail

# Publish OpenClaw-generated daily robotics digests into a Chirpy/Jekyll repo.
# Creates two posts (CN/EN), preserves same-day versions (_v2/_v3), commits, and pushes.

usage() {
  cat <<'EOF'
Usage:
  publish_daily_robotics_news.sh [--date YYYY-MM-DD]
                              [--repo /path/to/yiichu03.github.io]
                              [--cn-src /path/to/robotics_digest_YYYY-MM-DD.md]
                              [--en-src /path/to/robotics_digest_YYYY-MM-DD.md]
                              [--git-name NAME] [--git-email EMAIL]
                              [--no-push]

Defaults:
  --date     : today (local)
  --repo     : ~/prog/OpenClaw/yiichu03.github.io
  --cn-src   : ~/prog/OpenClaw/docs/Chinese/robotics_digest_DATE.md
  --en-src   : ~/prog/OpenClaw/docs/English/robotics_digest_DATE.md
  --git-name : (unchanged)
  --git-email: (unchanged)

Behavior:
  - Writes to: <repo>/_posts/digests/
      DATE-robotics-digest-cn.md
      DATE-robotics-digest-en.md
    If those exist, appends _v2/_v3...
  - Adds Jekyll front matter:
      categories: [Digest, Robotics]
      tags: [robotics, market, arxiv, cn|en]
  - Commits and pushes (unless --no-push)
EOF
}

DATE=""
REPO="$HOME/prog/OpenClaw/yiichu03.github.io"
CN_SRC=""
EN_SRC=""
GIT_NAME=""
GIT_EMAIL=""
DO_PUSH=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --date)
      DATE="$2"; shift 2;;
    --repo)
      REPO="$2"; shift 2;;
    --cn-src)
      CN_SRC="$2"; shift 2;;
    --en-src)
      EN_SRC="$2"; shift 2;;
    --git-name)
      GIT_NAME="$2"; shift 2;;
    --git-email)
      GIT_EMAIL="$2"; shift 2;;
    --no-push)
      DO_PUSH=0; shift 1;;
    -h|--help)
      usage; exit 0;;
    *)
      echo "Unknown arg: $1" >&2
      usage
      exit 2;;
  esac
done

if [[ -z "$DATE" ]]; then
  DATE="$(date +%F)"
fi

if [[ -z "$CN_SRC" ]]; then
  CN_SRC="$HOME/prog/OpenClaw/docs/Chinese/robotics_digest_${DATE}.md"
fi

if [[ -z "$EN_SRC" ]]; then
  EN_SRC="$HOME/prog/OpenClaw/docs/English/robotics_digest_${DATE}.md"
fi

if [[ ! -d "$REPO/.git" ]]; then
  echo "ERROR: repo not found or not a git repo: $REPO" >&2
  exit 3
fi

if [[ ! -f "$CN_SRC" ]]; then
  echo "ERROR: CN source not found: $CN_SRC" >&2
  exit 4
fi

if [[ ! -f "$EN_SRC" ]]; then
  echo "ERROR: EN source not found: $EN_SRC" >&2
  exit 5
fi

cd "$REPO"

if [[ -n "$GIT_NAME" ]]; then
  git config --local user.name "$GIT_NAME"
fi

if [[ -n "$GIT_EMAIL" ]]; then
  git config --local user.email "$GIT_EMAIL"
fi

POST_DIR="$REPO/_posts/digests"
mkdir -p "$POST_DIR"

next_name() {
  local base="$1"
  if [[ ! -e "$base" ]]; then
    echo "$base"; return
  fi
  local i=2
  while true; do
    local cand="${base%.md}_v${i}.md"
    if [[ ! -e "$cand" ]]; then
      echo "$cand"; return
    fi
    i=$((i+1))
  done
}

write_post() {
  local src="$1" base="$2" title="$3" tag="$4"
  local dst
  dst="$(next_name "$base")"
  {
    echo "---"
    echo "title: \"${title}\""
    echo "date: ${DATE} 00:00:00 +0800"
    echo "categories: [Digest, Robotics]"
    echo "tags: [robotics, market, arxiv, ${tag}]"
    echo "---"
    echo
    cat "$src"
  } > "$dst"
  echo "$dst"
}

CN_BASE="$POST_DIR/${DATE}-robotics-digest-cn.md"
EN_BASE="$POST_DIR/${DATE}-robotics-digest-en.md"

CN_DST="$(write_post "$CN_SRC" "$CN_BASE" "Robotics Digest (CN) — ${DATE}" cn)"
EN_DST="$(write_post "$EN_SRC" "$EN_BASE" "Robotics Digest (EN) — ${DATE}" en)"

# Commit and push

git add "$CN_DST" "$EN_DST"

if git diff --cached --quiet; then
  echo "No changes to commit."
  echo "CN: $CN_DST"
  echo "EN: $EN_DST"
  exit 0
fi

git commit -m "Daily robotics news: ${DATE} (CN/EN)"

if [[ "$DO_PUSH" -eq 1 ]]; then
  git push
else
  echo "Skipping push (--no-push)."
fi

echo "Published:"
echo "- $CN_DST"
echo "- $EN_DST"
