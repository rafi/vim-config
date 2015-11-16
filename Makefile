vim := vim --cmd 'set nomore t_ti= t_te='
XDG_CACHE_HOME ?= $(HOME)/.cache

default: install

install:
	mkdir -p "$(XDG_CACHE_HOME)/vim/"{backup,session,swap,tags,undo,view}; \
	$(vim) --cmd 'let g:vim_installing = 1' +NeoBundleInstall +q

update:
	git pull --ff --ff-only; \
	$(vim) +NeoBundleClearCache +NeoBundleCheck \
		+NeoBundleUpdate +NeoBundleUpdatesLog +q
upgrade: update

uninstall:
	rm -rf "$(XDG_CACHE_HOME)/vim"

test:
	echo 'Testing Vim 7.4... ' && $(vim) --version | head -n1 | grep -q '7\.4' \
		&& echo 'OK' || echo '  .. MISSING! Install newer Vim version'; \
		echo 'Testing +python... ' && $(vim) --version | grep -q '+python' \
			&& echo 'OK' || echo '  .. MISSING! Install Vim with +python'; \
			echo 'Testing +lua... ' && $(vim) --version | grep -q '+lua' \
				&& echo 'OK' || echo '  .. MISSING! Install Vim with +lua'

.PHONY: install update upgrade uninstall test default
