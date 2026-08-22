---
name: nudge
description: >
  Deliver Mikey's due reminders to his Slack channel. Reads his personal list
  (Mikeys Desk / MDD) for reminder issues due today or overdue and posts one
  grouped message to his notification channel. Runs on a schedule (weekday
  mornings) and can be invoked manually ("check my reminders", "what's due").
  Do NOT use to add reminders (that is /pa:capture) or for the full morning brief
  (that is /pa:sweep).
---

# nudge

Surface time-based reminders from Mikey's list into Slack. Team ID and the Slack
channel are in `../../config.md`.

## What counts as due

- Issues in the MDD team assigned to me with a due date **on or before today**.
- Reminders live in the `Reminders` status, but also include any assigned issue
  with a due date that has arrived, whatever its status, so dated todos are not
  missed.
- Exclude `Done`, `Canceled`, `Duplicate`.

## Steps

1. Read `../../config.md` for `LIST_TEAM_ID` (MDD) and `SLACK_NOTIFY_CHANNEL`.
2. Query Linear with `list_issues`: team = MDD, assignee = me, due date <= today,
   not in a terminal status.
3. If nothing is due, **post nothing and stop.** Silence is correct on an empty day.
4. Otherwise format one short Slack message:
   - Group into **Overdue** (due before today) and **Due today**.
   - One line each: the title, the due date (plus any time noted in the title),
     and the issue URL.
   - No preamble, no filler.
5. Post to `SLACK_NOTIFY_CHANNEL` with `slack_send_message`.

## Notes

- Day granularity. A "3pm" reminder is listed in the morning run; the time lives
  in the title.
- Overdue items keep appearing until closed. That is intended nagging.
- Manual invocation ("what's due", "check my reminders") runs the same query and
  may reply in-chat instead of Slack if asked.
