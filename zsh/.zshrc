# ~/.zshrc — managed via stow (github.com/Alekzanther/dotfiles)
#
# Base: CachyOS's system zsh config. It provides oh-my-zsh, Powerlevel10k
# (+ instant prompt), the fish-like plugins (syntax-highlighting,
# autosuggestions, history-substring-search), the command-not-found handler,
# and the Arch/pacman aliases. Everything below layers my personal setup on top.
#
# Console-input code (password prompts, [y/n]) must stay ABOVE the CachyOS
# source line, because that file starts the p10k instant prompt.

# Extra oh-my-zsh plugins. Set before CachyOS sources OMZ (it only defaults
# these when unset). No output here, so it's safe above the instant prompt.
plugins=(git docker docker-compose node npm rust cp sudo systemd)

# --- CachyOS base (instant prompt, OMZ, p10k, fish-like plugins, arch aliases) ---
[ -f /usr/share/cachyos-zsh-config/cachyos-config.zsh ] && \
  source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# --- PATH ---
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"
export PATH="$HOME/Scripts:$PATH"
export PATH="/snap/bin:$PATH"

# --- Environment ---
export LANG=en_US.UTF-8
export EDITOR=nvim

# --- Aliases ---
alias vim=nvim
alias nano=nvim
alias lg=lazygit
alias nvimcfg='cd ~/.config/nvim/lua/custom && nvim .'
alias reload='source ~/.zshrc'
alias wild_claude='claude --permission-mode bypassPermissions'
alias @powershell=pwsh

# --- fzf ---
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"

# --- Node version managers ---
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "$HOME/.nvm" || printf %s "$XDG_CONFIG_HOME/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd)"
fi

# --- Bun ---
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# --- opencode ---
export PATH="$HOME/.opencode/bin:$PATH"

# --- direnv ---
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# --- Secrets (API keys, tokens) — never committed ---
[ -f ~/.secrets ] && source ~/.secrets

# fnm
FNM_PATH="/home/alexander/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi
