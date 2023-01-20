MACOS_DIR="/Users/josephs/Tools/flutter"

if [[ -d MACOS_DIR ]] then
	FLUTTER_BIN="$MACOS_DIR/bin"
	export DART_SDK="$MACOS_DIR/bin/cache/dark-sdk"
	path+=FLUTTER_BIN
fi
