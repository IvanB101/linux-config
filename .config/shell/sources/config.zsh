declare -A configs

configs=(
    nvim ~/.config/nvim
    tmux ~/.config/tmux/tmux.conf
    shell ~/.config/shell
    libreoffice ~/.config/libreoffice/4/user
)

conf() {
    local config
    if [[ "$1" = "-cd" ]]; then
        config=${configs[$2]}
        [ -z "$config" ] && echo "no config for: $2" >&2 && return 1
        if [ -d "$config" ]; then
            cd $config
        else
            cd `dirname $config`
        fi
    else
        config=${configs[$1]}
        [ -z $config ] && echo "no config for: $1" >&2 && return 1
        if [ -d "$config" ]; then
            cd "$config" && $EDITOR "." && cd -
        else
            $EDITOR "$config"
        fi
    fi
}

_config_auto_complete() {
    local cur opts
    opts=("${(@k)configs}")
    _describe "command" opts
}

compdef _config_auto_complete conf
