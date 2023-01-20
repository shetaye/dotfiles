# Load conf
for conf in "$HOME/.config/zsh/"*.zsh; do
  source "${conf}"
done
unset conf

##							 ##
#  Configure Path #
##							 ##

### Julia
path+="/Applications/Julia-1.6.app/Contents/Resources/julia/bin"

### GNAT
path+="/Users/josephs/opt/GNAT/2020/bin"

### GHDL
path+="/opt/ghdl/bin"

### LLVM
#path+="/opt/llvm/bin"

### Google Cloud
path+="/Users/josephs/Tools/cloud_sql_proxy/bin"
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/josephs/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/josephs/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/josephs/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/josephs/google-cloud-sdk/completion.zsh.inc'; fi


### Go
path+="/Users/josephs/go/bin"

### K8s
path+="/Users/josephs/.arkade/bin/"
[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

### Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### Python
if [ -x "$(command -v pyenv)" ]; then
	eval "$(pyenv init -)"
fi
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/josephs/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/josephs/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/josephs/miniforge3/etc/profile.d/conda.sh"
    else
				export PATH="/Users/josephs/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

### 1Password
# Autocomplete
eval "$(op completion zsh)"; compdef _op op
# Plugin
source /Users/josephs/.config/op/plugins.sh

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
