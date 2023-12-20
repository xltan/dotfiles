# .bashrc for OS X and Ubuntu
# ====================================================================

# System default
# --------------------------------------------------------------------
export BASH_SILENCE_DEPRECATION_WARNING=1
[[ $- != *i* ]] && return

export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

# Options
# --------------------------------------------------------------------

### Bash completion
[ -f /etc/bash_completion ] && . /etc/bash_completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

### Disable CTRL-S and CTRL-Q
stty -ixon && bind '\C-w:backward-kill-word'

# Environment variables
# --------------------------------------------------------------------

### Append to the history file
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
export HISTSIZE=1000
export HISTFILESIZE=

### man bash
export HISTIGNORE='fg'

### Global
export GOPATH="$HOME/tools/go"
if [ -z "$PATH_EXPANDED" ]; then
	export PATH="$HOME/.local/bin:$HOME/.bin:$HOME/.cargo/bin:$GOPATH/bin:/usr/local/bin:/usr/local/sbin:$PATH"
	export LESS='-F -X -R '$LESS
	export PATH_EXPANDED=1
fi
export EDITOR=vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

### OS X
export COPYFILE_DISABLE=true

if [ -x /usr/bin/dircolors ]; then
	eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
elif [ "$PLATFORM" = Darwin ]; then
	alias ls='ls -G'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias l='ls -alF'
alias ll='ls -l'
alias cdpath="export CDPATH=.:$PWD"

# Prompt
# --------------------------------------------------------------------
if [ -n "$SSH_CONNECTION" ]; then
	PS1="\h:\w> "
else
	PS1="\w> "
fi

# Shortcut functions
# --------------------------------------------------------------------

mvim() {
	if [ -n "$1" ]; then
		command mvim --remote-silent "$@"
	elif [ -n "$(command mvim --serverlist)" ]; then
		command mvim --remote-send ":call foreground()<CR>:enew<CR>:<BS>"
	else
		command mvim
	fi
}

viw() {
	vim "$(which "$1")"
}

# fzf (https://github.com/junegunn/fzf)
# --------------------------------------------------------------------
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"
export FZF_DEFAULT_OPTS="--no-bold"

# v - open files in ~/.viminfo
v() {
	local files
	files=$(grep '^>' ~/.viminfo | cut -c3- |
		while read line; do
			[ -f "${line/\~/$HOME}" ] && echo "$line"
		done | fzf -d -m -q "$*" -1) && vim ${files//\~/$HOME}
}


unalias z 2>/dev/null
z() {
	[ $# -gt 0 ] && _z "$*" && return
	cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# fzf end
# --------------------------------------------------------------------

TMUX_SESSION=$USER
if [[ -n "$BASHRC_TMUX_SESSION" ]]; then
	TMUX_SESSION="$TMUX_SESSION-$BASHRC_TMUX_SESSION"
fi

if [[ -z "$TMUX" && -n "$SSH_TTY" ]] && which tmux >&/dev/null; then
	if ! tmux ls -F '#{session_name}' | egrep -q "^$TMUX_SESSION$"; then
		tmux new-session -s $TMUX_SESSION \; detach
	fi
	session_max=$(tmux ls -F '#{session_name}' |
		egrep "^$TMUX_SESSION-[0-9]+$" |
		sed "s/^$TMUX_SESSION-//" |
		sort -rn |
		head -n1)
	session_index=$((${session_max:--1} + 1))
	exec tmux new-session -s $TMUX_SESSION-$session_index -t $TMUX_SESSION
fi

[ -f ~/.bashrc.local ] && source ~/.bashrc.local

extract() {
	if [ -f $1 ]; then
		case $1 in
		*.tar.bz2) tar xvjf $1 ;;
		*.tar.gz) tar xvzf $1 ;;
		*.tar.xz) tar xvf $1 ;;
		*.bz2) bunzip2 $1 ;;
		*.rar) unrar x $1 ;;
		*.gz) gunzip $1 ;;
		*.tar) tar xvf $1 ;;
		*.tbz2) tar xvjf $1 ;;
		*.tgz) tar xvzf $1 ;;
		*.zip) unzip $1 ;;
		*.Z) uncompress $1 ;;
		*.7z) 7z x $1 ;;
		*) echo "I don't know how to extract '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}

mcd() { mkdir -p "$@" && eval cd "\"\$$#\""; }
. "$HOME/.cargo/env"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
