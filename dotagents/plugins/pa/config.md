# dotagents config

Workspace-specific values, referenced by the `pa-*` skills. Committed on purpose:
these are opaque IDs, not secrets or IP, and useless without my auth. **If I ever
move company or Linear workspace, change them here and everything follows.**
Anything genuinely secret stays out (see `.gitignore`: `*.secret`).

## The list (Linear)

My personal list is the **Mikeys Desk** team itself (no project). Items are issues,
categorised by label, moving through the team's statuses.

- `LIST_TEAM_ID`: `3f542a43-b941-4544-9ff8-1acd19ce9c37`   # Mikeys Desk
- `LIST_TEAM_KEY`: `MDD`
- Assignee for captured items: me (mikey@road.io)

Statuses (workflow states), with IDs for reliable transitions:
- `Icebox` — someday / not yet actionable — `4768ec75-aa8c-441a-ba26-15798a96c58d`
- `Next` — actionable, default for new todos — `92e46e1f-aa42-47b2-8b49-1fad39863cce`
- `In Progress` — doing — `15ecf931-6c40-46a0-9420-7660b695f03b`
- `Reminders` — time-based nudges (with a due date) — `d16993c3-e6b8-4d70-9352-3ed02f86626a`
- `Done` — completed — `c0cb50e5-0d33-43eb-8751-ab316aeae8c2`
- `Canceled` — `c4791c19-85f3-4d80-8c55-c6ac32c0ce7f`
- `Duplicate` — `fe1aefdc-4c18-4a6a-8fde-332effd5e343`

## The ERE board (Linear)

A separate team the sweep reads (never writes). The ERE board registers
third-party requests to reach charging data, one card per
`<provider> - <private label>` pairing. The full reconcile with card writes is the
`ere-board-sync` skill; the sweep only surfaces open cards that need me plus a
"may need a sync" flag.

- `ERE_TEAM_ID`: `20aebcef-216b-4210-8ce9-ae5c9cfbc82e`   # ERE
- `ERE_TEAM_KEY`: `ERE`

Status ladder (names drift, so match on meaning; happy path
`Initial Contact` → `Engaged` → `PL Approval Received` → `Credentials Shared` →
`Live`, plus off-path `Action needed`, `Blocked`, `Duplicate`, `Canceled`):
- **Needs my input** (surface first): `Action needed`; cards at
  `PL Approval Received` waiting on us to issue credentials; any card with an open
  defect reported by an integrator that needs my call.
- **Owned by others / lower**: legal or T&Cs approval, commercial `Blocked`
  items, steps sitting with the provider or another team. One quiet line.
- **Terminal** (never surface): `Live`, `Duplicate`, `Canceled`.

## Slack

- `SLACK_NOTIFY_CHANNEL`: `C0BK1KF8LCQ`   # my personal notification channel;
  Linear already posts some project updates here; pa-nudge/pa-brief post here too
- `SLACK_HANDLE`: `@mikey`   # used by pa-sweep to find mentions
- `CAPTURE_EMOJI`: `:ack:`   # react with this to flag a Slack message for capture

### Secret (never committed)
- `MAILCHECK_SLACK_BOT_TOKEN` — Slack bot token used by pa-sweep to post the
  digest AS THE BOT (so it notifies). Provided via environment / a gitignored
  `*.secret` file, never in this file. Posting via the Slack connector instead
  posts as me and is silent.

## Me

- Email: mikey@road.io   # for identifying my own work only
- Timezone: `Europe/London`   # resolve "today"/due dates against this
- Sweep schedule: `pa-sweep` runs 08:00 (open) and 18:00 (close), Mon-Fri, Europe/London
