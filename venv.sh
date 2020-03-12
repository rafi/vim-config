#!/usr/bin/env bash

_try_pyenv() {
	local pyenv='' name='' src=''
	if hash pyenv 2>/dev/null; then
		pyenv="$(pyenv root)"
		for name in "neovim" "neovim3" "nvim"; do
			src="${pyenv}/versions/${name}"
			if [ -d "${src}" ]; then
				echo "===> pyenv virtualenv found '${name}'"
				ln -fs "${src}" "${__venv}"
				return 0
			fi
		done
	fi
	echo ":: pyenv not found"
	return 1
}

_try_python() {
	if ! hash python3 2>/dev/null; then
		echo ':: python3 not found, consider installing pyenv.'
		return 1
	fi
	echo "===> python3 found"
	[ -d "${__venv}" ] || python3 -m venv "${__venv}"
}

main() {
	# Declare a base path for virtual environment
	local __venv="${XDG_CACHE_HOME:-$HOME/.cache}/vim/venv"

	mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/vim"

	if _try_pyenv || _try_python; then
		"${__venv}/bin/pip" install -U pynvim PyYAML Send2Trash
		echo
	else
		echo '===> ERROR: pyenv and python3 missing.'
	fi
}

main
