export VISUAL="nvim"
export SUDO_EDITOR="nvim"

export FZF_CTRL_COMMAND="$FZF_DEFAULT_COMMAND"
# For strudel
export CHROME_DEVEL_SANDBOX=/opt/google/chrome/chrome-sandbox

# Aliases
alias reload=omz\ reload
alias q=exit
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias rp=~/Repos/
# Better alternatives
alias ls=lsd

bindkey '^S' sudo-command-line

function tmux_vi_mode() {
    tmux copy-mode
}
zle -N tmux_vi_mode
bindkey -M viins '\e\e' tmux_vi_mode
bindkey -M vicmd '\e\e' tmux_vi_mode
bindkey '\e\e' tmux_vi_mode
bindkey '^[k' up-line-or-history
bindkey '^[j' down-line-or-history

# Drive sync
sync_drive () {
    cd ~/Drive && grive && cd ~-
}

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR="nvim"
fi

# for scala completion
fpath=(~/.zsh/completion $fpath)

autoload -Uz compinit
compinit
# compinit -C -d ~/.zsh/completion_cache

vi() {
    if [ "$1" = "-c" ]; then
        cd ~/.config/nvim/
        nvim .
        cd -
        return
    fi
    [ -z $1 ] && dir=. || dir=$1
    [ $# -gt 1 ] && shift
    nvim $dir "$@" || vi $dir "$@"
}

drive_sync() {
    mkdir -p ~/Drive
    cd ~/Drive/ || return # to avoid unlikely but unpleasant results
    grive || grive -a --id `pass grive/client_id` --secret `pass grive/secret`
    cd -
}

try () {
    cd ~/Repos/experiments/$1 >& /dev/null
    [ $? -eq 0 ] && return

    echo -n "No experiment dir \"$dir\", do you want to create one [Y/n] "
    read create
    [ -n "$create" ] && [ $create != "y" ] && return

    mkdir ~/Repos/experiments/$1
    cd ~/Repos/experiments/$1
}

_try_auto_complete() {
    local cur opts
    opts="$(find ~/Repos/experiments/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _try_auto_complete try
