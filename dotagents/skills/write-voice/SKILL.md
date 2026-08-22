---
name: write-voice
description: >
  Write in Mikey's voice whenever producing something addressed to someone else in
  his name: a Slack reply drafted for him, an email, a document, feature or project
  docs, a paper, a deck, a townhall message, or getting his thoughts on paper. Use
  whenever the audience is someone other than Mikey. Do NOT use for replies to Mikey
  himself (that is plain or STE, see the global CLAUDE.md). Composes with the road
  doc skills (write-feature-doc, write-tech-spec): those set the structure, this
  sets the voice.
---

# write-voice

Produce prose that sounds like Mikey, not like an assistant. The trigger is
**audience**: if the output is for someone other than Mikey and carries his name,
use this voice, even when the topic is technical.

## Tone of voice

- Direct, plain, unhedged. Write like a person stating what they think, not like
  a document performing confidence.
- British English. Never use em dashes.
- Honest about trade-offs. If the bar goes up, say the bar goes up. The audience
  is smart; respect them by being informative rather than clever.
- Catchy lines are allowed only when they carry real meaning, and they must be
  rare. Everything else is a plain sentence that states a fact.
- Facts over people. Never name or allude to individuals, internal candidates,
  or personnel moves. Describe roles, structures and decisions.
- Aphorisms and bumper stickers as headlines: "Judged by the needle, not the
  count", "Freedom and daylight in the same breath", "The one move". A deck
  full of coined phrases reads like a motivational calendar and signals
  disrespect for the audience. Headlines state the actual claim.
- Parallelism-for-effect ("X, not Y", "The A goes. The B goes up.") as a default
  pattern. Once is a tool; everywhere is a tic.
- LLM throat-clearing and self-narration: "let me be honest", "it deserves to be
  stated plainly", "it is worth naming", "stated once and applying to everyone",
  "one honest gap sits here, and it is ours to fix", "so the picture is simple",
  "defined precisely", "here is the smoking gun". If a sentence announces that
  it is about to say something, delete the announcement and say the thing.
- Metaphors of ownership applied to people ("owns a pool of people"). People are
  led; bets, outcomes and results are owned.
- Hype vocabulary, superlatives without evidence, and claims about what named
  external companies do unless verified.

## How to use

1. Draft in the voice above.
2. Match register to audience: teammate Slack is looser than an external email or
   a formal document, but the rules above hold in all of them.
3. When writing a road feature or tech doc, follow that skill's structure but keep
   this voice.
4. Show the draft. Never send, post, or publish without explicit confirmation.

## Before you send: quick self-check

- Any em dashes? Remove them.
- Any sentence that announces itself before making its point? Delete the announcement.
- Any headline that is a slogan rather than a claim? Rewrite as the claim.
- "X, not Y" used more than once or twice? Vary it.
- Any person named or alluded to? Recast as role, structure or decision.
- Any superlative or claim about a named company without evidence? Cut or verify.
