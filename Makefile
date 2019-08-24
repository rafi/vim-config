SHELL = /bin/bash
vim := $(if $(shell which nvim),nvim,$(shell which vim))
vim_version := '${shell $(vim) --version}'
XDG_CACHE_HOME ?= $(HOME)/.cache

default: install

install:
	@mkdir -vp "$(XDG_CACHE_HOME)/vim/"{backup,session,swap,tags,undo}; \
	$(vim) --cmd 'set t_ti= t_te= nomore' -N -U NONE -i NONE \
	-c "try | call dein#update() | call dein#recache_runtimepath() | finally | :messages | call confirm('Press any key to quit') | qall! | endtry"
	./venv.sh

update:
	@git pull --ff --ff-only; \
	$(vim) --cmd 'set t_ti= t_te= nomore' -N -U NONE -i NONE \
	-c "try | call dein#clear_state() | call dein#update() | call dein#recache_runtimepath() | finally | :messages | call confirm('Press any key to quit') | qall! | endtry"
	./venv.sh

upgrade: update

uninstall:
	rm -rf "$(XDG_CACHE_HOME)/vim"

test:
ifeq ('$(vim)','nvim')
	$(info Testing NVIM...)
	$(if $(findstring v0.4,$(vim_version)),\
		$(info OK),\
		$(error   .. MISSING! Is Neovim available in PATH?))
else
	$(info Testing VIM 8...)
	$(if $(findstring 8.,$(vim_version)),\
		$(info OK),\
		$(error   .. MISSING! Install newer $nvim version))

	$(info Testing +lua... )
	$(if $(findstring +lua,$(vim_version)),\
		$(info OK),\
		$(error   .. MISSING! Install $nvim with "+lua" enabled))

	$(info Testing +python... )
	$(if $(findstring +python,$(vim_version)),\
		$(info OK),\
		$(error .. MISSING! Install $nvim with "+python" enabled))
endif
	@echo All tests passed, hooray!


.PHONY: install update upgrade uninstall test
