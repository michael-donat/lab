#!/usr/bin/env bash
# Personal (dotagents) local setup.
#
# Skills now install via the Claude Code PLUGIN (pa@dotagents):
#   claude plugin marketplace add ~/Development/lab/dotagents
#   claude plugin install pa@dotagents
#
# This script only wires the personal global CLAUDE.md import (tone, STE, the
# list — plugins do not carry always-on context) and cleans up the legacy
# per-skill symlinks that predated the plugin. Idempotent.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"
CLAUDE_MD="${CLAUDE_DIR}/CLAUDE.md"
IMPORT_LINE="@${REPO_DIR}/CLAUDE.md"

# 1. Remove legacy skill symlinks (now provided by the pa@dotagents plugin).
for name in pa-capture pa-sweep pa-nudge write-voice; do
  link="${SKILLS_DIR}/${name}"
  if [ -L "${link}" ]; then rm "${link}"; echo "unlinked  ${name} (now from pa@dotagents)"; fi
done

# 2. Drop the stale engineering-ai file import (it is a plugin now).
touch "${CLAUDE_MD}"
if grep -q "engineering-ai/CLAUDE.md" "${CLAUDE_MD}"; then
  grep -v -e "engineering-ai/CLAUDE.md" -e "# Road.io Agents and Skills" "${CLAUDE_MD}" > "${CLAUDE_MD}.tmp"
  mv "${CLAUDE_MD}.tmp" "${CLAUDE_MD}"; echo "cleaned   removed engineering-ai import"
fi

# 3. Ensure the personal global CLAUDE.md import is present.
if grep -qF "${IMPORT_LINE}" "${CLAUDE_MD}"; then
  echo "import    already present in ${CLAUDE_MD}"
else
  { echo ""; echo "# Personal (dotagents)"; echo "${IMPORT_LINE}"; } >> "${CLAUDE_MD}"
  echo "import    added to ${CLAUDE_MD}"
fi

echo "done. Skills come from the pa@dotagents plugin — run 'claude plugin list' to verify."
