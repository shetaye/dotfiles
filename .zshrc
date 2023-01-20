# Load conf
for conf in "$HOME/.config/zsh/"*.zsh; do
  source "${conf}"
done
unset conf

##							   ##
#  Small Utilities  #
##								 ##
if [ -x "$(command -v exa)" ]; then
    alias ls="exa"
    alias la="exa --long --all --group"
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

alias nv="nvim"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

export PATH

export HOMEBREW_GITHUB_API_TOKEN=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
