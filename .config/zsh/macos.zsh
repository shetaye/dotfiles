if [[ `uname` == "Darwin" ]]; then
	path+="$HOME/.pub-cache/bin"
	path+="$HOME/.local/bin"

	ulimit -n 65536 65536 # File descriptors
	ulimit -f 4294967296 4294967296 # File size (why)
fi
