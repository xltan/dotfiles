if not status is-interactive
	exit
end

set -gx GOPATH $HOME/go
set -gx PATH $HOME/.local/bin $HOME/.cargo/bin $GOPATH/bin /usr/local/bin /usr/local/sbin $PATH
set -gx PATH $HOME/work/flutter/bin /usr/local/opt/python/libexec/bin $PATH
set -gx FZF_DEFAULT_COMMAND 'fd --type f --color=never'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d . --color=never'

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

if status is-login
    if test -n "$SSH_CONNECTION"
		and not test -n "$TMUX"
        tmux has-session -t o; and tmux attach-session -t o; or tmux new-session -s o; and kill %self
        echo "tmux failed to start; using plain fish shell"
    end
end

function fish_prompt --description 'Write out the prompt'
    set -l suffix
    switch "$USER"
        case root
            set suffix '# '
        case '*'
            set suffix '> '
    end

	if [ $status -eq 0 ]
		set suffix (prompt_pwd) $suffix
	else
		set suffix (set_color $fish_color_error) (prompt_pwd) $suffix
	end

    echo -n -s $suffix
end

function mcd
	mkdir -pv "$argv"
	and cd "$argv"
end

function tc
	cp -r ~/.template/conan "$argv"
	and cd "$argv"
end

function tm
	cp -r ~/.template/make "$argv"
	and cd "$argv"
end

function ls --description 'List contents of directory'
	switch (uname)
		case Darwin
			command ls -G $argv
		case '*'
			command ls --color=auto $argv
	end
end
