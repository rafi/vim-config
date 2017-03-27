vim := $(if $(shell which nvim),nvim,$(shell which vim))
vim_version := '${shell $(vim) --version}'
XDG_CACHE_HOME ?= $(HOME)/.cache

default: install

install:
	@mkdir -vp "$(XDG_CACHE_HOME)/vim/"{backup,session,swap,tags,undo}; \
	$(vim) --cmd 'set t_ti= t_te= nomore' -N -U NONE -i NONE \
		-c "try | call dein#update() | finally | call confirm('') | qall! | endtry"

update:
	@git pull --ff --ff-only; \
	$(vim) --cmd 'set t_ti= t_te= nomore' -N -U NONE -i NONE \
		-c "try | call dein#clear_state() | call dein#update() | call dein#recache_runtimepath() | finally | call confirm('') | qall! | endtry"

upgrade: update

uninstall:
	rm -rf "$(XDG_CACHE_HOME)/vim"

test:
ifeq ('$(vim)','nvim')
	$(info Testing NVIM...)
	$(if $(findstring NVIM,$(vim_version)),\
		$(info OK),\
		$(error   .. MISSING! Is Neovim available in PATH?))
else
	$(info Testing VIM 7.4...)
	$(if $(findstring 7.4,$(vim_version)),\
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
