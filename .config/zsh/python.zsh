if [ -x "$(command -v pyenv)" ]; then
	eval "$(pyenv init -)"
fi

if [[ -f /Users/josephs/miniforge3/bin/conda ]]; then 
	# >>> conda initialize >>>
	# !! Contents within this block are managed by 'conda init' !!
	__conda_setup="$('/Users/josephs/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
	if [ $? -eq 0 ]; then
			eval "$__conda_setup"
	else
			if [ -f "/Users/josephs/miniforge3/etc/profile.d/conda.sh" ]; then
					. "/Users/josephs/miniforge3/etc/profile.d/conda.sh"
			else
					path+="/Users/josephs/miniforge3/bin:$PATH"
			fi
	fi
	unset __conda_setup
	# <<< conda initialize <<<
fi


