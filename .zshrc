# Initialization code that may require console input (password prompts, [y/n]
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export BUN_INSTALL="$HOME/.bun"

export TOMCAT_HOME=/usr/share/apache-tomcat-9.0.99/bin/

export MANPATH="~/texlive/2025/texmf-dist/doc/man"
export INFOPATH="~/texlive/2025/texmf-dist/doc/info"

export GEMINI_API_KEY=`pass gemini/api_key`
export OBSIDIAN_REST_API_KEY=`pass obsidian/rest_api/key`

path_aditions=(
    "~/.local/bin/"
    "/home/ivan/.local/share/bob/nvim-bin"
    "/usr/local/go/bin"
    "$BUN_INSTALL/bin:$PATH"
    "/home/ivan/texlive/2025/bin/x86_64-linux"
)
export PATH=$PATH:$(IFS=":";echo "${path_aditions[*]}")

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
    colorize
    command-not-found
    mvn
    fzf
    git
    rust
    sudo
    ubuntu
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# User config
source ~/.zsh/rc.zsh

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# bun completions
[ -s "/home/ivan/.bun/_bun" ] && source "/home/ivan/.bun/_bun"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    exec tmux
fi
