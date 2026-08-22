---
name: weekly-review
description: >
  Mikey's Friday weekly review. Reads his personal list (Mikeys Desk / MDD) and
  calendar, then posts one review digest to his md-notes Slack channel: stale
  items, parked ideas, still-overdue reminders, candidates to promote to a shared
  team, and the week ahead. Runs Friday afternoon on a schedule, or on demand
  ("run my weekly review"). Read-only apart from the single Slack post. Not for
  daily triage (that is /pa:sweep) or adding items (that is /pa:capture).
---

# weekly-review

A Friday wrap-up so nothing rots on the list and next week is in view. Team ID,
statuses, labels, the Slack channel and timezone are in `../../config.md`.

## What this run may and may not do

- **May:** read Google Calendar and read MDD issues, and post ONE digest to
  `SLACK_NOTIFY_CHANNEL` as the bot.
- **May NOT:** change any Linear issue, send email, or post anywhere else. This is
  a review; it surfaces and suggests, it does not re-file.

## Gather

1. **Stale** — open MDD issues (status `Next` or `In Progress`) assigned to me not
   updated in 7+ days. These are drifting.
2. **Parked** — `Icebox` items and `Thinking`-labelled items worth a second look.
3. **Still overdue** — reminders / due-dated issues past their date, not Done.
4. **Promote** — MDD items that read like real cross-team work rather than
   personal notes; suggest which shared team/project each could move to (name it,
   do not move it).
5. **Week ahead** — next week's notable calendar events (external meetings, big
   internal ones, anything needing prep). Flag if next week contains the monthly
   townhall (target: first Wednesday of the month) and that prep is due.

## Compose and deliver

One Slack mrkdwn message, `*bold*` headings, `•` bullets, drop empty sections,
link issues to their URL. British English, no em dashes, scannable. Header:
🗓️ `*Weekly review, {Weekday DD Mon}*`. Sections in order: *Stale*, *Parked*,
*Still overdue*, *Promote?*, *Week ahead*. If a section is empty, omit it; if the
whole review is empty, post `Clean week, nothing to review.`

Deliver exactly as the sweep does (SKILL: `../sweep/SKILL.md`, step Deliver):
write the message to a file and POST to `https://slack.com/api/chat.postMessage`
as the bot with `MAILCHECK_SLACK_BOT_TOKEN`, `unfurl_links` and `unfurl_media`
false. Do NOT use the Slack connector. Confirm `ok` is true; if not, report the error.
