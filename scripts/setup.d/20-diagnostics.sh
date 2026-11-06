#!/bin/sh
#
# Reference: https://iterm2.com/
# Reference: https://github.com/ThomasDickey/xterm-snapshots
# Reference: https://github.com/robertknight/konsole
# Reference: https://github.com/ryanoasis/nerd-fonts

set -o nounset
set -o errexit

BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
readonly BASE_DIR

# shellcheck source=scripts/lib.sh
. "${BASE_DIR}/scripts/lib.sh"

readonly BIN_DIR="${HOME}/.local/bin"
readonly BOLD_ITALICS_URL="https://raw.githubusercontent.com/ThomasDickey/xterm-snapshots/master/vttests/bold-italics.pl"
readonly COLOR_256_URL="https://raw.githubusercontent.com/ThomasDickey/xterm-snapshots/master/vttests/256colors2.pl"
readonly COLOR_SPACES_URL="https://raw.githubusercontent.com/robertknight/konsole/master/tests/color-spaces.pl"
readonly IMGCAT_URL="https://iterm2.com/utilities/imgcat"
readonly IMGLS_URL="https://iterm2.com/utilities/imgls"
readonly OTHER_SGR_URL="https://raw.githubusercontent.com/ThomasDickey/xterm-snapshots/master/vttests/other-sgr.sh"
readonly QUERY_COLOR_URL="https://raw.githubusercontent.com/ThomasDickey/xterm-snapshots/master/vttests/query-color.pl"
readonly QUERY_DYNAMIC_URL="https://raw.githubusercontent.com/ThomasDickey/xterm-snapshots/master/vttests/query-dynamic.pl"
readonly QUERY_FONTS_URL="https://raw.githubusercontent.com/ThomasDickey/xterm-snapshots/master/vttests/query-fonts.pl"
readonly TEST_FONTS_URL="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/bin/scripts/test-fonts.sh"

download "${BOLD_ITALICS_URL}" "${BIN_DIR}/bold-italics" "+x"
download "${COLOR_256_URL}" "${BIN_DIR}/256colors2" "+x"
download "${COLOR_SPACES_URL}" "${BIN_DIR}/color-spaces" "+x"
download "${IMGCAT_URL}" "${BIN_DIR}/imgcat" "+x"
download "${IMGLS_URL}" "${BIN_DIR}/imgls" "+x"
download "${OTHER_SGR_URL}" "${BIN_DIR}/other-sgr" "+x"
download "${QUERY_COLOR_URL}" "${BIN_DIR}/query-color" "+x"
download "${QUERY_DYNAMIC_URL}" "${BIN_DIR}/query-dynamic" "+x"
download "${QUERY_FONTS_URL}" "${BIN_DIR}/query-fonts" "+x"
download "${TEST_FONTS_URL}" "${BIN_DIR}/test-fonts" "+x"
