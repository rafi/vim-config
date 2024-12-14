SHELL := /usr/bin/env bash
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_STATE_HOME  ?= $(HOME)/.local/state

default: install

.PHONY: install update
install: create-dirs update-plugins
update: update-repo update-plugins

.PHONY: create-dirs
create-dirs:
	@mkdir -vp "$(XDG_CONFIG_HOME)"/nvim/spell
	@mkdir -vp "$(XDG_DATA_HOME)"/nvim
	@mkdir -vp "$(XDG_STATE_HOME)"/nvim/{sessions,shada,swap,undo}

.PHONY: stash
stash:
	git checkout -- lazy-lock.json
	git stash -a

.PHONY: update-repo
update-repo:
	git pull --ff --ff-only

.PHONY: update-plugins
update-plugins:
	nvim --headless '+Lazy! sync' +qa
	@echo

.PHONY: uninstall
uninstall:
	-rm -rf "$(XDG_DATA_HOME)"/nvim/{lazy,mason,rplugin.vim}
	-rm -rf "$(XDG_STATE_HOME)"/nvim/{lazy,shada,swap,undo,theme.txt}
	-rm -rf "$(XDG_CACHE_HOME)"/nvim/{luac,venv}

.PHONY: venv
venv:
ifeq (, $(shell which pyenv-virtualenv))
	python3 -m venv "$(XDG_CACHE_HOME)/nvim/venv" || true
else
	pyenv virtualenv neovim || true
	ln -fs "$(shell pyenv prefix neovim)" "$(XDG_CACHE_HOME)/nvim/venv"
endif
	"$(XDG_CACHE_HOME)/nvim/venv/bin/pip" install -U pip
	"$(XDG_CACHE_HOME)/nvim/venv/bin/pip" install -U pynvim

.PHONY: test
test:
	$(info Testing for NVIM >= 0.10.x)
	$(if $(shell nvim --version | egrep 'NVIM v0\.1[0-9]\.'),\
		$(info OK),\
		$(error   .. You need Neovim 0.10.x or newer))
	@echo All tests passed, hooray!

.PHONY: docker
docker:
	docker run -w /root -it --rm alpine:edge sh -uelic ' \
		apk add git fzf curl neovim ripgrep alpine-sdk --update && \
		git clone https://github.com/rafi/vim-config ~/.config/nvim && \
	cd ~/.config/nvim && nvim'
