#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias nv='nvim'
alias ll='\ls --color=never'
alias la='\ls -alh --color=never'
alias copy='xclip -i -selection c'
alias paste='xclip -o -selection c'
alias pwdc='echo $PWD | copy'
alias pwdp='cd $(paste)'

alias emacs='emacs_nw.sh'

export EDITOR="nvim"

export PATH="~/.local/bin:$PATH"

# CS140E/240LX
export PATH="/mnt/data/tools/gcc-arm-none-eabi-10.3-2021.10/bin:$PATH"
#export PATH="/mnt/data/tools/gcc-arm-none-eabi-10-2020-q4-major/bin:$PATH"
export CS140E_2024_PATH="/mnt/data/repos/github.com/dddrrreee/cs140e-24win"
export CS240LX_2024_PATH="/mnt/data/repos/github.com/dddrrreee/cs240lx-24spr"
export PATH="$CS140E_2024_PATH/bin:$PATH"

# Bossa
export PATH="/mnt/data/tools/BOSSA/bin:$PATH"

# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# STM32
export STM32_PRG_PATH=/mnt/data/tools/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin
export PATH="$STM32_PRG_PATH:$PATH"

# hledger
export LEDGER_FILE="$HOME/projects/personal/finances/2024.journal"
export TIME_FILE="$HOME/projects/personal/time/2024.timeclock"

ti() {
  echo "i $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$TIME_FILE"
}
alias to='echo o $(date "+%Y-%m-%d %H:%M:%S") >>$TIME_FILE'

# nvm
source /usr/share/nvm/init-nvm.sh

# Go
export PATH="~/go/bin/:$PATH"
