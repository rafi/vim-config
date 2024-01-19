SHELL := /usr/bin/env bash
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_STATE_HOME  ?= $(XDG_DATA_HOME)

default: install
install: create-dirs update-plugins
update: update-repo update-plugins

create-dirs:
	@mkdir -vp "$(XDG_CONFIG_HOME)"/nvim/spell
	@mkdir -vp "$(XDG_DATA_HOME)"/nvim/site/spell
	@mkdir -vp "$(XDG_STATE_HOME)"/nvim/{backup,sessions,shada,swap,undo}

update-repo:
	git pull --ff --ff-only

update-plugins:
	nvim --headless '+Lazy! sync' +qa
	@echo

uninstall:
	-rm -rf "$(XDG_DATA_HOME)"/nvim/{lazy,theme.txt,rplugin.vim}
	-rm -rf "$(XDG_STATE_HOME)"/nvim/lazy
	-rm -rf "$(XDG_CACHE_HOME)"/nvim/venv

venv:
ifeq (, $(shell which pyenv-virtualenv))
	python3 -m venv "$(XDG_CACHE_HOME)/nvim/venv" || true
else
	pyenv virtualenv neovim || true
	ln -fs "$(shell pyenv prefix neovim)" "$(XDG_CACHE_HOME)/nvim/venv"
endif
	"$(XDG_CACHE_HOME)/nvim/venv/bin/pip" install -U pip
	"$(XDG_CACHE_HOME)/nvim/venv/bin/pip" install -U pynvim

test:
	$(info Testing for NVIM >= 0.9.x)
	$(if $(shell nvim --version | egrep 'NVIM v0\.(9|10)\.'),\
		$(info OK),\
		$(error   .. You need Neovim 0.9.x or newer))
	@echo All tests passed, hooray!

.PHONY: install update create-dirs update-repo update-plugins uninstall venv test
