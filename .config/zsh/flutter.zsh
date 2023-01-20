MACOS_BIN="/Users/josephs/Tools/flutter/bin"

if [[ -d $MACOS_BIN ]] then
	export DART_SDK="$MACOS_BIN/cache/dark-sdk"
	path+=$MACOS_BIN
fi
