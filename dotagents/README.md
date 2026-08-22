# dotagents

Personal Claude agent config, kept like dotfiles. Lives next to `../dotfiles`.

This is **mine**, deliberately separate from the department-wide `engineering-ai`
skill set (`road-*`). It ships as a Claude Code **plugin** named `pa` (personal
assistant), in a single-plugin marketplace also called `dotagents`.

## What it is

A lightweight PA built on Claude Code + the MCPs already on my account
(Linear, Gmail, Slack, Google Calendar). No new infra: skills + scheduled
cloud routines.

- **Store:** the private Linear team **Mikeys Desk** (`MDD`), items as issues,
  categorised by label, moving through statuses. Reminders use due dates.
- **Capture in:** `pa-capture` (single item), and `pa-sweep` (email/Slack sweep).
- **Surface out:** `pa-sweep` posts a morning + evening digest to my md-notes
  Slack channel; `pa-nudge` covers ad-hoc "what's due".
- **Write as me:** `write-voice` for anything addressed to someone else.

## Layout

```
dotagents/
  .claude-plugin/
    marketplace.json   marketplace "dotagents", listing the pa plugin
    plugin.json        plugin "pa" (skills auto-discovered from ./skills)
  skills/
    pa-capture/  pa-sweep/  pa-nudge/  write-voice/
  CLAUDE.md            personal global context (tone, STE, the list)
  config.md            IDs (team/statuses/labels), Slack channel, timezone
  install.sh           wires the CLAUDE.md import (+ legacy skill symlinks)
```

## Install locally (plugin)

```
/plugin marketplace add ~/Development/lab/dotagents
/plugin install pa@dotagents
```

Skills then appear as `/pa:pa-capture`, `/pa:pa-sweep`, etc. After installing the
plugin, remove the legacy symlinks so skills are not registered twice:

```
rm ~/.claude/skills/pa-capture ~/.claude/skills/pa-sweep ~/.claude/skills/pa-nudge ~/.claude/skills/write-voice
```

**Still run `./install.sh`** for the one thing the plugin does not carry: the
personal global `CLAUDE.md` import into `~/.claude/CLAUDE.md` (tone, STE, the
list). Plugins deliver skills, not always-on context.

## Cloud routines

Scheduled routines (the morning/evening `pa-sweep`) are **Claude Code** cloud
sessions, not claude.ai chats, so they load skills from a cloned repo's
`.claude/settings.json`, not from `~/.claude/skills` and not from claude.ai
uploads. The wiring lives in `../.claude/settings.json` (lab root): it registers
the `dotagents` marketplace (git-subdir of this public repo) and enables
`pa@dotagents`. A routine clones `lab`, enables the plugin, and its prompt just
invokes `/pa:pa-sweep`.

**This requires `dotagents` to be pushed to the public `lab` repo.** Until then,
the marketplace source cannot resolve.

## Config

`config.md` holds workspace-specific IDs (committed on purpose, opaque, not
secret). The Slack bot token is a **secret**, provided via the routine
environment, never committed.
