---
name: daily-robotics-news-publisher
description: Publish OpenClaw-generated daily robotics digests (Markdown) into a Jekyll/Chirpy GitHub Pages repository as two posts (CN/EN), with correct front matter, same-day versioning (_v2/_v3), and optional git author config + commit + push. Use when you need to automate posting daily robotics research/market summaries to a website repo (e.g., yiichu03.github.io) and keep an index page showing Latest (CN)/(EN).
---

# Daily Robotics News Publisher

## Workflow

### A) End-to-end (generate → publish)

1. **Generate the daily digests (CN + EN)** into the standard locations.
   - Recommended output paths (what this skill defaults to):
     - `~/prog/OpenClaw/docs/Chinese/robotics_digest_YYYY-MM-DD.md`
     - `~/prog/OpenClaw/docs/English/robotics_digest_YYYY-MM-DD.md`
   - How to generate:
     - Run your existing OpenClaw “daily robotics news” routine (the agent can do multi-round web search, dedup, and write markdown).
     - If you schedule it (cron), schedule **generation first**, then run the publisher script as the second step.

2. **Publish to the website repo** (commit + push) using the script below.

### B) Publish-only (files already generated)

1. Ensure the target website repo exists locally and is a git repo.
   - Typical path: `~/prog/OpenClaw/yiichu03.github.io/`
   - Must have working git auth (SSH recommended).

2. Ensure the source digest files exist (CN + EN).

3. Run the publisher script.

### Scripts

- Publisher (core): `scripts/publish_daily_robotics_news.sh`
- Wrapper for cron chaining (recommended): `scripts/publish_after_generation.sh`

Examples:

```bash
# Recommended: publish today after your generator has produced CN/EN files
scripts/publish_after_generation.sh

# Publish a specific date (useful for backfills)
scripts/publish_after_generation.sh 2026-03-04

# Direct publisher (manual overrides)
scripts/publish_daily_robotics_news.sh \
  --date 2026-03-04 \
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
