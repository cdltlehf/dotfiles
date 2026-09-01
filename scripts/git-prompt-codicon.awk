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
    stash = 0

    # ANSI Color Codes (Modus Vivendi Semantics)
    C_RESET   = "\033[0m"
    C_OK      = ""            # Default Foreground (fg-main: Clean / Inactive)
    C_CHANGED = "\033[33m"    # Yellow (vc-changed: Modified / Unstaged)
    C_STAGED  = "\033[32m"    # Green (vc-added: Staged / Ahead)
    C_BAD     = "\033[31m"    # Red (vc-conflict / vc-removed: Conflict / Behind / Error)
    C_GRAY    = "\033[90m"    # Dim Gray (fg-dim: Metadata / Stash)

    # Symbol table configuration based on charset ("nerdfont", "unicode", "ascii")
    if (charset == "unicode") {
        ICON_BRANCH  = "⎇ "
        ICON_TAG     = "⚑ "
        ICON_MERGE   = "⎇ "
        ICON_COMPARE = "⎇ "
        ICON_COMMIT  = "● "
        ICON_AHEAD   = "⇡"
        ICON_BEHIND  = "⇣"
        ICON_STASH   = "≡ "
        ICON_CONFLICT= "✖"
    } else if (charset == "nerdfont") {
        ICON_BRANCH          = " "  # nf-cod-git_branch (\uec6f)
        ICON_TAG             = " "  # nf-cod-tag (\uea66)
        ICON_CHANGES         = " "  # nf-cod-git_branch_changes (\uec6c)
        ICON_STAGED          = " "  # nf-cod-git_branch_staged_changes (\uec6d)
        ICON_CONFLICT_BRANCH = " "  # nf-cod-git_branch_conflicts (\uec6e)
        ICON_MERGE           = " "  # nf-cod-git_merge (\ueafe)
        ICON_COMPARE         = " "  # nf-cod-git_compare (\ueafd)
        ICON_COMMIT          = " "  # nf-cod-git_commit (\ueafc)
        ICON_AHEAD           = ""  # nf-cod-arrow_up (\ueaa1)
        ICON_BEHIND          = ""  # nf-cod-arrow_down (\uea9a)
        ICON_STASH           = " "  # nf-cod-git_stash (\uec26)
        ICON_CONFLICT        = "✖"
    } else {
        # Pure ASCII (default fallback)
        ICON_BRANCH  = ""
        ICON_TAG     = "tag:"
        ICON_MERGE   = ""
        ICON_COMPARE = ""
        ICON_COMMIT  = ""
        ICON_AHEAD   = ">"
        ICON_BEHIND  = "<"
        ICON_STASH   = "$ "
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
$1 == "#" && $2 == "stash" { stash = $3 + 0 }

END {
    if (branch == "") exit

    if (is_detached) {
        if (op_branch != "") {
            branch = op_branch
        } else if (tag_name != "") {
            branch = tag_name
        } else {
            branch = (oid != "" && oid != "(initial)") ? "HEAD (" oid ")" : "HEAD"
        }
    }

    if (op != "") {
        branch = branch op
    }

    # Select appropriate branch icon and branch color (Modus Vivendi semantics)
    if (conflicted > 0) {
        branch_color = C_BAD
        icon = (charset == "nerdfont") ? ICON_CONFLICT_BRANCH : ICON_MERGE
    } else if (is_detached && op == "") {
        if (tag_name != "") {
            if (unstaged > 0 || untracked > 0) {
                branch_color = C_CHANGED
            } else if (staged > 0) {
                branch_color = C_STAGED
            } else {
                branch_color = C_OK
            }
            icon = ICON_TAG
        } else {
            branch_color = (unstaged > 0 || untracked > 0) ? C_CHANGED : (staged > 0 ? C_STAGED : C_OK)
            icon = ICON_COMMIT
        }
    } else if (ahead > 0 && behind > 0) {
        branch_color = (unstaged > 0 || untracked > 0) ? C_CHANGED : (staged > 0 ? C_STAGED : C_OK)
        icon = ICON_COMPARE
    } else if (charset == "nerdfont") {
        if (unstaged > 0 || untracked > 0) {
            branch_color = C_CHANGED
            icon = ICON_CHANGES
        } else if (staged > 0) {
            branch_color = C_STAGED
            icon = ICON_STAGED
        } else if (op != "") {
            branch_color = C_OK
            icon = ICON_MERGE
        } else {
            branch_color = C_OK
            icon = ICON_BRANCH
        }
    } else {
        if (unstaged > 0 || untracked > 0) {
            branch_color = C_CHANGED
        } else if (staged > 0) {
            branch_color = C_STAGED
        } else {
            branch_color = C_OK
        }
        icon = ICON_BRANCH
    }

    branch_str = branch_color icon branch C_RESET

    status_str = ""

    # Upstream and Sync status (Ahead: Green, Behind: Red)
    if (upstream != "" || is_detached) {
        if (behind > 0) status_str = (status_str == "" ? "" : status_str " ") C_BAD behind ICON_BEHIND C_RESET
        if (ahead > 0)  status_str = (status_str == "" ? "" : status_str " ") C_STAGED ahead ICON_AHEAD C_RESET
    }

    # Stash status (Modus fg-dim: Dim Gray)
    if (stash > 0) {
        status_str = (status_str == "" ? "" : status_str " ") C_GRAY ICON_STASH stash C_RESET
    }

    # Working tree status flags
    if (charset == "nerdfont") {
        # When both staged and unstaged/untracked exist, indicate staged items with green '+'
        if (staged > 0 && (unstaged > 0 || untracked > 0)) {
            status_str = (status_str == "" ? "" : status_str " ") C_OK "+" C_RESET
        }
    } else {
        flags = ""
        if (conflicted > 0) flags = flags C_BAD ICON_CONFLICT C_RESET
        if (staged > 0)     flags = flags C_OK "+" C_RESET
        if (unstaged > 0)   flags = flags C_BAD "*" C_RESET
        if (untracked > 0)  flags = flags C_BAD "?" C_RESET

        if (flags != "") {
            status_str = (status_str == "" ? "" : status_str " ") flags
        }
    }

    sep = (charset == "ascii") ? (C_GRAY " . " C_RESET) : (C_GRAY " · " C_RESET)

    if (status_str != "") {
        printf "%s%s%s", branch_str, sep, status_str
    } else {
        printf "%s", branch_str
    }
}
