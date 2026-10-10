# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------
export ANSIBLE_NOCOWS=1

# ---------------------------------------------------------------------------
# OS detection
# ---------------------------------------------------------------------------
OS="$(uname -s)"
IS_MACOS=false
IS_LINUX=false
case "$OS" in
  Darwin) IS_MACOS=true ;;
  Linux)  IS_LINUX=true  ;;
esac

# ---------------------------------------------------------------------------
# Activate uv
# ---------------------------------------------------------------------------
. "$HOME/.local/bin/env"

# ---------------------------------------------------------------------------
# Activate Starship
# ---------------------------------------------------------------------------
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ---------------------------------------------------------------------------
# Activate zsh-autosuggestions
# ---------------------------------------------------------------------------
if $IS_MACOS && [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif $IS_LINUX && [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ---------------------------------------------------------------------------
# Activate zsh-patina syntax highlighter
# ---------------------------------------------------------------------------
if command -v zsh-patina &>/dev/null; then
  eval "$(zsh-patina activate)"
fi

# ---------------------------------------------------------------------------
# tmux shortcuts
# ---------------------------------------------------------------------------
if command -v tmux &>/dev/null; then
  alias tn='tmux new-session -s'
  alias tk='tmux kill-session -t'
  alias tl='tmux ls'
  ta() {
    if [ -z "$1" ]; then
      tmux attach
    else
      tmux attach -t "$1"
    fi
  }
fi

# ---------------------------------------------------------------------------
# zoxide
# ---------------------------------------------------------------------------
if command -v zoxide &>/dev/null && [[ $- == *i* ]]; then
  eval "$(zoxide init --cmd cd zsh)"
fi

# ---------------------------------------------------------------------------
# fzf keybindings
# ---------------------------------------------------------------------------
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
fi

# ---------------------------------------------------------------------------
# Editor
# ---------------------------------------------------------------------------
if command -v nvim &>/dev/null; then
  alias vim=nvim
  export EDITOR=nvim
  export VISUAL=nvim
fi

# ---------------------------------------------------------------------------
# Pixi package manager
# ---------------------------------------------------------------------------
if [[ -d "$HOME/.pixi/bin" ]]; then
  export PATH="$HOME/.pixi/bin:$PATH"
fi
