alias gvim="bash $GEOVIM_PATH/launch_geovim.sh"
if [[ -n $TMUX && -n ${GEOVIM+set} ]]; then
	exec "$GEOVIM_PATH/launch_geovim.sh" -hook
fi
