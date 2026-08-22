# dotagents

Personal Claude agent config, kept like dotfiles. Lives next to `../dotfiles`.

This is **mine**, deliberately separate from the department-wide `engineering-ai`
(`road-*`). It is a Claude Code **marketplace** (`dotagents`) that holds one
plugin per domain. Today that is **`pa`** (personal assistant); more (e.g.
`engineering`) will be sibling plugins.

## Layout

The marketplace manifest lives at the **lab repo root** so `michael-donat/lab`
resolves it directly (one manifest, no subfolder path):

```
lab/                                (repo root; also holds dotfiles, k8s, ...)
  .claude-plugin/marketplace.json   marketplace "dotagents" -> plugin pa
  .claude/settings.json             routine wiring (enables pa@dotagents)
  dotagents/
    CLAUDE.md                       personal always-on context (imported globally)
    tone-of-voice.md                universal voice; imported by CLAUDE.md
    install.sh                      wires the CLAUDE.md import; cleans legacy symlinks
    plugins/
      pa/
        .claude-plugin/plugin.json
        config.md                   IDs (team/statuses/labels), Slack channel, timezone
        skills/  capture/  sweep/  nudge/
      engineering/                  <- future sibling plugin
```

## Two layers

1. **Always-on personal context** (not a plugin): `CLAUDE.md` + `tone-of-voice.md`.
   These carry how Claude talks to me (plain, STE for engineering) and my writing
   voice. They load via a one-line import in `~/.claude/CLAUDE.md`, set by
   `install.sh`. Plugins do not carry always-on context, so this stays separate.
2. **Skills** (the plugin): `pa@dotagents`, invoked as `/pa:capture`, `/pa:sweep`,
   `/pa:nudge`.

## Install locally

```
/plugin marketplace add ~/Development/lab
/plugin install pa@dotagents
./install.sh          # adds the CLAUDE.md import, removes any legacy pa-* symlinks
```

On claude.ai (web/app), add the same marketplace under **Settings -> Plugins ->
Add -> Add marketplace** with repo `michael-donat/lab`, then enable `pa`.

## The tone of voice is universal, across surfaces

`tone-of-voice.md` is the single source. It is always-on in Claude Code via the
`CLAUDE.md` import. Because claude.ai and the Claude app cannot read local files,
paste the same file into **claude.ai → Settings → personal preferences** so the
voice applies there and in Claude voice too. Re-paste when it changes.

## Cloud routines

Scheduled routines (the morning/evening `sweep`) are **Claude Code** cloud
sessions, not claude.ai chats. They load skills from a cloned repo's
`.claude/settings.json`, not from `~/.claude/skills` and not from claude.ai
uploads. The wiring is in `../.claude/settings.json` (lab root): it registers the
`dotagents` marketplace (`github: michael-donat/lab`) and enables `pa@dotagents`.
A routine clones `lab`, enables the plugin, and its prompt invokes `/pa:sweep`.
Requires this repo to be pushed to the public `lab` remote.

## Config and secrets

`plugins/pa/config.md` holds workspace-specific IDs (committed on purpose, opaque,
not secret). The Slack bot token is a **secret**, provided via the routine
environment, never committed.
