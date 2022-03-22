SHELL = /bin/bash
nvim ?= nvim
nvim_version := '${shell $(nvim) --version}'
XDG_DATA_HOME ?= $(HOME)/.local/share
VIM_DATA_HOME = $(XDG_DATA_HOME)/nvim

default: install

install: create-dirs update-plugins

update: update-repo update-plugins

upgrade: update

create-dirs:
	@mkdir -vp ./spell "$(VIM_DATA_HOME)"/{backup,sessions,swap,undo,vsnip}

update-repo:
	git pull --ff --ff-only

update-plugins:
	$(nvim) -V1 -es -i NONE -n --noplugin -u config/init.vim \
		-c "try | call dein#clear_state() | call dein#update() | finally | messages | qall! | endtry"
	@echo

uninstall:
	rm -rf "$(VIM_DATA_HOME)"/dein

test:
	$(info Testing NVIM 0.6.0+...)
	$(if $(shell echo "$(nvim_version)" | egrep "NVIM v0\.[6-9]"),\
		$(info OK),\
		$(error   .. You need Neovim 0.6.0 or newer))
	@echo All tests passed, hooray!

.PHONY: install create-dirs update-repo update-plugins uninstall test
