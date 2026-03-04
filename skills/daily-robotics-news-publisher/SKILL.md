---
name: daily-robotics-news-publisher
description: Publish OpenClaw-generated daily robotics digests (Markdown) into a Jekyll/Chirpy GitHub Pages repository as two posts (CN/EN), with correct front matter, same-day versioning (_v2/_v3), and optional git author config + commit + push. Use when you need to automate posting daily robotics research/market summaries to a website repo (e.g., yiichu03.github.io) and keep an index page showing Latest (CN)/(EN).
---

# Daily Robotics News Publisher

## Workflow

1. Ensure the target website repo exists locally and is a git repo.
   - Typical path: `~/prog/OpenClaw/yiichu03.github.io/`
   - Must have working git auth (SSH recommended).

2. Ensure the source digest files exist (CN + EN).
   - Typical paths:
     - `~/prog/OpenClaw/docs/Chinese/robotics_digest_YYYY-MM-DD.md`
     - `~/prog/OpenClaw/docs/English/robotics_digest_YYYY-MM-DD.md`

3. Run the publisher script.

### Script

- Path: `scripts/publish_daily_robotics_news.sh`

Examples:

```bash
# Publish today (CN/EN), commit, push
scripts/publish_daily_robotics_news.sh \
  --repo ~/prog/OpenClaw/yiichu03.github.io \
  --git-name yiichu03 \
  --git-email yiichu03@gmail.com

# Publish a specific date without pushing (local check)
scripts/publish_daily_robotics_news.sh \
  --date 2026-03-04 \
  --repo ~/prog/OpenClaw/yiichu03.github.io \
  --no-push
```

## Output contract

- Writes two posts into `<repo>/_posts/digests/`.
- Adds Jekyll front matter:
  - `categories: [Digest, Robotics]`
  - `tags: [robotics, market, arxiv, cn|en]`
- Preserves same-day versions by filename suffix `_v2`, `_v3`, ...

For the full conventions, see `references/conventions.md`.
