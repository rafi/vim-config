SHELL = /bin/bash
vim := $(if $(shell which nvim),nvim,$(shell which vim))
vim_version := '${shell $(vim) --version}'
XDG_CACHE_HOME ?= $(HOME)/.cache

default: install

install: create-dirs update-plugins

update: update-repo update-plugins

upgrade: update

create-dirs:
	@mkdir -vp "$(XDG_CACHE_HOME)/vim/"{backup,session,swap,tags,undo}

update-repo:
	git pull --ff --ff-only

update-plugins:
	$(vim) -V1 -es -i NONE -N --noplugin -u config/init.vim \
		-c "try | call dein#clear_state() | call dein#update() | finally | messages | qall! | endtry"

uninstall:
	rm -rf "$(XDG_CACHE_HOME)/vim"

test:
ifeq ('$(vim)','nvim')
	$(info Testing NVIM 0.5+...)
	$(if $(shell echo "$(vim_version)" | egrep "NVIM v0\.[5-9]"),\
		$(info OK),\
		$(error   .. You need Neovim 0.5.x or newer))
else
	$(info Testing VIM 8.x...)
	$(if $(shell echo "$(vim_version)" | egrep "VIM .* 8\."),\
		$(info OK),\
		$(error   .. You need Vim 8.x))

	$(info Testing +python3... )
	$(if $(findstring +python3,$(vim_version)),\
		$(info OK),\
		$(error .. MISSING! Install Vim 8.x with "+python3" enabled))
endif
	@echo All tests passed, hooray!

.PHONY: install create-dirs update-repo update-plugins uninstall test
