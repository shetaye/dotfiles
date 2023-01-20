MACOS_CLOUD_SQL_PROXY_BIN="/Users/josephs/Tools/cloud_sql_proxy/bin"

if [[ -d $MACOS_CLOUD_SQL_PROXY_BIN ]] then
	path+=$MACOS_CLOUD_SQL_PROXY_BIN
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/josephs/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/josephs/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/josephs/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/josephs/google-cloud-sdk/completion.zsh.inc'; fi


