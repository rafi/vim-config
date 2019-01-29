#!/usr/bin/env bash

# Declare a base path for both virtual environments
venv="${XDG_CACHE_HOME:-$HOME/.cache}/vim/venv"

# Try to detect python2/3 executables
if ! hash python2 2>/dev/null; then
	echo "Python2 installation not found."
	exit 1
elif ! hash python3 2>/dev/null; then
	echo "Python3 installation not found."
	exit 1
fi

# Ensure python 2/3 virtual environments
[ -d "$venv" ] || mkdir -p "$venv"
if hash pyenv 2>/dev/null && [ -d "$(pyenv root)/versions/neovim2" ] && [ -d "$(pyenv root)/versions/neovim3" ]; then
	# pyenv environments are setup so use them
	[ -d "$venv/neovim2" ] || ln -s "$(pyenv root)/versions/neovim2" "$venv/neovim2"
	[ -d "$venv/neovim3" ] || ln -s "$(pyenv root)/versions/neovim3" "$venv/neovim3"
else
	[ -d "$venv/neovim2" ] || python2 -m virtualenv "$venv/neovim2"
	[ -d "$venv/neovim3" ] || python3 -m venv "$venv/neovim3"
fi

# Install or upgrade dependencies
echo ':: PYTHON 2'
"$venv/neovim2/bin/pip" install -U pynvim PyYAML
echo -e '\n:: PYTHON 3'
"$venv/neovim3/bin/pip" install -U pynvim PyYAML Send2Trash
