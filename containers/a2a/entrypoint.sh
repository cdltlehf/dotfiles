#!/usr/bin/env bash
# Renders the agent cards with this deployment's public URL, then starts ADK.
set -euo pipefail

: "${PUBLIC_URL:?PUBLIC_URL is required}"

source_dir=/app/agents-src
target_dir=/app/agents

rm -rf "${target_dir}"
cp -R "${source_dir}" "${target_dir}"

# Bash 5.2 expands `&` in replacements; a URL may contain one.
shopt -u patsub_replacement 2>/dev/null || true
placeholder="\${PUBLIC_URL}"
for file in "${target_dir}"/*/agent.json; do
  [[ -f ${file} ]] || continue
  content=$(<"${file}")
  content=${content//"${placeholder}"/${PUBLIC_URL}}
  printf '%s\n' "${content}" >"${file}"
done

exec adk web --host 0.0.0.0 --port 8000 --a2a "$@"
