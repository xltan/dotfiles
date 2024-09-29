set -gx QUIET_DIRENV_DET 1
set -gx EDITOR vi
set -gx GOPATH $HOME/tools/go
set -gx PYENV_ROOT $HOME/.pyenv
set -gx HOMEBREW_ROOT /opt/homebrew
set -gx BUN_INSTALL "$HOME/.bun"
set -gx DENO_INSTALL "$HOME/.deno"
set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .swap --exclude .undo'
set -gx FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
set -gx GPG_TTY (tty)
set -gx PYTHONPATH .


fish_add_path /usr/local/sbin $HOME/.duolingo/bin $HOME/.local/bin $HOME/.cargo/bin $HOME/.deno/bin $GOPATH/bin \
  $HOME/tools/flutter/bin $PYENV_ROOT/bin $HOMEBREW_ROOT/bin $HOMEBREW_ROOT/sbin \
  $BUN_INSTALL/bin $DENO_INSTALL/bin $HOME/.npm-global/node_modules/.bin

if not status is-interactive
  exit
end

function reorder-path
  set -f dot_paths
  set -f other_paths
  for dir in $PATH
      if string match -q '*.*' $dir
          set dot_paths $dot_paths $dir
      else
          set other_paths $other_paths $dir
      end
  end
  set -gx PATH .local/bin $dot_paths $other_paths
end

reorder-path

if not functions -q fisher
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

function ls --description 'List contents of directory'
  switch (uname)
    case Darwin
      command ls -G $argv
    case '*'
      command ls --color=auto $argv
  end
end

function fish_user_key_bindings
  bind \cz 'fg 2>/dev/null; commandline -f repaint'
	if functions -q fzf_key_bindings
		fzf_key_bindings
	end
end

alias page 'page -WfC -q 90000 -z 90000' # some sensible flags
set -gx PAGER page
set -gx DELTA_PAGER 'less -RFX'
set fish_greeting

test -d .venv/bin; and source .venv/bin/activate.fish
test -d .pyenv/bin; and source .pyenv/bin/activate.fish
type -q zoxide; and source (zoxide init fish | psub)
type -q fnm; and source (fnm env --use-on-cd | psub)

type -q direnv; and source (direnv hook fish | psub)
type -q pyenv; and source (pyenv init - | psub)

function mcd
  mkdir -pv "$argv"
  and cd "$argv"
end

function npmig
  # function to install npm packages to .npm-global
  cd $HOME/.npm-global
  npm install --save "$argv"
  cd -
end

abbr -a c cargo
abbr -a g git
abbr -a icat "kitten icat"
abbr -a lg "lazygit"
abbr -a gs "gh copilot suggest"
abbr -a ge "gh copilot explain"
abbr -a nr "npm run"

alias v 'nvim --listen $HOME/.config/nvim/pipe/$(basename $PWD)'
alias vim 'nvim --listen $HOME/.config/nvim/pipe/$(basename $PWD)'
alias mux 'tmux new -ADs scratch'
alias rgs 'rg --smart-case --hidden --no-heading --column'

alias ... 'cd ../..'
alias .... 'cd ../../..'

if status is-login
  set -gx MANPAGER "vi +Man!"
  if test -n "$SSH_CONNECTION"
    and not test -n "$TMUX"
    tmux has-session -t o; and tmux attach-session -t o; or tmux new-session -s o; and kill %self
    echo "tmux failed to start; using plain fish shell"
  end
end


alias assume="source (brew --prefix)/bin/assume.fish"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -f /Users/sinon/.pyenv/versions/anaconda3-2024.06-1/bin/conda
#     eval /Users/sinon/.pyenv/versions/anaconda3-2024.06-1/bin/conda "shell.fish" "hook" $argv | source
# else
#     if test -f "/Users/sinon/.pyenv/versions/anaconda3-2024.06-1/etc/fish/conf.d/conda.fish"
#         . "/Users/sinon/.pyenv/versions/anaconda3-2024.06-1/etc/fish/conf.d/conda.fish"
#     else
#         set -x PATH "/Users/sinon/.pyenv/versions/anaconda3-2024.06-1/bin" $PATH
#     end
# end
# <<< conda initialize <<<

