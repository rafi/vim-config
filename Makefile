SHELL := /usr/bin/env bash
XDG_CACHE_HOME  ?= $(HOME)/.cache
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_DATA_HOME   ?= $(HOME)/.local/share
XDG_STATE_HOME  ?= $(HOME)/.local/state

default: install

.PHONY: install update
install: create-dirs install-plugins
update: update-repo sync-plugins

.PHONY: create-dirs
create-dirs:
	@mkdir -vp "$(XDG_CONFIG_HOME)"/nvim/spell
	@mkdir -vp "$(XDG_DATA_HOME)"/nvim
	@mkdir -vp "$(XDG_STATE_HOME)"/nvim/{sessions,shada,swap,undo}

.PHONY: stash
stash:
	-git checkout -- nvim-pack-lock.json
	git stash -a

.PHONY: update-repo
update-repo:
	git pull --ff --ff-only

.PHONY: install-plugins
# The first vim.pack call at startup installs every plugin in lockfile.
install-plugins:
	nvim --headless +qa
	@echo

.PHONY: sync-plugins
# Move installed plugins to the revisions in nvim-pack-lock.json,
# e.g. after `git pull`.
sync-plugins:
	nvim --headless '+lua vim.pack.update(nil, { target = "lockfile", force = true })' +qa
	@echo

.PHONY: update-plugins
# Update every plugin to its latest version and rewrite the lockfile.
update-plugins:
	nvim --headless '+lua vim.pack.update(nil, { force = true })' +qa
	@echo

.PHONY: uninstall
uninstall:
	-rm -rf "$(XDG_DATA_HOME)"/nvim/{site/pack/core,mason,rplugin.vim}
	-rm -rf "$(XDG_STATE_HOME)"/nvim/{lazy,shada,swap,undo,theme.txt}
	-rm -rf "$(XDG_CACHE_HOME)"/nvim/{luac,venv}

.PHONY: venv
venv:
ifeq (, $(shell which pyenv-virtualenv))
	python3 -m venv "$(XDG_CACHE_HOME)/nvim/venv" || true
else
	pyenv virtualenv neovim || true
	ln -fs "$(shell pyenv prefix neovim)" "$(XDG_CACHE_HOME)/nvim/venv"
endif
	"$(XDG_CACHE_HOME)/nvim/venv/bin/pip" install -U pip
	"$(XDG_CACHE_HOME)/nvim/venv/bin/pip" install -U pynvim

.PHONY: check
check:
	$(info Testing for NVIM >= 0.12)
	$(if $(shell nvim --version | egrep 'NVIM v0\.1[2-9]\.'),\
		$(info OK),\
		$(error   .. You need Neovim 0.12 or newer))

.PHONY: test
test:
	nvim -l tests/minit.lua --minitest $(SPEC)

IMAGE ?= alpine-sdk:nvim

# Build script with the Dockerfile as a heredoc, so the image builds from
# stdin with no build context. It lives in a variable because each recipe
# line runs in its own shell (.ONESHELL needs GNU make 3.82, macOS has 3.81).
define DOCKER_BUILD
docker build -t $(IMAGE) - <<'EOF'
FROM alpine:edge
RUN apk add --no-cache --update \
  alpine-sdk shadow bash git fzf curl neovim ripgrep fd zoxide \
  tree-sitter-cli && chsh -s /bin/bash root
SHELL ["/bin/bash", "-c"]
WORKDIR /root
CMD ["/bin/bash"]
EOF
endef
export DOCKER_BUILD

.PHONY: docker-build
docker-build:
	@eval "$$DOCKER_BUILD"

.PHONY: docker
# Try the published config in a throwaway container.
docker: docker-build
	docker run -it --rm $(IMAGE) bash -lc \
		'git clone https://github.com/rafi/vim-config ~/.config/nvim && nvim'

# Files a run would read or write, so docker-local moves them aside first:
# the container then starts like a fresh install. lazyvim.json is listed so
# a copy made by LAZYVIM_JSON is removed again.
STATE_FILES := lua/config lua/plugins nvim-pack-lock.json rafi.json lazyvim.json

# Copied to lazyvim.json for the run, to test the upgrade path, e.g.
# `make docker-local LAZYVIM_JSON=tests/fixtures/lazyvim.json`.
LAZYVIM_JSON ?=

# Stash script, in a variable like DOCKER_BUILD. The trap puts the state
# files back, also after an error or Ctrl-C, and drops what the container
# wrote there.
define DOCKER_LOCAL
set -e
cd "$(CURDIR)"
stash="$$(mktemp -d)"
restore() {
  for f in $(STATE_FILES); do
    rm -rf "$$f"
    if [ -e "$$stash/$$f" ]; then mv "$$stash/$$f" "$$f"; fi
  done
  rm -rf "$$stash"
}
trap restore EXIT
trap 'exit 1' INT TERM
for f in $(STATE_FILES); do
  if [ -e "$$f" ]; then
    mkdir -p "$$stash/$$(dirname "$$f")"
    mv "$$f" "$$stash/$$f"
  fi
done
if [ -n "$(LAZYVIM_JSON)" ]; then cp "$(LAZYVIM_JSON)" lazyvim.json; fi
docker run -v "$(CURDIR)":/root/.config/nvim -it --rm $(IMAGE) nvim
endef
export DOCKER_LOCAL

.PHONY: docker-local
# Try this working tree in a throwaway container, with the state files
# stashed (see STATE_FILES).
docker-local: docker-build
	@eval "$$DOCKER_LOCAL"
