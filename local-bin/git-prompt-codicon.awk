# Reference:
# - https://git-scm.com/docs/git-status#_porcelain_format_version_2

BEGIN {
    branch = ""
    upstream = ""
    is_detached = 0
    ahead = 0
    behind = 0
    staged = 0
    unstaged = 0
    untracked = 0
    conflicted = 0
    stash = 0

    # ANSI Color Codes
    C_RESET = "\033[0m"
    C_OK = ""
    C_CHANGED = "\033[33m"
    C_STAGED = "\033[32m"
    C_BAD = "\033[31m"
    C_GRAY = "\033[90m"

    if (charset == "unicode") {
        ICON_BRANCH = "⎇ "
        ICON_TAG = "⚑ "
        ICON_MERGE = "⎇ "
        ICON_COMPARE = "⎇ "
        ICON_COMMIT = "● "
        ICON_AHEAD = "⇡"
        ICON_BEHIND = "⇣"
        ICON_STASH = "≡ "
        ICON_CONFLICT = "✖"
    } else if (charset == "nerdfont") {
        ICON_BRANCH = " "
        ICON_TAG = " "
        ICON_CHANGES = " "
        ICON_STAGED = " "
        ICON_CONFLICT_BRANCH = " "
        ICON_MERGE = " "
        ICON_COMPARE = " "
        ICON_COMMIT = " "
        ICON_AHEAD = ""
        ICON_BEHIND = ""
        ICON_STASH = " "
        ICON_CONFLICT = "✖"
    } else {
        ICON_BRANCH = ""
        ICON_TAG = "tag:"
        ICON_MERGE = ""
        ICON_COMPARE = ""
        ICON_COMMIT = ""
        ICON_AHEAD = ">"
        ICON_BEHIND = "<"
        ICON_STASH = "$ "
        ICON_CONFLICT = "x"
    }
}

$1 == "#" && $2 == "branch.oid" { oid = substr($3, 1, 7) }
$1 == "#" && $2 == "branch.head" { branch = $3; if (branch == "(detached)") is_detached = 1 }
$1 == "#" && $2 == "branch.upstream" { upstream = $3 }
$1 == "#" && $2 == "branch.ab" { ahead = substr($3, 2); behind = substr($4, 2) }
$1 == "#" && $2 == "stash" { stash = $3 + 0 }

$1 ~ /^[12]$/ {
    if (substr($2, 1, 1) != ".") staged++
    if (substr($2, 2, 1) != ".") unstaged++
}
$1 == "?" { untracked++ }
$1 == "u" { conflicted++ }

END {
    if (branch == "") exit

    if (op != "") {
        op = tolower(op)
    }

    if (is_detached) {
        if (op_branch != "") {
            branch = op_branch
        } else if (tag_name != "") {
            branch = tag_name
        } else {
            branch = (oid != "" && oid != "(initial)") ? "HEAD (" oid ")" : "HEAD"
        }
    }

    if (conflicted > 0) {
        branch_color = C_BAD
    } else if (unstaged > 0 || untracked > 0) {
        branch_color = C_CHANGED
    } else if (staged > 0) {
        branch_color = C_STAGED
    } else {
        branch_color = C_OK
    }

    if (conflicted > 0) {
        icon = (charset == "nerdfont") ? ICON_CONFLICT_BRANCH : ICON_MERGE
    } else if (is_detached && op == "") {
        icon = (tag_name != "") ? ICON_TAG : ICON_COMMIT
    } else if (ahead > 0 && behind > 0) {
        icon = ICON_COMPARE
    } else if (op != "") {
        icon = ICON_MERGE
    } else if (charset == "nerdfont") {
        if (unstaged > 0 || untracked > 0) {
            icon = ICON_CHANGES
        } else if (staged > 0) {
            icon = ICON_STAGED
        } else {
            icon = ICON_BRANCH
        }
    } else {
        icon = ICON_BRANCH
    }

    sep = (charset == "ascii") ? (C_GRAY " . " C_RESET) : (C_GRAY " · " C_RESET)

    branch_str = branch_color icon branch C_RESET
    if (op != "") {
        branch_str = branch_str sep C_CHANGED op C_RESET
    }

    status_str = ""

    if (upstream != "" || is_detached) {
        if (behind > 0) {
            status_str = (status_str == "" ? "" : status_str " ") C_BAD behind ICON_BEHIND C_RESET
        }
        if (ahead > 0) {
            status_str = (status_str == "" ? "" : status_str " ") C_STAGED ahead ICON_AHEAD C_RESET
        }
    }

    if (stash > 0) {
        status_str = (status_str == "" ? "" : status_str " ") C_GRAY ICON_STASH stash C_RESET
    }

    if (charset == "nerdfont") {
        if (staged > 0 && (unstaged > 0 || untracked > 0)) {
            status_str = (status_str == "" ? "" : status_str " ") C_OK "+" C_RESET
        }
    } else {
        flags = ""
        if (conflicted > 0) {
            flags = flags C_BAD ICON_CONFLICT C_RESET
        }
        if (staged > 0) {
            flags = flags C_OK "+" C_RESET
        }
        if (unstaged > 0) {
            flags = flags C_BAD "*" C_RESET
        }
        if (untracked > 0) {
            flags = flags C_BAD "?" C_RESET
        }

        if (flags != "") {
            status_str = (status_str == "" ? "" : status_str " ") flags
        }
    }

    if (status_str != "") {
        printf "%s%s%s", branch_str, sep, status_str
    } else {
        printf "%s", branch_str
    }
}
