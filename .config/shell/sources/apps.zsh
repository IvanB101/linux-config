home=/usr/share/apache-tomcat-9.0.99/bin/
tomcat() { $home/"$1".sh }

_tomcat_auto_complete() {
    local cur opts
    opts="$(find /usr/share/apache-tomcat-9.0.99/bin/ -type f -name "*.sh" | xargs -I {} basename {} .sh)"
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _tomcat_auto_complete tomcat

vim() { [ "$1" ] && nvim "$@" || nvim "." }

grive () { ~/Applications/grive2/build/grive/grive "$@" }

reload () { source ~/.zshrc }
