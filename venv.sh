#!/usr/bin/env bash

# Declare a base path for both virtual environments
venv="${XDG_CACHE_HOME:-$HOME/.cache}/vim/venv"

# Try to detect virtualenv's executable names
vrenv2=virtualenv2
hash virtualenv-2.7 2>/dev/null && vrenv2=virtualenv-2.7
vrenv3=virtualenv3
hash virtualenv-3.6 2>/dev/null && vrenv3=virtualenv-3.6

# Ensure python 2/3 virtual environments
[ -d "$venv" ] || mkdir -p "$venv"
[ -d "$venv/neovim2" ] || $vrenv2 "$venv/neovim2"
[ -d "$venv/neovim3" ] || $vrenv3 "$venv/neovim3"

# Install or upgrade dependencies
echo 'PYTHON 2'
"$venv/neovim2/bin/pip" install -U neovim PyYAML
echo 'PYTHON 3'
"$venv/neovim3/bin/pip" install -U neovim PyYAML
