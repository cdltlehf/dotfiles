# scripts/git-prompt-codicon.awk
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

    # ANSI Color Codes (based on git-prompt.sh canonical standards)
    C_RESET  = "\033[0m"
    C_OK     = "\033[32m"    # Green (Clean tracked branch, Staged, Ahead)
    C_BAD    = "\033[31m"    # Red (Detached, Dirty/Unstaged, Untracked, Behind, Conflict)
    C_CYAN   = "\033[36m"    # Cyan (Clean local-only untracked branch)
    C_GRAY   = "\033[90m"    # Dim / Gray

    # Symbol table configuration based on charset ("nerdfont", "unicode", "ascii")
    if (charset == "unicode") {
        ICON_BRANCH  = "⎇ "
        ICON_MERGE   = "⎇ "
        ICON_COMPARE = "⎇ "
        ICON_COMMIT  = "● "
        ICON_AHEAD   = "↑"
        ICON_BEHIND  = "↓"
        ICON_CONFLICT= "✖"
    } else if (charset == "nerdfont") {
        ICON_BRANCH          = " "  # git-branch (\uec6f)
        ICON_CHANGES         = " "  # git-branch-changes (\uec6c)
        ICON_STAGED          = " "  # git-branch-staged-changes (\uec6d)
        ICON_CONFLICT_BRANCH = " "  # git-branch-conflicts (\uec6e)
        ICON_MERGE           = " "  # git-merge (\uea69)
        ICON_COMPARE         = " "  # git-compare (\uea66)
        ICON_COMMIT          = " "  # git-commit (\ueafc)
        ICON_AHEAD           = ""  # arrow-up (\ueaa1)
        ICON_BEHIND          = ""  # arrow-down (\ueaa0)
        ICON_CONFLICT        = "✖"
    } else {
        # Pure ASCII (default fallback)
        ICON_BRANCH  = ""
        ICON_MERGE   = ""
        ICON_COMPARE = ""
        ICON_COMMIT  = ""
        ICON_AHEAD   = ">"
        ICON_BEHIND  = "<"
        ICON_CONFLICT= "x"
    }
}

# Branch and HEAD status
$1 == "#" && $2 == "branch.oid" {
    oid = substr($3, 1, 7)
}
$1 == "#" && $2 == "branch.head" {
    branch = $3
    if (branch == "(detached)") {
        is_detached = 1
    }
}
$1 == "#" && $2 == "branch.upstream" {
    upstream = $3
}
$1 == "#" && $2 == "branch.ab" {
    ahead = substr($3, 2)
    behind = substr($4, 2)
}

# Staged / Unstaged changes
$1 ~ /^[12]$/ {
    if (substr($2, 1, 1) != ".") staged++
    if (substr($2, 2, 1) != ".") unstaged++
}
$1 == "?" { untracked++ }
$1 == "u" { conflicted++ }

END {
    if (branch == "") exit

    if (is_detached) {
        branch = (oid != "" && oid != "(initial)") ? "HEAD (" oid ")" : "HEAD"
    }

    # Select appropriate branch icon and branch color
    if (conflicted > 0) {
        branch_color = C_BAD
        icon = (charset == "nerdfont") ? ICON_CONFLICT_BRANCH : ICON_MERGE
    } else if (is_detached) {
        branch_color = C_BAD
        icon = ICON_COMMIT
    } else if (ahead > 0 && behind > 0) {
        branch_color = C_OK
        icon = ICON_COMPARE
    } else if (charset == "nerdfont") {
        if (unstaged > 0 || untracked > 0) {
            branch_color = C_BAD
            icon = ICON_CHANGES
        } else if (staged > 0) {
            branch_color = C_OK
            icon = ICON_STAGED
        } else {
            branch_color = (upstream == "") ? C_CYAN : C_OK
            icon = ICON_BRANCH
        }
    } else {
        if (unstaged > 0 || untracked > 0) {
            branch_color = C_BAD
        } else {
            branch_color = (upstream == "") ? C_CYAN : C_OK
        }
        icon = ICON_BRANCH
    }

    res = branch_color icon branch C_RESET

    # Upstream and Sync status (VS Code format: 1 2)
    if (upstream != "" || is_detached) {
        if (ahead > 0)  res = res " " C_OK ahead ICON_AHEAD C_RESET
        if (behind > 0) res = res " " C_BAD behind ICON_BEHIND C_RESET
    }

    # Working tree status flags
    if (charset == "nerdfont") {
        # When both staged and unstaged/untracked exist, indicate staged items with green '+'
        if (staged > 0 && (unstaged > 0 || untracked > 0)) {
            res = res " " C_OK "+" C_RESET
        }
    } else {
        flags = ""
        if (conflicted > 0) flags = flags C_BAD ICON_CONFLICT C_RESET
        if (staged > 0)     flags = flags C_OK "+" C_RESET
        if (unstaged > 0)   flags = flags C_BAD "*" C_RESET
        if (untracked > 0)  flags = flags C_BAD "?" C_RESET

        if (flags != "") {
            res = res " " flags
        }
    }

    printf "%s", res
}
