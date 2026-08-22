---
name: capture
description: >
  Capture something onto Mikey's personal list: a todo, a reminder, a thing to
  think about, a follow-up he promised, an investigation, a chore, and so on. Use
  whenever he says "add X to my list", "remind me to X", "capture this", "note
  this idea", "I said I'd look into X", or pastes something he wants to keep.
  Creates a Linear issue in his Mikeys Desk team (key MDD), assigned to him, with
  the right status and label, and a due date for reminders. Do NOT use for team
  work in other Linear teams/projects, or for reading the list back (that is
  /pa:sweep).
---

# capture

Turn a quick phrase into one well-formed issue on Mikey's personal list. Fast and
low-friction, no interrogation. The list is the **Mikeys Desk** team (`MDD`), not
a project. Team ID, statuses and the Slack channel are in `../../config.md`.

## Status routing

Pick the status from what kind of item it is:

| Item | Status |
|------|--------|
| Has a "when" (a time or date) → a reminder | `Reminders` + due date |
| Actionable now / soon (default) | `Next` |
| Someday, not yet actionable, or a parked thought | `Icebox` |

## Label

Assign one label from the team taxonomy (see `../../config.md` / the list in
CLAUDE.md). Common mappings:

- general todo → `Task`
- promised on Slack / owe someone → `Follow-up`
- dig into / find out → `Investigation`
- to mull over → `Thinking`
- housekeeping → `Chores`
- strategic → `Strategy`
- how to say something / messaging → `Comms`
- townhall / deck / paper / policy → `Townhall` / `Deck` / `Paper` / `Policy`
- bigger technical task to figure out → `Deep work`

If none fit, use `Task`. Do not invent or create labels here; if a needed label
does not exist, use `Task` and say which label you would have used.

## Steps

1. **Classify** the item to a status and a label using the tables above. When
   genuinely torn between a reminder and a plain todo, ask one short question;
   otherwise pick.
2. **Parse a due date** for reminders ("tomorrow", "Fri", "3pm", "next week").
   Resolve to an absolute date using today's date from context. Reminders fire at
   day granularity, so record a time in the title if it matters.
3. **Write a clean title**: imperative, short, the "what". Keep the original
   phrasing and any source link (e.g. a Slack permalink from /pa:sweep) in
   the description.
4. **Create the issue** with `save_issue`: team = MDD (`LIST_TEAM_ID`), assignee =
   me, the chosen status and label, due date if a reminder. Leave priority unset
   unless urgency was stated.
5. **Confirm in one line**: what you added, its label and status, the due date if
   set, and the issue URL. Do not over-explain.

## Notes

- Batch input ("add these three: ...") creates one issue each; confirm as a short
  list.
- Only writes to the MDD team. Never touches other teams or projects.
