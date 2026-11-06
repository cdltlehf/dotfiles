#!/bin/sh

set -o nounset
set -o errexit

BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
readonly BASE_DIR

# shellcheck source=scripts/lib.sh
. "${BASE_DIR}/scripts/lib.sh"

: "${XDG_CONFIG_HOME:="${HOME}/.config"}"

mkdir -p "${HOME}/.agents/skills"
symlink "${XDG_CONFIG_HOME}/agents/AGENTS.md" "${HOME}/.agents/AGENTS.md"

if command -v claude >/dev/null; then
  symlink "${HOME}/.agents/AGENTS.md" "${HOME}/.claude/CLAUDE.md"
fi

if command -v agy >/dev/null; then
  symlink "${HOME}/.agents/AGENTS.md" "${HOME}/.gemini/GEMINI.md"
  symlink "${HOME}/.agents/skills" "${HOME}/.gemini/antigravity-cli/skills"
fi

if command -v codex >/dev/null; then
  symlink "${HOME}/.agents/AGENTS.md" "${CODEX_HOME:-${HOME}/.codex}/AGENTS.md"
fi

if command -v pi >/dev/null; then
  mkdir -p "${HOME}/.pi/agent"
  symlink "${HOME}/.agents/AGENTS.md" "${HOME}/.pi/agent/AGENTS.md"
fi

"${BASE_DIR}/scripts/skills-install"
