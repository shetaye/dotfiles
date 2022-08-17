# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

set PATH "$PATH:/Users/josephs/.pub-cache/bin"
set PATH "$PATH:/Users/josephs/Tools/flutter/bin"
set PATH "$PATH:/Users/josephs/Tools/terraform/bin"
set PATH "$PATH:/Users/josephs/Tools/cloud_sql_proxy/bin"
set PATH "$PATH:/Users/josephs/.local/bin"
set PATH "$PATH:/usr/local/opt/llvm/bin"
set PATH "$PATH:/Applications/Julia-1.6.app/Contents/Resources/julia/bin"
set PATH "$PATH:/Users/josephs/go/bin"
set PATH "$PATH:/Users/josephs/.arkade/bin/"
export PATH

# Alternative commands
if [ -x "$(command -v exa)" ]; then
    alias ls="exa"
    alias la="exa --long --all --group"
fi

# Aliases
alias nv="nvim"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

# JDK version
jdk() {
  version=$1
  export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
  java -version
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/josephs/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/josephs/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/josephs/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/josephs/google-cloud-sdk/completion.zsh.inc'; fi
#[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

# Set some increased limits
ulimit -n 65536 65536 # File descriptors
ulimit -f 4294967296 4294967296 # File size (why)

# Point dart
export DART_SDK="/Users/josephs/Tools/flutter/bin/cache/dart-sdk"

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# eval "$(pyenv init -)"

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


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
