vim := vim --cmd 'set nomore t_ti= t_te='
XDG_CACHE_HOME ?= $(HOME)/.cache

default: install

install:
	mkdir -p "$(XDG_CACHE_HOME)/vim/"{backup,session,swap,tags,undo,view}; \
	$(vim) +q

update:
	git pull --ff --ff-only; \
	$(vim) +q
upgrade: update

uninstall:
	rm -rf "$(XDG_CACHE_HOME)/vim"

.PHONY: install update upgrade uninstall default
