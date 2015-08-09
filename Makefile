vim := vim --cmd 'set nomore t_ti= t_te='

default: install

install:
	$(vim) +NeoBundleInstall +q

update:
	$(vim) +NeoBundleClearCache +NeoBundleCheck +NeoBundleUpdate +NeoBundleUpdatesLog +q
upgrade: update

.PHONY: install update upgrade default
