repo () { cd ~/Repos/$1 }

_repo_auto_complete() {
    local cur opts
    opts="$(find ~/Repos/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _repo_auto_complete repo

try () { cd ~/Repos/experiments/$1 }

_try_auto_complete() {
    local cur opts
    opts="$(find ~/Repos/experiments/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _try_auto_complete try
