vim := vim --cmd 'set nomore t_ti= t_te='
XDG_CACHE_HOME ?= $(HOME)/.cache

default: install

install:
	$(vim) --cmd 'let g:vim_installing = 1' +NeoBundleInstall +q

update:
	git pull --ff --ff-only; \
	$(vim) +NeoBundleClearCache +NeoBundleCheck \
		+NeoBundleUpdate +NeoBundleUpdatesLog +q
upgrade: update

uninstall:
	rm -rf "$(XDG_CACHE_HOME)/vim"

.PHONY: install update upgrade uninstall default
