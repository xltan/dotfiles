# if status is-login; and not test -n "$TMUX"
#     tmux new -ADs scratch; and kill %self
#     echo "tmux failed to start; using plain fish shell"
# end
if status is-interactive; and set -q SSH_CONNECTION
    # Set TERM for SSH sessions
    if test "$TERM" != "xterm-256color"
        set -gx TERM xterm-256color
    end

    # Start tmux if not already inside
    if not set -q TMUX
        exec tmux new-session -A -s main
    end
end

set -gx QUIET_DIRENV_DET 1
set -gx EDITOR vi
set -gx GOPATH $HOME/tools/go
set -gx PYENV_ROOT $HOME/.pyenv
set -gx DENO_INSTALL "$HOME/.deno"

set -l os_name (uname)
set -l homebrew_paths
set -l os_paths

switch $os_name
    case Darwin
        set -gx HOMEBREW_ROOT /opt/homebrew
        set homebrew_paths $HOMEBREW_ROOT/bin $HOMEBREW_ROOT/sbin
        set -gx LANG en_US.UTF-8
        set -gx LC_ALL en_US.UTF-8
        set -gx CCACHE_DIR $HOME/Library/Caches/ccache
        set os_paths /Applications/Android\ Studio.app/Contents/MacOS \
            $HOME/.konan/kotlin-native-prebuilt-macos-aarch64-2.1.21/bin

        for candidate in $HOME/Library/Android/sdk $HOME/Android/Sdk
            if test -d $candidate
                set -gx ANDROID_HOME $candidate
                break
            end
        end
        set -q ANDROID_HOME; or set -gx ANDROID_HOME $HOME/Library/Android/sdk

        set -l macos_java_home /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
        test -d $macos_java_home; and set -gx JAVA_HOME $macos_java_home

    case Linux
        set -q LANG; or set -gx LANG C.UTF-8
        set -q LC_ALL; or set -gx LC_ALL $LANG
        set -gx CCACHE_DIR $HOME/.cache/ccache

        for candidate in $HOME/Android/Sdk $HOME/Library/Android/sdk
            if test -d $candidate
                set -gx ANDROID_HOME $candidate
                break
            end
        end
        set -q ANDROID_HOME; or set -gx ANDROID_HOME $HOME/Android/Sdk

        switch (uname -m)
            case arm64 aarch64
                set os_paths $HOME/.konan/kotlin-native-prebuilt-linux-aarch64-2.1.21/bin
            case '*'
                set os_paths $HOME/.konan/kotlin-native-prebuilt-linux-x86_64-2.1.21/bin
        end

        if not set -q JAVA_HOME; and type -q javac; and type -q readlink
            set -l javac_path (readlink -f (command -s javac))
            set -gx JAVA_HOME (dirname (dirname $javac_path))
        end
end

set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .swap --exclude .undo'
set -gx FZF_CTRL_T_COMMAND "command find -L \$dir -type f 2> /dev/null | sed '1d; s#^\./##'"
set -gx GPG_TTY (tty)
set -gx PYTHONPATH .
set -gx MANPAGER "vi +Man!"
set -gx ANDROID_SDK_ROOT $ANDROID_HOME
set -gx ANDROID_AVD_HOME $HOME/.android/avd
# set -gx CC "/opt/homebrew/bin/ccache clang"
# set -gx CXX "/opt/homebrew/bin/ccache clang++"

fish_add_path /usr/local/sbin $HOME/.duolingo/bin $HOME/.local/bin $HOME/.cargo/bin $HOME/.deno/bin $GOPATH/bin \
    $HOME/tools/flutter/bin $PYENV_ROOT/bin $homebrew_paths \
    $DENO_INSTALL/bin $HOME/.npm-global/node_modules/.bin \
    $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/emulator \
    $os_paths $HOME/.bunv/bin $HOME/.bun/bin $HOME/.pub-cache/bin

type -q brew; and eval "$(brew shellenv)"

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

# alias page 'page -WfC -q 90000 -z 90000' # some sensible flags
# set -gx PAGER page
set -gx DELTA_PAGER 'less -RFX'
set fish_greeting

test -d .venv/bin; and source .venv/bin/activate.fish
test -d .pyenv/bin; and source .pyenv/bin/activate.fish
type -q zoxide; and source (zoxide init fish | psub)
type -q fnm; and source (fnm env --use-on-cd --shell fish | psub)
type -q fzf; and source (fzf --fish | psub)

type -q direnv; and source (direnv hook fish | psub)
type -q pyenv; and source (pyenv init - | psub)
type -q rbenv; and source (rbenv init - | psub)

function mcd
    mkdir -pv "$argv"
    and cd "$argv"
end

function npmig
    # function to install npm packages to .npm-global
    if not type -q npm
        echo "npm not found"
        return 127
    end

    cd $HOME/.npm-global
    and command npm install --save $argv
    cd -
end

abbr -a c cursor
abbr -a ca cargo
abbr -a b bun
abbr -a n npm
abbr -a nr "npm run"
abbr -a g git
abbr -a icat "kitten icat"
abbr -a lg lazygit
abbr -a gs "gh copilot suggest"
abbr -a ge "gh copilot explain"
abbr -a cc claude
abbr -a ccd claude --dangerously-skip-permissions

alias vim 'nvim --listen $HOME/.config/nvim/pipe/$(basename $PWD)'
alias mux 'tmux new -ADs scratch'
alias rgs 'rg --smart-case --hidden --no-heading --column'
alias ... 'cd ../..'
alias .... 'cd ../../..'
if type -q brew
    set -l assume_fish (brew --prefix)/bin/assume.fish
    test -f $assume_fish; and alias assume "source $assume_fish"
end
