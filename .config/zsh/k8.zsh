# Arkade

MACOS_ARKADE_BIN="/Users/josephs/.arkade/bin/"
if [[ -d $MACOS_ARKADE_BIN ]] then
	path+=$MACOS_ARKADE_BIN
fi

# kubectl
if [ -x "$(command -v kubectl)" ]; then
	source <(kubectl completion zsh)
fi
