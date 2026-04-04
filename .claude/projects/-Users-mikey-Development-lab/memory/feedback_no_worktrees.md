---
name: No worktrees
description: User does not want Claude to use git worktrees; work directly in the main repo
type: feedback
---

Do not use git worktrees when making changes. Work directly in the main repository at /Users/mikey/Development/lab.

**Why:** User preference — worktrees add unnecessary complexity.

**How to apply:** Always read/write files at their primary path (e.g., /Users/mikey/Development/lab/kubernetes-manifests/...) rather than via a worktree path. Ignore the worktree working directory context.
