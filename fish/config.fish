if not status is-interactive
	exit
end

set -gx LANG "en_US.UTF-8"
set -gx RUSTC_WRAPPER $HOME/.cargo/bin/sccache
set -gx GOPATH $HOME/go
set -gx PATH $fish_user_paths /usr/local/bin /usr/bin /bin /usr/sbin /sbin /Library/Apple/usr/bin /Library/Apple/bin /Library/TeX/texbin
set -gx PATH $HOME/.local/bin $HOME/.cargo/bin $GOPATH/bin /usr/local/sbin $PATH
set -gx PATH /usr/local/opt/ccache/libexec $HOME/work/vcpkg $HOME/work/flutter/bin /usr/local/opt/python/libexec/bin $PATH

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

set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1

set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""

set -g __fish_git_prompt_char_stagedstate "●"
set -g __fish_git_prompt_char_dirtystate "✚"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_conflictedstate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"

set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green

function fish_prompt --description 'Write out the prompt'
	set last_status $status

	set_color $fish_color_cwd
	printf '%s' (prompt_pwd)

	set_color normal
	printf '%s\n' (__fish_git_prompt)
	set_color normal

    switch "$USER"
        case root
            printf '# '
        case '*'
            printf '> '
    end
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

function tv
	cp -r ~/.template/vcpkg "$argv"
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
