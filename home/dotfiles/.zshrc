# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# Path and aliases
export PATH=$PATH:/usr/local/go/bin

export PATH=$PATH:/home/will/.cargo/bin
alias gst='git status'
alias vi='nvim'
alias gc='git commit'
alias co='git checkout'
alias gaa='git add -A'
alias gd='git diff'
alias gdc='git diff --cached'

alias gw="cd ~/go/src/github.com/will-x86/"
alias nd="nix develop -c $SHELL"
alias ls='ls --color'
alias vim='nvim'
alias c='clear'

# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load Powerlevel10k theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

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

# Powerlevel10k configuration
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
zinit wait lucid for \
    atload"bindkey '^f' autosuggest-accept; \
           bindkey '^p' history-search-backward; \
           bindkey '^n' history-search-forward; \
           bindkey '^[w' kill-region; \
           bindkey '^b' backward-word" \
    zdharma-continuum/null

#bindkey '^f' autosuggest-accept
#bindkey '^p' history-search-backward
#bindkey '^n' history-search-forward
#bindkey '^[w' kill-region

# History settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory histignorespace histsavenodups histfindnodups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# Deferred loading of shell integrations
eval "$(direnv hook zsh)"  # Uncomment if you use direnv
{
  eval "$(fzf --zsh)"
  eval "$(zoxide init --cmd cd zsh)"
} &!
