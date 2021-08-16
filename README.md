# Rafael Bodill's Neovim Config

Lean mean Neovim machine, 30-45ms startup time.

Works best with [Neovim] 0.5.x ⚠️ For Vim 8.x, use the
[`vim` git tag](https://github.com/rafi/vim-config/tree/vim).

> I encourage you to fork this repo and create your own experience.
> Learn how to tweak and change Neovim to the way YOU like it.
> This is my cultivation of years of tweaking, use it as a git remote
> and stay in-touch with upstream for reference or cherry-picking.

<details>
  <summary>
    <strong>Table of Contents</strong>
    <small><i>(🔎 Click to expand/collapse)</i></small>
  </summary>

<!-- vim-markdown-toc GFM -->

* [Features](#features)
* [Screenshot](#screenshot)
* [Prerequisites](#prerequisites)
* [Install](#install)
* [Language-Server Protocol (LSP)](#language-server-protocol-lsp)
* [Upgrade](#upgrade)
  * [Recommended Fonts](#recommended-fonts)
  * [Recommended Linters](#recommended-linters)
  * [Recommended Tools](#recommended-tools)
* [User Custom Config](#user-custom-config)
* [Structure](#structure)
* [Plugin Highlights](#plugin-highlights)
* [Plugins Included](#plugins-included)
  * [Non Lazy-Loaded Plugins](#non-lazy-loaded-plugins)
  * [Lazy-Loaded Plugins](#lazy-loaded-plugins)
    * [Commands](#commands)
    * [Interface](#interface)
    * [Completion & Code-Analysis](#completion--code-analysis)
    * [Fern](#fern)
    * [Syntax](#syntax)
    * [Operators & Text Objects](#operators--text-objects)
* [Custom Key-mappings](#custom-key-mappings)
  * [Navigation](#navigation)
  * [File Operations](#file-operations)
  * [Edit](#edit)
  * [Search & Replace](#search--replace)
  * [Clipboard](#clipboard)
  * [Command & History](#command--history)
  * [Editor UI](#editor-ui)
  * [Custom Tools & Plugins](#custom-tools--plugins)
  * [Window Management](#window-management)
  * [Plugin: Gitsigns](#plugin-gitsigns)
  * [Plugin: Gina](#plugin-gina)
  * [Plugin: Telescope](#plugin-telescope)
  * [Plugin: Fern](#plugin-fern)
  * [Plugin: LSP](#plugin-lsp)
  * [Plugin: Any-Jump](#plugin-any-jump)
  * [Plugin: Signature](#plugin-signature)

<!-- vim-markdown-toc -->
</details>

## Features

* Fast startup time
* Robust, yet light-weight
* Lazy-load 95% of plugins with [Shougo/dein.vim]
* LSP installers (`:LspInstall <filetype>`)
* Custom side-menu (try it! <kbd>Space</kbd>+<kbd>l</kbd>)
* Custom context-menu (try it! <kbd>;</kbd>+<kbd>c</kbd>)
* Auto-complete extensive setup with [nvim-lspconfig] and [nvim-compe]
  (try <kbd>Tab</kbd> in insert-mode)
* [telescope.nvim] centric work-flow with lists (try <kbd>;</kbd>+<kbd>f</kbd>…)
* Structure view with [simrat39/symbols-outline.nvim]
* Git features using [lambdalisue/gina.vim] and [lewis6991/gitsigns.nvim]
* Auto-save and restore sessions with [rmagatti/auto-session].
* Light-weight but informative status & tab lines
* Easy customizable theme
* Premium color-schemes

## Screenshot

![Vim screenshot](http://rafi.io/static/img/project/vim-config/features.png)

## Prerequisites

* [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)
  (`brew install neovim`) ≥ v0.5.0
* Plugins are parsed [from YAML](./config/plugins.yaml) and cached.
  Ensure **one** of these tools is installed:
  * [yj](https://github.com/sclevine/yj) (`brew install yj`)
  * [yq](https://github.com/mikefarah/yq) (`brew install yq`)
  * [yaml2json](https://github.com/bronze1man/yaml2json)
  * Ruby
  * Python with PyYAML (`pip install PyYAML`)

## Install

**_1._** Let's clone this repo! Clone to `~/.config/nvim`

```bash
mkdir ~/.config
git clone git://github.com/rafi/vim-config.git ~/.config/nvim
cd ~/.config/nvim
```

**_2._** Run `make test` to test your nvim version and capabilities.

**_3._** Run `make` to install all plugins.

**_4._** If you are experiencing problems, run and read `nvim -c checkhealth`

Enjoy! :smile:

## Language-Server Protocol (LSP)

To leverage LSP auto-completions and other functionalities, once you open a
file in Neovim, run `:LspInstall <language>` to use [kabouzeid/nvim-lspinstall]
installation feature, use <kbd>Tab</kbd> to list available servers.

See [lua/plugins/lspconfig.lua] for custom mappings for intellisense.

Here are some useful LSP server installations:

* `:LspInstall bash`
* `:LspInstall diagnosticls`
* `:LspInstall json`
* `:LspInstall lua`
* `:LspInstall go`
* `:LspInstall python`
* `:LspInstall vim`
* `:LspInstall yaml`

## Upgrade

```bash
cd ~/.config/nvim
make update
```

This will run `git pull --ff --ff-only` and update all plugins using
[Shougo/dein.vim] package-manager (`:call dein#update()`).

### Recommended Fonts

* [Pragmata Pro] (€19 – €1,990): My preferred font
* Any of the [Nerd Fonts]

On macOS with Homebrew, choose one of the [Nerd Fonts],
for example, here are some popular fonts:

```sh
brew tap homebrew/cask-fonts
brew search nerd-font
brew install --cask font-victor-mono-nerd-font
brew install --cask font-iosevka-nerd-font-mono
brew install --cask font-hack-nerd-font
brew install --cask font-fira-code
```

[Pragmata Pro]: https://www.fsd.it/shop/fonts/pragmatapro/
[Nerd Fonts]: https://www.nerdfonts.com

### Recommended Linters

* macOS with Homebrew:

```sh
brew install vint shellcheck jsonlint yamllint
brew install tflint ansible-lint tidy-html5 proselint write-good
```

* Node.js based linters:

```sh
yarn global add markdownlint-cli eslint jshint stylelint sass-lint
```

* Python based linters:

```sh
pip3 install --user pycodestyle pyflakes flake8
```

### Recommended Tools

* **ripgrep**: [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
  (macOS: `brew install rg`)
* Jump around with **zoxide**: [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide)
  (macOS: `brew install zoxide`)
* Fuzzy file finders:
  **[fzf](https://github.com/junegunn/fzf)**, or
  **[fzy](https://github.com/jhawthorn/fzy)**,
  (macOS: `brew install fzf`)

## User Custom Config

For **custom configuration**, create the `config/local.vim` file
and add your personal vimscript there.

For **installing plugins**, create a `config/local.plugins.yaml` file and
manage your own plugin collection.  If you want to disable some of the plugins
I use, you can overwrite them, _e.g._:

```yaml
- { repo: shadmansaleh/lualine.nvim, if: 0 }
```

Using `config/local.plugins.yaml` you can install any plugin you want, _e.g._:

```yaml
# Choose only ONE of these statuslines ;)
- repo: itchyny/lightline.vim
- repo: vim-airline/vim-airline
- repo: glepnir/galaxyline.nvim
- repo: glepnir/spaceline.vim
- repo: liuchengxu/eleline.vim
```

You can set **global specific features** by defining in your local
`config/local.vim`:

```vim
let g:elite_mode = 1                     " Set arrow-keys to window resize
let g:global_symbol_padding = '  '       " Padding after nerd symbols
let g:tabline_plugin_enable = 0          " Disable built-in tabline
let g:enable_universal_quit_mapping = 0  " Disable normal 'q' mapping
let g:disable_mappings = 0               " Disable config/mappings.vim
```

To override **LSP configurations**, create a `lua/lsp-local/<server_name>.lua`
file. Must return a table with `config` function. For example, create
`lua/lsp-local/go.lua`:

```lua
local config = {
	settings = {
		gopls = {
			staticcheck = true
		}
	}
}

return {
	config = function(_) return config end,
}
```

⚠️ This will completely overwrite built-in [`lua/lsp/go.lua`](./lua/lsp/go.lua).

## Structure

* [after/](./after) - Language specific custom settings
* [autoload/](./autoload) - Action-menu and badge functions
* [config/](./config) - Configuration
    * [plugins/](./config/plugins) - Plugin configurations
        * [all.vim](./config/plugins/all.vim) - Plugin mappings
        * […](./config/plugins)
    * [general.vim](./config/general.vim) - General configuration
    * [init.vim](./config/init.vim) - Package-manager initialization
    * **local.plugins.yaml** - Custom user plugins
    * **local.vim** - Custom user settings
    * [mappings.vim](./config/mappings.vim) - Key-mappings
    * [plugins.yaml](./config/plugins.yaml) - My favorite _**Plugins!**_
    * [vimrc](./config/vimrc) - Initialization
* [lua/](./lua) - Lua plugin configurations
    * [lsp/](./lua/lsp) - LSP configurations
    * **lsp-local** - Custom user LSP configurations
    * [plugins/](./lua/plugins) - Plugins configurations
    * [badge.lua](./lua/badge.lua) - Badges for status lines
    * [user.lua](./lua/user.lua) - Custom functions
* [plugin/](./plugin) - Custom written plugins
* [snippets/](./snippets) - Personal code snippets
* [themes/](./themes) - Colorscheme overrides
* [filetype.vim](./filetype.vim) - Custom filetype detection

## Plugin Highlights

* Plugin management with cache and lazy loading for speed
* Auto-completion with Language-Server Protocol (LSP)
* Project-aware tabline
* Fern as file-manager + Git status icons
* Extensive syntax highlighting with [nvim-treesitter].

_Note_ that 95% of the plugins are **[lazy-loaded]**.

## Plugins Included

<details open>
  <summary><strong>List</strong> <small><i>(🔎 Click to expand/collapse)</i></small></summary>

### Non Lazy-Loaded Plugins

| Name           | Description
| -------------- | ----------------------
| [Shougo/dein.vim] | Dark powered Vim/Neovim plugin manager
| [thinca/vim-localrc] | Enable configuration file of each directory
| [rafi/awesome-colorschemes] | Awesome color-schemes
| [christoomey/tmux-navigator] | Seamless navigation between tmux panes and vim splits
| [tpope/vim-sleuth] | Heuristically set buffer indent options
| [folke/lsp-colors.nvim] | LSP diagnostics highlight groups for colorschemes
| [nvim-lua/plenary.nvim] | Lua functions library
| [nvim-lua/popup.nvim] | An implementation of the Popup API from vim in Neovim
| [kyazdani42/nvim-web-devicons] | Lua fork of vim-devicons
| [sgur/vim-editorconfig] | EditorConfig plugin written entirely in Vimscript

### Lazy-Loaded Plugins

#### Commands

| Name           | Description
| -------------- | ----------------------
| [tyru/caw.vim] | Robust comment plugin with operator support
| [mbbill/undotree] | Ultimate undo history visualizer
| [tweekmonster/helpful.vim] | Display vim version numbers in docs
| [lambdalisue/suda.vim] | An alternative sudo.vim for Vim and Neovim
| [TimUntersberger/neogit] | Magit clone for Neovim
| [lambdalisue/gina.vim] | Asynchronously control git repositories
| [folke/zen-mode.nvim] | Distraction-free coding for Neovim
| [folke/which-key.nvim] | Create key bindings that stick
| [tversteeg/registers.nvim] | Preview the contents of the registers
| [NTBBloodbath/rest.nvim] | A fast Neovim http client written in Lua
| [pechorin/any-jump.vim] | Jump to any definition and references without overhead
| [kana/vim-niceblock] | Make blockwise Visual mode more useful
| [t9md/vim-choosewin] | Choose window to use, like tmux's 'display-pane'
| [mzlogin/vim-markdown-toc] | Generate table of contents for Markdown files
| [Ron89/thesaurus_query.vim] | Multi-language thesaurus query and replacement

#### Interface

| Name           | Description
| -------------- | ----------------------
| [itchyny/vim-gitbranch] | Lightweight git branch detection
| [romainl/vim-cool] | Simple plugin that makes hlsearch more useful
| [haya14busa/vim-asterisk] | Improved * motions
| [rhysd/accelerated-jk] | Up/down movement acceleration
| [haya14busa/vim-edgemotion] | Jump to the edge of block
| [t9md/vim-quickhl] | Highlight words quickly
| [rcarriga/nvim-notify] | Fancy notification manager for NeoVim
| [rafi/vim-sidemenu] | Small side-menu useful for terminal users
| [hoob3rt/lualine.nvim] | statusline plugin written in pure lua
| [itchyny/cursorword] | Underlines word under cursor
| [lewis6991/gitsigns.nvim] | Git signs written in pure lua
| [kshenoy/vim-signature] | Display and toggle marks
| [nathanaelkane/vim-indent-guides] | Visually display indent levels in code
| [kevinhwang91/nvim-bqf] | Better quickfix window in Neovim
| [norcalli/nvim-colorizer.lua] | The fastest Neovim colorizer
| [rmagatti/goto-preview] | Preview definitions using floating windows
| [rhysd/committia.vim] | Pleasant editing on Git commit messages
| [itchyny/calendar.vim] | Calendar application
| [deris/vim-shot-f] | Highlight characters to move directly with f/t/F/T
| [kristijanhusak/orgmode.nvim] | Orgmode clone written in Lua
| [vimwiki/vimwiki] | Personal Wiki for Vim

#### Completion & Code-Analysis

| Name           | Description
| -------------- | ----------------------
| [kabouzeid/nvim-lspinstall] | Provides the missing :LspInstall for nvim-lspconfig
| [kosayoda/nvim-lightbulb] | VSCode 💡 for neovim's built-in LSP
| [neovim/nvim-lspconfig] | Quickstart configurations for the Nvim LSP client
| [ray-x/lsp_signature.nvim] | LSP signature hint when you type
| [folke/lua-dev.nvim] | Dev setup for Lua
| [folke/todo-comments.nvim] | Highlight, list and search todo comments in your projects
| [hrsh7th/nvim-compe] | Auto completion Lua plugin for nvim
| [andersevenrud/compe-tmux] | Tmux completion source for nvim-compe
| [windwp/nvim-autopairs] | autopairs for neovim written by lua
| [hrsh7th/vim-vsnip] | Snippet plugin for vim/nvim that supports LSP/VSCode's snippet format
| [hrsh7th/vim-vsnip-integ] | vim-vsnip integrations to other plugins
| [rafamadriz/friendly-snippets] | Preconfigured snippets for different languages
| [folke/trouble.nvim] | Pretty lists to help you solve all code diagnostics
| [sindrets/diffview.nvim] | Tabpage interface for easily cycling through diffs
| [nvim-telescope/telescope.nvim] | Find, Filter, Preview, Pick. All lua, all the time
| [rmagatti/session-lens] | Session-switcher extension for rmagatti/auto-session
| [jvgrootveld/telescope-zoxide] | Telescope extension for Zoxide
| [simrat39/symbols-outline.nvim] | Tree like view for symbols using LSP
| [rmagatti/auto-session] | Automated session manager for Neovim
| [sbdchd/neoformat] | Plugin for formatting code
| [mattn/emmet-vim] | Provides support for expanding abbreviations alá emmet

#### Fern

| Name           | Description
| -------------- | ----------------------
| [lambdalisue/fern.vim] | General purpose asynchronous tree viewer in pure vim
| [lambdalisue/nerdfont.vim] | Fundemental plugin to handle Nerd Fonts
| [lambdalisue/fern-git-status.vim] | Fern git status badge integration
| [lambdalisue/fern-mapping-git.vim] | Fern git related mappings
| [lambdalisue/fern-bookmark.vim] | Fern bookmark plugin
| [yuki-yano/fern-preview.vim] | File preview window to fern.vim
| [lambdalisue/fern-renderer-nerdfont.vim] | Fern nerdfont integration
| [lambdalisue/glyph-palette.vim] | Universal nerdfont palette

#### Syntax

| Name           | Description
| -------------- | ----------------------
| [nvim-treesitter/nvim-treesitter] | Nvim Treesitter configurations and abstraction layer
| [nvim-treesitter/nvim-treesitter-textobjects] | textobjects using tree-sitter queries
| [chrisbra/csv.vim] | Handling column separated data
| [tpope/vim-git] | Git runtime files
| [dag/vim-fish] | Fish shell edit support
| [towolf/vim-helm] | Syntax for Helm templates (yaml + gotmpl + sprig)
| [mboughaba/i3config.vim] | i3 window manager config syntax
| [mustache/vim-mustache-handlebars] | Mustache and handlebars syntax
| [digitaltoad/vim-pug] | Pug (formerly Jade) syntax and indentation
| [keith/swift.vim] | Swift support
| [lifepillar/pgsql.vim] | PostgreSQL syntax and indent
| [chr4/nginx.vim] | Improved nginx syntax and indent
| [vim-jp/syntax-vim-ex] | Improved Vim syntax highlighting
| [MTDL9/vim-log-highlighting] | Syntax highlighting for generic log files
| [tmux-plugins/vim-tmux] | Plugin for tmux.conf
| [reasonml-editor/vim-reason-plus] | Reason syntax and indent
| [plasticboy/vim-markdown] | Markdown syntax highlighting
| [pearofducks/ansible-vim] | Improved YAML support for Ansible
| [hashivim/vim-terraform] | Base Terraform integration

#### Operators & Text Objects

| Name           | Description
| -------------- | ----------------------
| [machakann/vim-sandwich] | Search, select, and edit sandwich text objects
| [mfussenegger/nvim-ts-hint-textobject] | Region selection with hints on the AST nodes
| [AndrewRadev/sideways.vim] | Match function arguments
| [AndrewRadev/linediff.vim] | Perform diffs on blocks of code
| [AndrewRadev/splitjoin.vim] | Transition code between multi-line and single-line
| [AndrewRadev/dsf.vim] | Delete surrounding function call

[Shougo/dein.vim]: https://github.com/Shougo/dein.vim
[thinca/vim-localrc]: https://github.com/thinca/vim-localrc
[rafi/awesome-colorschemes]: https://github.com/rafi/awesome-vim-colorschemes
[christoomey/tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[tpope/vim-sleuth]: https://github.com/tpope/vim-sleuth
[folke/lsp-colors.nvim]: https://github.com/folke/lsp-colors.nvim
[nvim-lua/plenary.nvim]: https://github.com/nvim-lua/plenary.nvim
[nvim-lua/popup.nvim]: https://github.com/nvim-lua/popup.nvim
[kyazdani42/nvim-web-devicons]: https://github.com/kyazdani42/nvim-web-devicons
[sgur/vim-editorconfig]: https://github.com/sgur/vim-editorconfig

[mbbill/undotree]: https://github.com/mbbill/undotree
[tweekmonster/helpful.vim]: https://github.com/tweekmonster/helpful.vim
[lambdalisue/suda.vim]: https://github.com/lambdalisue/suda.vim
[tyru/caw.vim]: https://github.com/tyru/caw.vim
[TimUntersberger/neogit]: https://github.com/TimUntersberger/neogit
[lambdalisue/gina.vim]: https://github.com/lambdalisue/gina.vim
[folke/zen-mode.nvim]: https://github.com/folke/zen-mode.nvim
[folke/which-key.nvim]: https://github.com/folke/which-key.nvim
[tversteeg/registers.nvim]: https://github.com/tversteeg/registers.nvim
[NTBBloodbath/rest.nvim]: https://github.com/NTBBloodbath/rest.nvim
[pechorin/any-jump.vim]: https://github.com/pechorin/any-jump.vim
[kana/vim-niceblock]: https://github.com/kana/vim-niceblock
[t9md/vim-choosewin]: https://github.com/t9md/vim-choosewin
[mzlogin/vim-markdown-toc]: https://github.com/mzlogin/vim-markdown-toc
[Ron89/thesaurus_query.vim]: https://github.com/Ron89/thesaurus_query.vim

[itchyny/vim-gitbranch]: https://github.com/itchyny/vim-gitbranch
[romainl/vim-cool]: https://github.com/romainl/vim-cool
[haya14busa/vim-asterisk]: https://github.com/haya14busa/vim-asterisk
[rhysd/accelerated-jk]: https://github.com/rhysd/accelerated-jk
[haya14busa/vim-edgemotion]: https://github.com/haya14busa/vim-edgemotion
[t9md/vim-quickhl]: https://github.com/t9md/vim-quickhl
[rcarriga/nvim-notify]: https://github.com/rcarriga/nvim-notify
[rafi/vim-sidemenu]: https://github.com/rafi/vim-sidemenu
[hoob3rt/lualine.nvim]: https://github.com/hoob3rt/lualine.nvim
[itchyny/cursorword]: https://github.com/itchyny/vim-cursorword
[lewis6991/gitsigns.nvim]: https://github.com/lewis6991/gitsigns.nvim
[kshenoy/vim-signature]: https://github.com/kshenoy/vim-signature
[nathanaelkane/vim-indent-guides]: https://github.com/nathanaelkane/vim-indent-guides
[kevinhwang91/nvim-bqf]: https://github.com/kevinhwang91/nvim-bqf
[norcalli/nvim-colorizer.lua]: https://github.com/norcalli/nvim-colorizer.lua
[rmagatti/goto-preview]: https://github.com/rmagatti/goto-preview
[rhysd/committia.vim]: https://github.com/rhysd/committia.vim
[itchyny/calendar.vim]: https://github.com/itchyny/calendar.vim
[deris/vim-shot-f]: https://github.com/deris/vim-shot-f
[kristijanhusak/orgmode.nvim]: https://github.com/kristijanhusak/orgmode.nvim
[vimwiki/vimwiki]: https://github.com/vimwiki/vimwiki

[kabouzeid/nvim-lspinstall]: https://github.com/kabouzeid/nvim-lspinstall
[kosayoda/nvim-lightbulb]: https://github.com/kosayoda/nvim-lightbulb
[neovim/nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[ray-x/lsp_signature.nvim]: https://github.com/ray-x/lsp_signature.nvim
[folke/lua-dev.nvim]: https://github.com/folke/lua-dev.nvim
[folke/todo-comments.nvim]: https://github.com/folke/todo-comments.nvim
[hrsh7th/nvim-compe]: https://github.com/hrsh7th/nvim-compe
[andersevenrud/compe-tmux]: https://github.com/andersevenrud/compe-tmux
[windwp/nvim-autopairs]: https://github.com/windwp/nvim-autopairs
[hrsh7th/vim-vsnip]: https://github.com/hrsh7th/vim-vsnip
[hrsh7th/vim-vsnip-integ]: https://github.com/hrsh7th/vim-vsnip-integ
[rafamadriz/friendly-snippets]: https://github.com/rafamadriz/friendly-snippets
[folke/trouble.nvim]: https://github.com/folke/trouble.nvim
[sindrets/diffview.nvim]: https://github.com/sindrets/diffview.nvim
[nvim-telescope/telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[rmagatti/session-lens]: https://github.com/rmagatti/session-lens
[jvgrootveld/telescope-zoxide]: https://github.com/jvgrootveld/telescope-zoxide
[simrat39/symbols-outline.nvim]: https://github.com/simrat39/symbols-outline.nvim
[rmagatti/auto-session]: https://github.com/rmagatti/auto-session
[sbdchd/neoformat]: https://github.com/sbdchd/neoformat
[mattn/emmet-vim]: https://github.com/mattn/emmet-vim

[lambdalisue/fern.vim]: https://github.com/lambdalisue/fern.vim
[lambdalisue/nerdfont.vim]: https://github.com/lambdalisue/nerdfont.vim
[lambdalisue/fern-git-status.vim]: https://github.com/lambdalisue/fern-git-status.vim
[lambdalisue/fern-mapping-git.vim]: https://github.com/lambdalisue/fern-mapping-git.vim
[lambdalisue/fern-bookmark.vim]: https://github.com/lambdalisue/fern-bookmark.vim
[yuki-yano/fern-preview.vim]: https://github.com/yuki-yano/fern-preview.vim
[lambdalisue/fern-renderer-nerdfont.vim]: https://github.com/lambdalisue/fern-renderer-nerdfont.vim
[lambdalisue/glyph-palette.vim]: https://github.com/lambdalisue/glyph-palette.vim

[nvim-treesitter/nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nvim-treesitter/nvim-treesitter-textobjects]: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

[chrisbra/csv.vim]: https://github.com/chrisbra/csv.vim
[tpope/vim-git]: https://github.com/tpope/vim-git
[dag/vim-fish]: https://github.com/dag/vim-fish
[towolf/vim-helm]: https://github.com/towolf/vim-helm
[mboughaba/i3config.vim]: https://github.com/mboughaba/i3config.vim
[mustache/vim-mustache-handlebars]: https://github.com/mustache/vim-mustache-handlebars
[digitaltoad/vim-pug]: https://github.com/digitaltoad/vim-pug
[keith/swift.vim]: https://github.com/keith/swift.vim
[lifepillar/pgsql.vim]: https://github.com/lifepillar/pgsql.vim
[chr4/nginx.vim]: https://github.com/chr4/nginx.vim
[vim-jp/syntax-vim-ex]: https://github.com/vim-jp/syntax-vim-ex
[MTDL9/vim-log-highlighting]: https://github.com/MTDL9/vim-log-highlighting
[tmux-plugins/vim-tmux]: https://github.com/tmux-plugins/vim-tmux
[reasonml-editor/vim-reason-plus]: https://github.com/reasonml-editor/vim-reason-plus
[plasticboy/vim-markdown]: https://github.com/plasticboy/vim-markdown
[pearofducks/ansible-vim]: https://github.com/pearofducks/ansible-vim
[hashivim/vim-terraform]: https://github.com/hashivim/vim-terraform

[machakann/vim-sandwich]: https://github.com/machakann/vim-sandwich
[mfussenegger/nvim-ts-hint-textobject]: https://github.com/mfussenegger/nvim-ts-hint-textobject
[AndrewRadev/sideways.vim]: https://github.com/AndrewRadev/sideways.vim
[AndrewRadev/linediff.vim]: https://github.com/AndrewRadev/linediff.vim
[AndrewRadev/splitjoin.vim]: https://github.com/AndrewRadev/splitjoin.vim
[AndrewRadev/dsf.vim]: https://github.com/AndrewRadev/dsf.vim

</details>

## Custom Key-mappings

Note that,

* **Leader** key set as <kbd>Space</kbd>
* **Local-Leader** key set as <kbd>;</kbd> and used for navigation and search
  (Telescope and Fern)
* Disable <kbd>←</kbd> <kbd>↑</kbd> <kbd>→</kbd> <kbd>↓</kbd> in normal mode by enabling `g:elite_mode` in `.vault.vim`

<details open>
  <summary>
    <strong>Key-mappings</strong>
    <small><i>(🔎 Click to expand/collapse)</i></small>
  </summary>

<center>Modes: 𝐍=normal 𝐕=visual 𝐒=select 𝐈=insert 𝐂=command</center>

### Navigation

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>j</kbd> / <kbd>k</kbd> | 𝐍 𝐕 | Cursor moves through display-lines | `g` `j/k`
| <kbd>g</kbd>+<kbd>j</kbd> / <kbd>k</kbd> | 𝐍 𝐕 𝐒 | Jump to edge upward/downward | <small>[haya14busa/vim-edgemotion]</small>
| <kbd>gh</kbd> / <kbd>gl</kbd> | 𝐍 𝐕 | Easier line-wise movement | `g` `^/$`
| <kbd>Space</kbd>+<kbd>Space</kbd> | 𝐍 𝐕 | Toggle visual-line mode | `V` / <kbd>Escape</kbd>
| <kbd>zl</kbd> / <kbd>zh</kbd> | 𝐍 | Scroll horizontally and vertically wider | `z4` `l/h`
| <kbd>Ctrl</kbd>+<kbd>j</kbd> | 𝐍 | Move to split below | <small>[christoomey/tmux-navigator]</small>
| <kbd>Ctrl</kbd>+<kbd>k</kbd> | 𝐍 | Move to upper split | <small>[christoomey/tmux-navigator]</small>
| <kbd>Ctrl</kbd>+<kbd>h</kbd> | 𝐍 | Move to left split | <small>[christoomey/tmux-navigator]</small>
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | 𝐍 | Move to right split | <small>[christoomey/tmux-navigator]</small>
| <kbd>Return</kbd> | 𝐍 | Toggle fold | `za`
| <kbd>Shift</kbd>+<kbd>Return</kbd> | 𝐍 | Focus the current fold by closing all others | `zMzvzt`
| <kbd>]q</kbd> or <kbd>]q</kbd> | 𝐍 | Next/previous on quickfix list | `:cnext` / `:cprev`
| <kbd>]l</kbd> or <kbd>]l</kbd> | 𝐍 | Next/previous on location-list | `:lnext` / `:lprev`
| <kbd>]w</kbd> or <kbd>]w</kbd> | 𝐍 | Next/previous whitespace error | <small>[plugin/whitespace.vim]</small>
| <kbd>]g</kbd> or <kbd>]g</kbd> | 𝐍 | Next/previous Git hunk | <small>[lewis6991/gitsigns.nvim]</small>
| <kbd>]d</kbd> or <kbd>]d</kbd> | 𝐍 | Next/previous LSP diagnostic | <small>[lua/plugins/lspconfig.lua]</small>
| <kbd>Ctrl</kbd>+<kbd>f</kbd> | 𝐂 | Move cursor forwards in command | <kbd>Right</kbd>
| <kbd>Ctrl</kbd>+<kbd>b</kbd> | 𝐂 | Move cursor backwards in command | <kbd>Left</kbd>
| <kbd>Ctrl</kbd>+<kbd>h</kbd> | 𝐂 | Move cursor to the beginning in command | <kbd>Home</kbd>
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | 𝐂 | Move cursor to the end in command | <kbd>End</kbd>

### File Operations

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Space</kbd>+<kbd>cd</kbd> | 𝐍 | Switch to the directory of opened buffer | `:lcd %:p:h`
| <kbd>gf</kbd> | 𝐍 𝐕 | Open file under the cursor in a vsplit | `:rightbelow wincmd f`
| <kbd>Space</kbd>+<kbd>w</kbd> | 𝐍 𝐕 𝐒 | Write buffer to file | `:write`
| <kbd>Ctrl</kbd>+<kbd>s</kbd> | 𝐍 𝐕 𝐒 𝐂 | Write buffer to file | `:write`

### Edit

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Ctrl</kbd>+<kbd>Return</kbd> | 𝐈 | Expand emmet abbreviation | <small>[mattn/emmet-vim]</small>
| <kbd>Q</kbd> | 𝐍 | Start/stop macro recording | `q`
| <kbd>gQ</kbd> | 𝐍 | Play macro 'q' | `@q`
| <kbd>Shift</kbd>+<kbd>Return</kbd> | 𝐈 | Start new line from any cursor position | `<C-o>o`
| <kbd><</kbd> | 𝐕 𝐒 | Indent to left and re-select | `<gv`
| <kbd>></kbd> | 𝐕 𝐒 | Indent to right and re-select | `>gv|`
| <kbd>Tab</kbd> | 𝐕 𝐒 | Indent to right and re-select | `>gv|`
| <kbd>Shift</kbd>+<kbd>Tab</kbd> | 𝐕 𝐒 | Indent to left and re-select | `<gv`
| <kbd>gc</kbd> | 𝐍 𝐕 𝐒 | Caw (comments plugin) prefix | <small>[tyru/caw.vim]</small>
| <kbd>gcc</kbd> | 𝐍 𝐕 𝐒 | Toggle comments | <small>[tyru/caw.vim]</small>
| <kbd>Space</kbd>+<kbd>v</kbd> | 𝐍 𝐕 𝐒 | Toggle single-line comments | <small>[tyru/caw.vim]</small>
| <kbd>Space</kbd>+<kbd>V</kbd> | 𝐍 𝐕 𝐒 | Toggle comment block | <small>[tyru/caw.vim]</small>
| <kbd>Space</kbd>+<kbd>j</kbd> or <kbd>k</kbd> | 𝐍 𝐕 | Move lines down/up | `:m` …
| <kbd>Space</kbd>+<kbd>d</kbd> | 𝐍 𝐕 | Duplicate line or selection |
| <kbd>Space</kbd>+<kbd>cn</kbd> / <kbd>cN</kbd> | 𝐍 𝐕 | Change current word in a repeatable manner |
| <kbd>Space</kbd>+<kbd>cp</kbd> | 𝐍 | Duplicate paragraph | `yap<S-}>p`
| <kbd>Space</kbd>+<kbd>cw</kbd> | 𝐍 | Remove all spaces at EOL | `:%s/\s\+$//e`
| <kbd>sj</kbd> / <kbd>sk</kbd> | 𝐍 | Join/split arguments | <small>[AndrewRadev/splitjoin.vim]</small>
| <kbd>dsf</kbd> / <kbd>csf</kbd> | 𝐍 | Delete/change surrounding function call | <small>[AndrewRadev/dsf.vim]</small>

### Search & Replace

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>\*</kbd> / <kbd>#</kbd> | 𝐍 𝐕 | Search selection forward/backward | <small>[haya14busa/vim-asterisk]</small>
| <kbd>g\*</kbd> / <kbd>g#</kbd> | 𝐍 𝐕 | Search whole-word forward/backward | <small>[haya14busa/vim-asterisk]</small>
| <kbd>Backspace</kbd> | 𝐍 | Match bracket | `%`
| <kbd>gp</kbd> | 𝐍 | Select last paste |
| <kbd>sg</kbd> | 𝐕 | Replace within selected area | `:s/⌴/gc`
| <kbd>Ctrl</kbd>+<kbd>r</kbd> | 𝐕 | Replace selection with step-by-step confirmation | `:%s/\V/⌴/gc`

### Clipboard

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>p</kbd> | 𝐕 𝐒 | Paste without yank | <small>s:visual_paste</small>
| <kbd>Y</kbd> | 𝐍 | Yank to the end of line | `y$`
| <kbd>Space</kbd>+<kbd>y</kbd> | 𝐍 | Copy relative file-path to clipboard |
| <kbd>Space</kbd>+<kbd>Y</kbd> | 𝐍 | Copy absolute file-path to clipboard |

### Command & History

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>!</kbd> | 𝐍 | Shortcut for shell command | `:!`
| <kbd>g!</kbd> | 𝐍 | Read vim command into buffer | `:put=execute('⌴')`
| <kbd>Ctrl</kbd>+<kbd>n</kbd> / <kbd>p</kbd> | 𝐂 | Switch history search pairs | <kbd>↓</kbd> / <kbd>↑</kbd>
| <kbd>↓</kbd> / <kbd>↑</kbd> | 𝐂 | Switch history search pairs | `Ctrl` `n`/`p`

### Editor UI

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Space</kbd>+<kbd>ts</kbd> | 𝐍 | Toggle spell-checker | <small>`:setlocal spell!`</small>
| <kbd>Space</kbd>+<kbd>tn</kbd> | 𝐍 | Toggle line numbers | <small>`:setlocal nonumber!`</small>
| <kbd>Space</kbd>+<kbd>tl</kbd> | 𝐍 | Toggle hidden characters | <small>`:setlocal nolist!`</small>
| <kbd>Space</kbd>+<kbd>th</kbd> | 𝐍 | Toggle highlighted search | <small>`:set hlsearch!`</small>
| <kbd>Space</kbd>+<kbd>tw</kbd> | 𝐍 | Toggle wrap | <small>`:setlocal wrap!`</small> …
| <kbd>Space</kbd>+<kbd>ti</kbd> | 𝐍 | Toggle indentation lines | <small>[nathanaelkane/vim-indent-guides]</small>
| <kbd>g1</kbd> | 𝐍 | Go to first tab | `:tabfirst`
| <kbd>g9</kbd> | 𝐍 | Go to last tab | `:tablast`
| <kbd>g5</kbd> | 𝐍 | Go to previous tab | `:tabprevious`
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | 𝐍 | Go to next tab | `:tabnext`
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd><kbd>Tab</kbd> | 𝐍 | Go to previous tab | `:tabprevious`
| <kbd>Alt</kbd>+<kbd>j</kbd> | 𝐍 | Go to next tab | `:tabnext`
| <kbd>Alt</kbd>+<kbd>k</kbd> | 𝐍 | Go to previous tab | `:tabprevious`
| <kbd>Alt</kbd>+<kbd>{</kbd> | 𝐍 | Move tab backward | `:-tabmove`
| <kbd>Alt</kbd>+<kbd>}</kbd> | 𝐍 | Move tab forward | `:+tabmove`
| <kbd>Space</kbd>+<kbd>h</kbd> | 𝐍 | Show highlight groups for word |

### Custom Tools & Plugins

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>-</kbd> | 𝐍 | Choose a window to edit | <small>[t9md/vim-choosewin]</small>
| <kbd>;</kbd>+<kbd>c</kbd> | 𝐍 | Open context-menu | <small>[plugin/actionmenu.vim]</small>
| <kbd>g</kbd><kbd>Ctrl</kbd>+<kbd>o</kbd> | 𝐍 | Navigate to previous file on jumplist | <small>s:jump_buffer</small>
| <kbd>g</kbd><kbd>Ctrl</kbd>+<kbd>i</kbd> | 𝐍 | Navigate to next file on jumplist | <small>s:jump_buffer</small>
| <kbd>Space</kbd>+<kbd>l</kbd> | 𝐍 | Open side-menu helper | <small>[rafi/vim-sidemenu]</small>
| <kbd>Space</kbd>+<kbd>o</kbd> | 𝐍 | Open structure window | <small>[simrat39/symbols-outline.nvim]</small>
| <kbd>Space</kbd>+<kbd>S</kbd> | 𝐍 𝐕 | Source selection | `y:execute @@`
| <kbd>Space</kbd>+<kbd>?</kbd> | 𝐍 | Open the macOS dictionary on current word | `:!open dict://`
| <kbd>Space</kbd>+<kbd>P</kbd> | 𝐍 | Use Marked 2 for real-time Markdown preview | <small>[Marked 2]</small>
| <kbd>Space</kbd>+<kbd>ml</kbd> | 𝐍 | Append modeline to end of buffer | <small>[config/mappings.vim]</small>
| <kbd>Space</kbd>+<kbd>mda</kbd> | 𝐕 | Sequentially mark region for diff | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mdf</kbd> | 𝐕 | Mark region for diff and compare if more than one | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mds</kbd> | 𝐍 | Shows the comparison for all marked regions | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mdr</kbd> | 𝐍 | Removes the signs denoting the diff regions | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mt</kbd> | 𝐍 𝐕 | Toggle highlighted word | <small>[t9md/vim-quickhl]</small>
| <kbd>Space</kbd>+<kbd>-</kbd> | 𝐍 | Switch editing window with selected | <small>[t9md/vim-choosewin]</small>
| <kbd>Space</kbd>+<kbd>z</kbd> | 𝐍 | Toggle distraction-free writing | <small>[folke/zen-mode.nvim]</small>
| <kbd>Space</kbd>+<kbd>gu</kbd> | 𝐍 | Open undo-tree | <small>[mbbill/undotree]</small>
| <kbd>Space</kbd>+<kbd>K</kbd> | 𝐍 | Thesaurus | <small>[Ron89/thesaurus_query.vim]</small>
| <kbd>Space</kbd>+<kbd>W</kbd> | 𝐍 | VimWiki | <small>[vimwiki/vimwiki]</small>

### Window Management

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>q</kbd> | 𝐍 | Quit window (and Vim, if last window) | `:quit`
| <kbd>Ctrl</kbd>+<kbd>q</kbd> | 𝐍 | Remap to C-w | <kbd>Ctrl</kbd>+<kbd>w</kbd>
| <kbd>Ctrl</kbd>+<kbd>x</kbd> | 𝐍 | Rotate window placement | `C-w` `x`
| <kbd>sv</kbd> | 𝐍 | Horizontal split | `:split`
| <kbd>sg</kbd> | 𝐍 | Vertical split | `:vsplit`
| <kbd>st</kbd> | 𝐍 | Open new tab | `:tabnew`
| <kbd>so</kbd> | 𝐍 | Close other windows | `:only`
| <kbd>sb</kbd> | 𝐍 | Previous buffer | `:b#`
| <kbd>sc</kbd> | 𝐍 | Close current buffer | `:close`
| <kbd>sq</kbd> | 𝐍 | Quit window | `:quit`
| <kbd>sx</kbd> | 𝐍 | Delete buffer, leave blank window | `:enew │ bdelete`
| <kbd>sz</kbd> | 𝐍 | Toggle window zoom | `:vertical resize │ resize`
| <kbd>ssv</kbd> | 𝐍 | Split with previous buffer | `:split │ wincmd p │ e#`
| <kbd>ssg</kbd> | 𝐍 | Vertical split with previous buffer | `:vsplit │ wincmd p │ e#`
| <kbd>sh</kbd> | 𝐍 | Toggle colorscheme background=dark/light | `:set background` …
| <kbd>s-</kbd> | 𝐍 | Lower solarized8 colorscheme contrast | `:colorscheme ` …
| <kbd>s=</kbd> | 𝐍 | Raise solarized8 colorscheme contrast | `:colorscheme ` …

### Plugin: Gitsigns

| Key   | Mode | Action             |
| ----- |:----:| ------------------ |
| <kbd>gs</kbd> | 𝐍 | Preview hunk |
| <kbd>Space</kbd>+<kbd>hp</kbd> | 𝐍 | Preview hunk |
| <kbd>Space</kbd>+<kbd>hb</kbd> | 𝐍 | Blame line |
| <kbd>Space</kbd>+<kbd>hs</kbd> | 𝐍 𝐕 | Stage hunk |
| <kbd>Space</kbd>+<kbd>hu</kbd> | 𝐍 | Undo stage hunk |
| <kbd>Space</kbd>+<kbd>hr</kbd> | 𝐍 𝐕 | Reset hunk |
| <kbd>Space</kbd>+<kbd>hR</kbd> | 𝐍 | Reset buffer |

### Plugin: Gina

| Key   | Mode | Action             |
| ----- |:----:| ------------------ |
| <kbd>Space</kbd>+<kbd>ga</kbd> | 𝐍 | Git add current file |
| <kbd>Space</kbd>+<kbd>gd</kbd> | 𝐍 | Git diff |
| <kbd>Space</kbd>+<kbd>gc</kbd> | 𝐍 | Git branches |
| <kbd>Space</kbd>+<kbd>gc</kbd> | 𝐍 | Git commit |
| <kbd>Space</kbd>+<kbd>gb</kbd> | 𝐍 | Git blame |
| <kbd>Space</kbd>+<kbd>gs</kbd> | 𝐍 | Git status -s |
| <kbd>Space</kbd>+<kbd>gl</kbd> | 𝐍 | Git log --all |
| <kbd>Space</kbd>+<kbd>gF</kbd> | 𝐍 | Git fetch |
| <kbd>Space</kbd>+<kbd>gp</kbd> | 𝐍 | Git push |
| <kbd>Space</kbd>+<kbd>go</kbd> | 𝐍 𝐕 | Open SCM detailed URL in browser |

### Plugin: Telescope

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>;f</kbd> | 𝐍 | File search
| <kbd>;g</kbd> | 𝐍 | Grep search
| <kbd>;b</kbd> | 𝐍 | Buffers
| <kbd>;x</kbd> | 𝐍 | Old files
| <kbd>;v</kbd> | 𝐍 𝐕 | Yank history
| <kbd>;m</kbd> | 𝐍 | Marks
| <kbd>;n</kbd> | 𝐍 | Dein plugin list
| <kbd>;j</kbd> | 𝐍 | Jump points
| <kbd>;u</kbd> | 𝐍 | Spelling suggestions
| <kbd>;o</kbd> | 𝐍 | Vim options
| <kbd>;s</kbd> | 𝐍 | Sessions
| <kbd>;t</kbd> | 𝐍 | LSP workspace symbols
| <kbd>;h</kbd> | 𝐍 | Highlights
| <kbd>;w</kbd> | 𝐍 | Memo list
| <kbd>;z</kbd> | 𝐍 | Zoxide directories
| <kbd>;;</kbd> | 𝐍 | Command history
| <kbd>;/</kbd> | 𝐍 | Search history
| <kbd>Space</kbd>+<kbd>gt</kbd> | 𝐍 | Find symbols matching word under cursor
| <kbd>Space</kbd>+<kbd>gf</kbd> | 𝐍 | Find files matching word under cursor
| <kbd>Space</kbd>+<kbd>gg</kbd> | 𝐍 𝐕 | Grep word under cursor
| **Within _Telescope_ window** ||
| <kbd>jj</kbd> or <kbd>Escape</kbd> | 𝐈 | Leave Insert mode
| <kbd>i</kbd> | 𝐍 | Enter Insert mode (filter input)
| <kbd>q</kbd> or <kbd>Escape</kbd> | 𝐍 | Exit denite window
| <kbd>Tab</kbd> or <kbd>Shift</kbd>+<kbd>Tab</kbd> | 𝐍 𝐈 | Next/previous candidate
| <kbd>J</kbd> or <kbd>J</kbd> | 𝐍 | Select candidates up/downwards
| <kbd>dd</kbd> | 𝐍 | Delete entry
| <kbd>st</kbd> | 𝐍 | Open in a new tab
| <kbd>sg</kbd> | 𝐍 | Open in a vertical split
| <kbd>sv</kbd> | 𝐍 | Open in a split

### Plugin: Fern

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>;e</kbd> | 𝐍 | Open file-explorer (toggle)
| <kbd>;a</kbd> | 𝐍 | Focus current file in file-explorer
| **Within _Fern_ window** ||
| <kbd>j</kbd> or <kbd>k</kbd> | 𝐍 | Move up and down the tree
| <kbd>l</kbd> or <kbd>Return</kbd> | 𝐍 | Toggle collapse/expand directory or open file
| <kbd>h</kbd> | 𝐍 | Collapse directory tree
| <kbd>!</kbd> | 𝐍 | Toggle hidden files
| <kbd>Space</kbd> | 𝐍 | Select entry
| <kbd>^</kbd> | 𝐍 | Change into current working directory
| <kbd>Backspace</kbd> | 𝐍 | Change into parent directory
| <kbd>st</kbd> | 𝐍 | Open file in new tab
| <kbd>sv</kbd> | 𝐍 | Open file in a horizontal split
| <kbd>sg</kbd> | 𝐍 | Open file in a vertical split
| <kbd>N</kbd> | 𝐍 | Create new directories and/or files
| <kbd>K</kbd> | 𝐍 | Create new directory
| <kbd>c</kbd> / <kbd>m</kbd> | 𝐍 | Copy/move
| <kbd>R</kbd> | 𝐍 | Rename file or directory
| <kbd>D</kbd> | 𝐍 | Trash selected files and directories
| <kbd>yy</kbd> | 𝐍 | Yank path to clipboard
| <kbd>w</kbd> | 𝐍 | Toggle window size
| <kbd>x</kbd> or <kbd>gx</kbd> | 𝐍 | Execute associated system application
| <kbd>gr</kbd> | 𝐍 | Grep in current position
| <kbd>gf</kbd> | 𝐍 | Find files in current position

### Plugin: LSP

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Tab</kbd> / <kbd>Shift-Tab</kbd> | 𝐈 | Navigate completion-menu
| <kbd>Enter</kbd> | 𝐈 | Select completion or expand snippet
| <kbd>Ctrl</kbd>+<kbd>j</kbd>/<kbd>k</kbd>/<kbd>d</kbd>/<kbd>u</kbd> | 𝐈 | Movement in completion pop-up
| <kbd>Ctrl</kbd>+<kbd>Return</kbd> | 𝐈 | Expand Emmet sequence
| <kbd>Ctrl</kbd>+<kbd>Space</kbd> | 𝐈 | Refresh and show candidates
| <kbd>Ctrl</kbd>+<kbd>y</kbd> | 𝐈 | Close pop-up
| <kbd>Ctrl</kbd>+<kbd>e</kbd> | 𝐈 | Cancel selection and close pop-up
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | 𝐈 | Expand snippet at cursor
| <kbd>Tab</kbd> / <kbd>Shift-Tab</kbd> | 𝐈 𝐒 | Navigate snippet placeholders

### Plugin: Any-Jump

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Space</kbd>+<kbd>ii</kbd> | 𝐍 | Jump to definition under cursor
| <kbd>Space</kbd>+<kbd>ii</kbd> | 𝐕 | Jump to selected text in visual mode
| <kbd>Space</kbd>+<kbd>ib</kbd> | 𝐍 | Open previous opened file (after jump)
| <kbd>Space</kbd>+<kbd>il</kbd> | 𝐍 | Open last closed search window again

### Plugin: Signature

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>m/</kbd> or <kbd>m?</kbd> | 𝐍 | Show list of buffer marks/markers
| <kbd>mm</kbd> | 𝐍 | Toggle mark on current line
| <kbd>m,</kbd> | 𝐍 | Place next mark
| <kbd>m</kbd> <kbd>a-z</kbd> | 𝐍 | Place specific mark (Won't work for: <kbd>mm</kbd>, <kbd>mn</kbd>, <kbd>mp</kbd>)
| <kbd>dm</kbd> <kbd>a-z</kbd> | 𝐍 | Remove specific mark (Won't work for: <kbd>mm</kbd>, <kbd>mn</kbd>, <kbd>mp</kbd>)
| <kbd>mn</kbd> | 𝐍 | Jump to next mark
| <kbd>mp</kbd> | 𝐍 | Jump to previous mark
| <kbd>]=</kbd> | 𝐍 | Jump to next marker
| <kbd>[=</kbd> | 𝐍 | Jump to previous marker
| <kbd>m-</kbd> | 𝐍 | Purge all on current line
| <kbd>m</kbd> <kbd>Space</kbd> | 𝐍 | Purge marks
| <kbd>m</kbd> <kbd>Backspace</kbd> | 𝐍 | Purge markers

</details>

[Neovim]: https://github.com/neovim/neovim
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[nvim-compe]: https://github.com/hrsh7th/nvim-compe
[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[lazy-loaded]: ./config/plugins.yaml#L39
[config/mappings.vim]: ./config/mappings.vim
[plugin/whitespace.vim]: ./plugin/whitespace.vim
[plugin/actionmenu.vim]: ./plugin/actionmenu.vim
[lua/plugins/lspconfig.lua]: ./lua/plugins/lspconfig.lua
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[Marked 2]: https://marked2app.com
