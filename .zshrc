
##							 ##
#  Configure Path #
##							 ##

### Powerlevel10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

### Java
# JDK version
jdk() {
  version=$1
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  java -version
}

### Flutter
set PATH "$PATH:/Users/josephs/Tools/flutter/bin"
export DART_SDK="/Users/josephs/Tools/flutter/bin/cache/dart-sdk"

### Terraform
set PATH "$PATH:/Users/josephs/Tools/terraform/bin"

### Julia
set PATH "$PATH:/Applications/Julia-1.6.app/Contents/Resources/julia/bin"

### Google Cloud
set PATH "$PATH:/Users/josephs/Tools/cloud_sql_proxy/bin"
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/josephs/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/josephs/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/josephs/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/josephs/google-cloud-sdk/completion.zsh.inc'; fi


### Go
set PATH "$PATH:/Users/josephs/go/bin"

### K8s
set PATH "$PATH:/Users/josephs/.arkade/bin/"
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

### System
set PATH "$PATH:/Users/josephs/.pub-cache/bin"
set PATH "$PATH:/Users/josephs/.local/bin"
set PATH "$PATH:/usr/local/opt/llvm/bin"
export PATH

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



