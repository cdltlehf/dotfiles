#!/bin/sh
#
# Reference: https://adr.github.io/madr/

set -o nounset
set -o errexit

BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
readonly BASE_DIR

# shellcheck source=scripts/lib.sh
. "${BASE_DIR}/scripts/lib.sh"

: "${XDG_CONFIG_HOME:="${HOME}/.config"}"
# shellcheck source=/dev/null
[ -f "${XDG_CONFIG_HOME}/user-dirs.dirs" ] && . "${XDG_CONFIG_HOME}/user-dirs.dirs"
: "${XDG_TEMPLATES_DIR:="${HOME}/Templates"}"
readonly HIDDEN_ALIAS_TEMPLATES="vale.ini"
readonly MADR_TEMPLATE_URL="https://raw.githubusercontent.com/adr/madr/4.0.0/template"
readonly MADR_FILES="0000-use-markdown-architectural-decision-records.md \
  adr-template-bare-minimal.md \
  adr-template-bare.md \
  adr-template-minimal.md \
  adr-template.md"

download "${MADR_TEMPLATE_URL}/.markdownlint.yml" "${BASE_DIR}/xdg-templates-dir/madr/docs/decisions/.markdownlint.yaml"
for file in ${MADR_FILES}; do
  download "${MADR_TEMPLATE_URL}/${file}" "${BASE_DIR}/xdg-templates-dir/madr/docs/decisions/${file}"
done
symlink "adr-template.md" "${BASE_DIR}/xdg-templates-dir/madr/docs/decisions/{}.md"
symlink "{}.h.tmpl" "${BASE_DIR}/xdg-templates-dir/c/include/{}.hpp.tmpl"

[ -L "${XDG_TEMPLATES_DIR}" ] && rm "${XDG_TEMPLATES_DIR}"
mkdir -p "${XDG_TEMPLATES_DIR}"
for item in "${BASE_DIR}/xdg-templates-dir"/*; do
  [ -e "${item}" ] || continue
  name="$(basename "${item}")"
  case "${name}" in
    dot_*) name=".${name#dot_}" ;;
    *) ;;
  esac
  symlink "${item}" "${XDG_TEMPLATES_DIR}/${name}"
  case " ${HIDDEN_ALIAS_TEMPLATES} " in
    *" ${name} "*) symlink "${item}" "${XDG_TEMPLATES_DIR}/.${name}" ;;
    *) ;;
  esac
done
