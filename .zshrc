# Load conf
for conf in "$HOME/.config/zsh/"*.zsh; do
  source "${conf}"
done
unset conf

alias nv="nvim"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

export EDITOR="nvim"
export VISUAL="nvim"
export PATH

export HOMEBREW_GITHUB_API_TOKEN=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
