#!/usr/bin/env bash
# Install personal (pa-*) skills and wire the global CLAUDE.md import.
# Idempotent: safe to re-run after adding skills.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
SKILLS_DIR="${CLAUDE_DIR}/skills"
CLAUDE_MD="${CLAUDE_DIR}/CLAUDE.md"
IMPORT_LINE="@${REPO_DIR}/CLAUDE.md"

mkdir -p "${SKILLS_DIR}"

# 1. Symlink each skill dir into ~/.claude/skills/
for skill in "${REPO_DIR}"/skills/*/; do
  [ -d "${skill}" ] || continue
  name="$(basename "${skill}")"
  target="${SKILLS_DIR}/${name}"
  if [ -L "${target}" ]; then
    ln -sfn "${skill%/}" "${target}"; echo "relinked  ${name}"
  elif [ -e "${target}" ]; then
    echo "SKIP      ${name} (real file/dir already at ${target}, not a symlink)"
  else
    ln -s "${skill%/}" "${target}"; echo "linked    ${name}"
  fi
done

# 2. Clean up: engineering-ai is a plugin now, so drop its file import.
touch "${CLAUDE_MD}"
if grep -q "engineering-ai/CLAUDE.md" "${CLAUDE_MD}"; then
  grep -v -e "engineering-ai/CLAUDE.md" -e "# Road.io Agents and Skills" "${CLAUDE_MD}" > "${CLAUDE_MD}.tmp"
  mv "${CLAUDE_MD}.tmp" "${CLAUDE_MD}"
  echo "cleaned   removed engineering-ai import (now a plugin)"
fi

# 3. Ensure the global CLAUDE.md imports this repo's personal CLAUDE.md.
if grep -qF "${IMPORT_LINE}" "${CLAUDE_MD}"; then
  echo "import    already present in ${CLAUDE_MD}"
else
  { echo ""; echo "# Personal (dotagents)"; echo "${IMPORT_LINE}"; } >> "${CLAUDE_MD}"
  echo "import    added to ${CLAUDE_MD}"
fi

echo "done."
