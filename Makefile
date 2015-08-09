vim := vim --cmd 'set nomore t_ti= t_te='

default: install

install:
	$(vim) +NeoBundleInstall +q

update:
	git pull --ff --ff-only; \
	$(vim) +NeoBundleClearCache +NeoBundleCheck +NeoBundleUpdate +NeoBundleUpdatesLog +q
upgrade: update

.PHONY: install update upgrade default
