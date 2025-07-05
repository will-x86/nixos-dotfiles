# Path and aliases
export PATH=$PATH:/usr/local/go/bin

export PATH=$PATH:/home/will/.cargo/bin

#alias ls='ls --color'
alias vim='nvim'
alias vi='nvim'

# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
#zinit light starship/starship
bindkey -s ^f "~/tmux-sessioniser\n"


# Load plugins
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

zinit light Aloxaf/fzf-tab

# Load OMZ plugins
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Keybindings
zinit wait lucid for \
    atload"bindkey '^ ' autosuggest-accept; \
           bindkey '^p' history-search-backward; \
           bindkey '^n' history-search-forward; \
           bindkey '^[w' kill-region; \
           bindkey '^b' backward-word" \
    zdharma-continuum/null


# History settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory histignorespace histsavenodups histfindnodups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# Deferred loading of shell integrations
eval "$(direnv hook zsh)"  # Uncomment if you use direnv
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
