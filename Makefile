SHELL = /bin/bash
nvim ?= nvim
nvim_version := '${shell $(nvim) --version}'
XDG_DATA_HOME ?= $(HOME)/.local/share

default: install

install: create-dirs update-plugins

update: update-repo update-plugins

upgrade: update

create-dirs:
	@mkdir -vp ./spell "$(XDG_DATA_HOME)/nvim/"{backup,sessions,swap,undo}

update-repo:
	git pull --ff --ff-only

update-plugins:
	$(nvim) -V1 -es -i NONE -N --noplugin -u config/init.vim \
		-c "try | call dein#clear_state() | call dein#update() | finally | messages | qall! | endtry"

uninstall:
	rm -rf "$(XDG_DATA_HOME)/nvim/dein"

test:
	$(info Testing NVIM 0.5+...)
	$(if $(shell echo "$(nvim_version)" | egrep "NVIM v0\.[5-9]"),\
		$(info OK),\
		$(error   .. You need Neovim 0.5.x or newer))
	@echo All tests passed, hooray!

.PHONY: install create-dirs update-repo update-plugins uninstall test
