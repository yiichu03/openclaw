# Deploy / Setup (new machine)

This doc explains how to run the **Daily Robotics News** pipeline on another computer:

- **Generate** daily digest (CN/EN) via an OpenClaw cron job (isolated agent session)
- **Publish** the generated markdown files to a Chirpy/Jekyll website repo (`yiichu03.github.io`) via git commit+push

## 0) Prereqs

- OpenClaw installed and Gateway running
- Git + SSH configured for GitHub
- The website repo is cloned locally at:
  - `~/prog/OpenClaw/yiichu03.github.io/`

## 1) Clone your OpenClaw fork (includes the skill)

```bash
mkdir -p ~/prog/OpenClaw
cd ~/prog/OpenClaw

git clone git@github.com:yiichu03/openclaw.git
cd openclaw

git checkout feature/daily-robotics-news-publisher
```

## 2) Clone your website repo

```bash
cd ~/prog/OpenClaw

git clone git@github.com:yiichu03/yiichu03.github.io.git
```

## 3) Configure git identity (repo-local)

Website repo:

```bash
cd ~/prog/OpenClaw/yiichu03.github.io

git config --local user.name "yiichu03"
git config --local user.email "yiichu03@gmail.com"
```

(Optional) OpenClaw repo:

```bash
cd ~/prog/OpenClaw/openclaw

git config --local user.name "yiichu03"
git config --local user.email "yiichu03@gmail.com"
```

## 4) Verify the publisher works (publish-only)

Assuming today’s digest files already exist at:

- `~/prog/OpenClaw/docs/Chinese/robotics_digest_YYYY-MM-DD.md`
- `~/prog/OpenClaw/docs/English/robotics_digest_YYYY-MM-DD.md`

Run:

```bash
~/prog/OpenClaw/openclaw/skills/daily-robotics-news-publisher/scripts/publish_after_generation.sh
```

## 5) Create the OpenClaw cron job (generate → publish)

Cron jobs live in the **Gateway state**, so on a new machine you generally need to recreate them.

Create a disabled job first (edit the schedule/timezone as you like):

```bash
openclaw cron add \
  --name daily-robotics-news-generate-and-publish \
  --description "Generate daily robotics digest (CN/EN) then publish to yiichu03.github.io" \
  --agent main \
  --session isolated \
  --cron "0 0 1 * * *" \
  --tz "Asia/Singapore" \
  --disabled \
  --thinking low \
  --timeout-seconds 3600 \
  --expect-final \
  --message "You are a robotics frontier tech + market intelligence research agent.\n\nAt runtime, first compute TODAY using a shell command: date +%F.\n\nThen generate TWO markdown files (CN and EN) and save EXACTLY to:\n- CN: ~/prog/OpenClaw/docs/Chinese/robotics_digest_${TODAY}.md\n- EN: ~/prog/OpenClaw/docs/English/robotics_digest_${TODAY}.md\n\nAfter writing both files, publish them by running:\n~/prog/OpenClaw/openclaw/skills/daily-robotics-news-publisher/scripts/publish_after_generation.sh ${TODAY}" \
  --announce
```

Then enable it:

```bash
openclaw cron enable daily-robotics-news-generate-and-publish
```

## 6) Debug / run once

```bash
openclaw cron run daily-robotics-news-generate-and-publish
openclaw cron runs --limit 50
```
