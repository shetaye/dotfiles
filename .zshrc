# Load conf
for conf in "$HOME/.config/zsh/"*.zsh; do
  source "${conf}"
done
unset conf

##							 ##
#  Configure Path #
##							 ##

### System
path+="/Users/josephs/.pub-cache/bin"
path+="/Users/josephs/.local/bin"
#path+="/usr/local/opt/llvm/bin"

##							   ##
#  Small Utilities  #
##								 ##
if [ -x "$(command -v exa)" ]; then
    alias ls="exa"
    alias la="exa --long --all --group"
fi
alias nv="nvim"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

ulimit -n 65536 65536 # File descriptors
ulimit -f 4294967296 4294967296 # File size (why)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH

export HOMEBREW_GITHUB_API_TOKEN=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
