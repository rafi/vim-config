#!/usr/bin/env bash

_try_pyenv() {
	local name='' src=''
	if hash pyenv 2>/dev/null; then
		echo '===> pyenv found, searching virtualenvs…'
		for name in neovim neovim3 nvim; do
			src="$(pyenv prefix "${name}" 2>/dev/null)"
			if [ -d "${src}" ]; then
				echo "===> pyenv virtualenv found '${name}', upgrading..."
				# Symlink virtualenv for easy access
				ln -fs "${src}" "${__venv}"
				return 0
			fi
		done
		echo "===> skipping pyenv. manual virtualenv isn't found"
		echo
		echo "Press Ctrl+C and use pyenv to create one yourself (name it 'neovim')"
		echo "and run ${0} again. Or press Enter to continue and create a"
		echo "virtualenv using: python3 -m venv '${__venv}'"
		read -r
	else
		echo '===> pyenv not found, skipping'
	fi
	return 1
}

_try_python() {
	if ! hash python3 2>/dev/null; then
		echo '===> python3 not found, skipping'
		return 1
	fi
	echo "===> python3 found"
	[ -d "${__venv}" ] || python3 -m venv "${__venv}"
}

main() {
	# Concat a base path for vim cache and virtual environment
	local __cache="${XDG_CACHE_HOME:-$HOME/.cache}/vim"
	local __venv="${__cache}/venv"
	mkdir -p "${__cache}"

	if [ -d "${__venv}/neovim2" ]; then
		echo -n '===> ERROR: Python 2 has ended its life, '
		echo ' only python3 virtualenv is created now.'
		echo "Delete '${__venv}' (or backup!) first, and then run ${0} again."
	elif _try_pyenv || _try_python; then
		# Install Python 3 requirements
		"${__venv}/bin/pip" install -U pynvim PyYAML Send2Trash
		echo '===> success'
	else
		echo '===> ERROR: Unable to setup python3 virtualenv.'
		echo -e '\nConsider using pyenv with its virtualenv plugin:'
		echo '- https://github.com/pyenv/pyenv'
		echo '- https://github.com/pyenv/pyenv-virtualenv'
	fi
}

main
