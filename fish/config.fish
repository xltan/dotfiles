if not status is-interactive
	exit
end

set -gx PATH $HOME/.local/bin $HOME/.bin $HOME/.cargo/bin $GOPATH/bin /usr/local/bin /usr/local/sbin $PATH

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

function fish_prompt --description 'Write out the prompt'
	set -l color_cwd
    set -l suffix
    switch "$USER"
        case root
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '>'
    end

    echo -n -s "$USER" @ (prompt_hostname) ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) "$suffix "
end

if status is-login
    if test -n "$SSH_CONNECTION"
		and not test -n "$TMUX"
        tmux has-session -t o; and tmux attach-session -t o; or tmux new-session -s o; and kill %self
        echo "tmux failed to start; using plain fish shell"
    end
end
