# Daily Robotics News (Generate → Publish)

This repo contains a skill + scripts to **generate a daily robotics digest (CN/EN)** and **publish it to your GitHub Pages site** (`yiichu03.github.io`).

- Generate output (local files):
  - `~/prog/OpenClaw/docs/Chinese/robotics_digest_YYYY-MM-DD.md`
  - `~/prog/OpenClaw/docs/English/robotics_digest_YYYY-MM-DD.md`
- Publish destination (website repo):
  - `~/prog/OpenClaw/yiichu03.github.io/_posts/digests/`

The publisher preserves same-day revisions as `_v2/_v3/...`.

---

## Quick commands

### Publish-only (assumes CN/EN files already exist)

```bash
~/prog/OpenClaw/openclaw/skills/daily-robotics-news-publisher/scripts/publish_after_generation.sh
```

### Create / recreate the OpenClaw cron job (new machine)

Cron jobs live in **Gateway state**, so on a new machine you typically need to recreate them.

```bash
openclaw cron add \
  --name daily-robotics-news-generate-and-publish \
  --description "Generate daily robotics digest (CN/EN) then publish to yiichu03.github.io" \
  --agent main \
  --session isolated \
  --cron "0 0 9 * * *" \
  --tz "Asia/Singapore" \
  --disabled \
  --thinking low \
  --timeout-seconds 3600 \
  --expect-final \
  --no-deliver \
  --message "You are a robotics frontier tech + market intelligence research agent.\n\nAt runtime, first compute TODAY using a shell command: date +%F.\n\nThen generate TWO markdown files (CN and EN) with objective, source-linked content and save EXACTLY to:\n- CN: ~/prog/OpenClaw/docs/Chinese/robotics_digest_${TODAY}.md\n- EN: ~/prog/OpenClaw/docs/English/robotics_digest_${TODAY}.md\n\nStructure (must include): 摘要(5-8条)/技术前沿/最新市场需求(近90天)/供需匹配与机会/风险限制/参考来源(标题机构日期链接).\n\nConstraints: Tech<=12mo; Market<=90d; dedup to original; no long quotes; avoid marketing tone.\n\nAfter writing both files, publish them by running:\n~/prog/OpenClaw/openclaw/skills/daily-robotics-news-publisher/scripts/publish_after_generation.sh ${TODAY}"
```

Enable it:

```bash
openclaw cron enable daily-robotics-news-generate-and-publish
```

---

## New machine setup checklist

1. **Clone this repo** (your fork) and checkout the branch containing the skill:

```bash
mkdir -p ~/prog/OpenClaw
cd ~/prog/OpenClaw

git clone git@github.com:yiichu03/openclaw.git
cd openclaw

git checkout feature/daily-robotics-news-publisher
```

2. **Clone the website repo**:

```bash
cd ~/prog/OpenClaw

git clone git@github.com:yiichu03/yiichu03.github.io.git
```

3. **Configure git identity** (repo-local) for the website repo:

```bash
cd ~/prog/OpenClaw/yiichu03.github.io

git config --local user.name "yiichu03"
git config --local user.email "yiichu03@gmail.com"
```

4. **Ensure GitHub SSH works** (you should be able to push from the website repo).

5. **Create and enable the cron job** (see above).

---

## Debugging

List jobs:

```bash
openclaw cron list
openclaw cron list --json
```

Run once now (debug):

```bash
openclaw cron run <job-id>
```

Run history:

```bash
openclaw cron runs --id <job-id> --limit 20
```

---

## Skill docs

The canonical skill docs live here:

- `skills/daily-robotics-news-publisher/SKILL.md`
- `skills/daily-robotics-news-publisher/references/deploy.md`
