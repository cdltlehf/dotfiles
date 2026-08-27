# Easier navigation
alias ..='command cd ..'
alias ...='command cd ../..'
alias ....='command cd ../../..'
alias .....='command cd ../../../..'

# Fool-proof aliases
alias rm='command rm -i'
alias mv='command mv -i'
alias cp='command cp -i'
alias ln='command ln -i'

# Colorize `ls`
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lha'

# Colorize `grep`
alias grep='command grep --color=auto'
alias egrep='command egrep --color=auto'
alias fgrep='command fgrep --color=auto'

# Freeze and unfreeze files
alias freeze='chmod a-w'
alias unfreeze='chmod a+w'

# cd
mkcd() {
	mkdir -p "$1" && cd "$1"
}

cdls() {
	cd "$1" && ls -lA
}

# third-party commands
command -v git >/dev/null 2>&1 && alias g='command git'
command -v bat >/dev/null 2>&1 && alias cat='command bat -pp'
if command -v lsd >/dev/null 2>&1; then
	if [ "${LC_TERMINAL_GLYPHS:-ascii}" = "ascii" ]; then
		alias ls='command lsd --icon never'
	else
		alias ls='command lsd'
	fi
fi

# open command
if ! command -v open >/dev/null 2>&1; then
	case $(uname) in
	MSYS*)
		alias open='command start'
		;;
	*) ;;
	esac
fi

if [ "${TERM_PROGRAM}" = "WezTerm" ]; then
	alias imgcat='wezterm imgcat'
fi

# Reload shell
alias reload='exec ${SHELL} --login'
