if [ -x "$(command -v op)" ]; then
	eval "$(op completion zsh)"; compdef _op op
fi

if [[ -f "/Users/josephs/.config/op/plugins.sh" ]]; then
	source /Users/josephs/.config/op/plugins.sh
fi
