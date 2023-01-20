# Arkade

MACOS_ARKADE_BIN="/Users/josephs/.arkade/bin/"
if [[ -d $MACOS_ARKADE_BIN ]] then
	path+=$MACOS_ARKADE_BIN
fi

# kubectl

[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)
