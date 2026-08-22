---
name: meeting-prep
description: >
  Produce a short pre-brief for a calendar meeting: attendees, the latest email
  and Slack thread with them, any linked agenda/doc, and last notes if recurring.
  Used by the morning sweep to enrich each of today's real meetings; can also be
  run on demand ("prep my next meeting"). Skips placeholder events.
---

# meeting-prep

Give Mikey, per meeting, the context he would otherwise dig for. Keep it tight:
this rides inside the morning digest, so 1 to 3 lines per meeting.

## Which events

Only real meetings. **Skip**: all-day events, birthdays and personal markers,
focus time, out-of-office, and blocks like "Blocked - No interviews". A meeting
with only Mikey and no others needs no brief.

## Per meeting, gather

1. **Attendees** — names; flag external domains (not road.io).
2. **Latest email thread** with those attendees or on the topic (Gmail search by
   attendee / subject) — one line on where it stands + `<...|Open>`.
3. **Latest Slack thread** with them or on the topic — one line + permalink.
4. **Agenda / doc** — from the event description or attachments — link.
5. **Last time** — if recurring, the previous instance's notes doc if present.

## Output

A compact block under the meeting in the digest's *Today* section:

```
• {HH:MM} {title} ({attendees}) <meet|Join>
   ↳ {one line on the latest email/Slack context} <...|Open> · doc <...|Open>
```

If there is no relevant context, just the meeting line, no `↳`. Never invent
context; only surface what you actually found.
