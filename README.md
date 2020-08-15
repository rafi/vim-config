# Rafael Bodill's Neo/vim Config

Lean mean Neo/vim machine, 30-45ms startup time.

Best with [Neovim] or [Vim8] and `python3` enabled.

> I encourage you to fork this repo and create your own experience.
> Learn how to tweak and change Neo/vim to the way YOU like it.
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
    * [Language](#language)
    * [Commands](#commands)
    * [Interface](#interface)
    * [Completion & Code-Analysis](#completion--code-analysis)
    * [Denite](#denite)
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
  * [Git Version Control](#git-version-control)
  * [Plugin: Denite](#plugin-denite)
  * [Plugin: Defx](#plugin-defx)
  * [Plugin: Asyncomplete and Emmet](#plugin-asyncomplete-and-emmet)
  * [Plugin: Signature](#plugin-signature)
* [Credits & Contribution](#credits--contribution)

<!-- vim-markdown-toc -->
</details>

## Features

* Fast startup time
* Robust, yet light-weight
* Lazy-load 95% of plugins with [Shougo/dein.vim]
* Custom side-menu (try it out! <kbd>Space</kbd>+<kbd>l</kbd>)
* Custom context-menu (try it! <kbd>;</kbd>+<kbd>c</kbd>)
* Modular configuration (see [structure](#structure))
* Auto-complete [prabirshrestha/asyncomplete.vim] extensive setup
* [Shougo/denite.nvim] centric work-flow (lists)
* Structure view with [liuchengxu/vista.vim]
* Open SCM detailed URL in OS browser
* Light-weight but informative status/tabline
* Easy customizable theme
* Premium color-schemes
* Central location for tags and sessions

## Screenshot

![Vim screenshot](http://rafi.io/static/img/project/vim-config/features.png)

## Prerequisites

* Python 3 (`brew install python`)
* Neovim or Vim (`brew install neovim` and/or `brew install vim`)

## Install

**_1._** Let's clone this repo! Clone to `~/.config/nvim`,
we'll also symlink it for regular Vim:

```bash
mkdir ~/.config
git clone git://github.com/rafi/vim-config.git ~/.config/nvim
cd ~/.config/nvim
ln -s ~/.config/nvim ~/.vim  # For "regular" Vim
```

* _**Note**:_ If you set a custom `$XDG_CONFIG_HOME`,
  use that instead of `~/.config` in the commands above.
  Neovim follows the XDG base-directories convention, Vim doesn't.

**_2._** Install the Python 3 `pynvim` library. This is also needed for Vim 8
if you want to use Denite and Defx.

> Neovim: `./venvs.sh` or `pip3 install --user pynvim`

> Vim: `pip3 install --user pynvim`

**_3._** Run `make test` to test your nvim/vim version and capabilities.

**_4._** Run `make` to install all plugins.

**_5._** If you are experiencing problems, run and read `nvim -c checkhealth`

Test Python 3 availability with `:py3 print(sys.version_info)`

Enjoy! :smile:

## Language-Server Protocol (LSP)

To leverage LSP auto-completions and other functionalities, once you open a
file in Neo/vim, run `:LspInstallServer` to use [mattn/vim-lsp-settings]
installation feature.

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
for example, to install the [Hack](https://sourcefoundry.org/hack/) font:

```bash
brew tap homebrew/cask-fonts
brew search nerd-font
brew cask install font-hack-nerd-font
brew cask install font-iosevka-nerd-font-mono
brew cask install font-jetbrains-mono
brew cask install font-fira-code
```

[Pragmata Pro]: https://www.fsd.it/shop/fonts/pragmatapro/
[Nerd Fonts]: https://www.nerdfonts.com

### Recommended Linters

* macOS with Homebrew:

```sh
brew install shellcheck jsonlint yamllint tflint ansible-lint
brew install tidy-html5 proselint write-good
```

* Node.js based linters:

```sh
yarn global add eslint jshint jsxhint stylelint sass-lint
yarn global add markdownlint-cli raml-cop
```

* Python based linters:

```sh
pip3 install --user vim-vint pycodestyle pyflakes flake8
```

### Recommended Tools

* **ag** [ggreer/the_silver_searcher](https://github.com/ggreer/the_silver_searcher)
  (macOS: `brew install the_silver_searcher`)
  * and/or **ripgrep**: [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
  (macOS: `brew install rg`)
* Jump around with **z**: [rupa/z](https://github.com/rupa/z)
  (macOS: `brew install z`)
  * or **z.lua**: [acme/zlua](https://github.com/skywind3000/z.lua)
* **[Universal ctags](https://ctags.io/)** for syntax tokenization
  (macOS: `brew install universal-ctags/universal-ctags/universal-ctags`)
* Fuzzy file finders:
  **[fzf](https://github.com/junegunn/fzf)**,
  **[fzy](https://github.com/jhawthorn/fzy)**, or
  **[peco](https://github.com/peco/peco)**
  (macOS: `brew install fzf`)

## User Custom Config

If you want to add your own configuration, create the `config/local.vim` file
and add your personal vimscript there. If you'd like to install plugins by
yourself, create a `config/local.plugins.yaml` file and manage your own plugin
collection.

If you want to disable some of the plugins I use, you can overwrite them, e.g.:

```yaml
- { repo: prabirshrestha/asyncomplete.vim, if: 0 }
```

## Structure

* [config/](./config) - Configuration
  * [plugins/](./config/plugins) - Plugin configurations
    * [all.vim](./config/plugins/all.vim) - Plugin mappings
    * […](./config/plugins)
  * [filetype.vim](./config/filetype.vim) - Language behavior
  * [general.vim](./config/general.vim) - General configuration
  * **local.plugins.yaml** - Custom user plugins
  * **local.vim** - Custom user settings
  * [mappings.vim](./config/mappings.vim) - Key-mappings
  * [plugins.yaml](./config/plugins.yaml) - My favorite _**Plugins!**_
  * [terminal.vim](./config/terminal.vim) - Terminal configuration
  * [vimrc](./config/vimrc) - Initialization
* [ftplugin/](./ftplugin) - Language specific custom settings
* [plugin/](./plugin) - Customized small plugins
* [snippets/](./snippets) - Personal code snippets
* [themes/](./themes) - Colorscheme overrides
* [filetype.vim](./filetype.vim) - Custom filetype detection

## Plugin Highlights

* Plugin management with cache and lazy loading for speed
* Auto-completion with Language-Server Protocol (LSP)
* Project-aware tabs and labels
* Defx as file-manager + Git status icons
* Extensive language extensions library

_Note_ that 95% of the plugins are **[lazy-loaded]**.

## Plugins Included

<details open>
  <summary><strong>List</strong> <small><i>(🔎 Click to expand/collapse)</i></small></summary>

### Non Lazy-Loaded Plugins

| Name           | Description
| -------------- | ----------------------
| [Shougo/dein.vim] | Dark powered Vim/Neovim plugin manager
| [rafi/awesome-colorschemes] | Awesome color-schemes
| [itchyny/vim-gitbranch] | Lightweight git branch detection
| [itchyny/vim-parenmatch] | Efficient alternative to the standard matchparen plugin
| [thinca/vim-localrc] | Enable configuration file of each directory
| [romainl/vim-cool] | Simple plugin that makes hlsearch more useful
| [sgur/vim-editorconfig] | EditorConfig plugin written entirely in Vimscript
| [christoomey/tmux-navigator] | Seamless navigation between tmux panes and vim splits
| [tpope/vim-sleuth] | Heuristically set buffer indent options
| [roxma/nvim-yarp] | Vim8 remote plugin framework for Neovim
| [roxma/vim-hug-neovim-rpc] | Vim8 compatibility layer for neovim rpc client

### Lazy-Loaded Plugins

#### Language

| Name           | Description
| -------------- | ----------------------
| [hail2u/vim-css3-syntax] | CSS3 syntax support to vim's built-in `syntax/css.vim`
| [othree/csscomplete.vim] | Updated built-in CSS complete with latest standards
| [cakebaker/scss-syntax.vim] | Syntax file for scss (Sassy CSS)
| [groenewege/vim-less] | Syntax for LESS
| [iloginow/vim-stylus] | Syntax, indentation and autocomplete for Stylus
| [mustache/vim-mustache-handlebars] | Mustache and handlebars syntax
| [digitaltoad/vim-pug] | Pug (formerly Jade) syntax and indentation
| [othree/html5.vim] | HTML5 omnicomplete and syntax
| [plasticboy/vim-markdown] | Markdown syntax highlighting
| [rhysd/vim-gfm-syntax] | GitHub Flavored Markdown syntax highlight extension
| [pangloss/vim-javascript] | Enhanced Javascript syntax
| [HerringtonDarkholme/yats.vim] | Advanced TypeScript Syntax Highlighting
| [MaxMEllon/vim-jsx-pretty] | React JSX syntax pretty highlighting
| [leafOfTree/vim-svelte-plugin] | Syntax and indent plugin for Svelte
| [heavenshell/vim-jsdoc] | Generate JSDoc to your JavaScript code
| [jparise/vim-graphql] | GraphQL file detection, syntax highlighting, and indentation
| [moll/vim-node] | Superb development with Node.js
| [kchmck/vim-coffee-script] | CoffeeScript support
| [elzr/vim-json] | Better JSON support
| [posva/vim-vue] | Syntax Highlight for Vue.js components
| [fatih/vim-go] | Go development
| [vim-python/python-syntax] | Enhanced version of the original Python syntax
| [Vimjas/vim-python-pep8-indent] | A nicer Python indentation style
| [vim-scripts/python_match.vim] | Extend the % motion for Python files
| [raimon49/requirements.txt.vim] | Python requirements file format
| [StanAngeloff/php.vim] | Up-to-date PHP syntax file (5.3 – 7.1 support)
| [tbastos/vim-lua] | Lua 5.3 syntax and indentation improved support
| [vim-ruby/vim-ruby] | Ruby support
| [keith/swift.vim] | Swift support
| [rust-lang/rust.vim] | Rust support
| [vim-jp/syntax-vim-ex] | Improved Vim syntax highlighting
| [chrisbra/csv.vim] | Handling column separated data
| [tpope/vim-git] | Git runtime files
| [ekalinin/Dockerfile.vim] | Syntax and snippets for Dockerfile
| [tmux-plugins/vim-tmux] | Plugin for tmux.conf
| [MTDL9/vim-log-highlighting] | Syntax highlighting for generic log files
| [cespare/vim-toml] | Syntax for TOML
| [mboughaba/i3config.vim] | i3 window manager config syntax
| [dag/vim-fish] | Fish shell edit support
| [jstrater/mpvim] | Macports portfile configuration files
| [robbles/logstash.vim] | Highlights logstash configuration files
| [lifepillar/pgsql.vim] | PostgreSQL syntax and indent
| [chr4/nginx.vim] | Improved nginx syntax and indent
| [towolf/vim-helm] | Syntax for Helm templates (yaml + gotmpl + sprig)
| [pearofducks/ansible-vim] | Improved YAML support for Ansible
| [hashivim/vim-terraform] | Base Terraform integration

#### Commands

| Name           | Description
| -------------- | ----------------------
| [Shougo/defx.nvim] | Dark powered file explorer implementation
| [kristijanhusak/defx-git] | Git status implementation for Defx
| [kristijanhusak/defx-icons] | Filetype icons for Defx
| [tyru/caw.vim] | Robust comment plugin with operator support
| [Shougo/context_filetype.vim] | Context filetype detection for nested code
| [liuchengxu/vim-which-key] | Shows key-bindings in pop-up
| [mbbill/undotree] | Ultimate undo history visualizer
| [reedes/vim-wordy] | Uncover usage problems in your writing
| [jreybert/vimagit] | Ease your git work-flow within Vim
| [tweekmonster/helpful.vim] | Display vim version numbers in docs
| [lambdalisue/gina.vim] | Asynchronously control git repositories
| [kana/vim-altr] | Switch to the alternate file without interaction
| [Shougo/vinarise.vim] | Hex editor
| [guns/xterm-color-table.vim] | Display 256 xterm colors with their RGB equivalents
| [cocopon/colorswatch.vim] | Generate a beautiful color swatch for the current buffer
| [dstein64/vim-startuptime] | Visually profile Vim's startup time
| [brooth/far.vim] | Fast find and replace plugin
| [jaawerth/nrun.vim] | "which" and "exec" functions targeted at local node project bin
| [Vigemus/iron.nvim] | Interactive REPL over Neovim
| [kana/vim-niceblock] | Make blockwise Visual mode more useful
| [t9md/vim-choosewin] | Choose window to use, like tmux's 'display-pane'
| [lambdalisue/suda.vim] | An alternative sudo.vim for Vim and Neovim
| [mzlogin/vim-markdown-toc] | Generate table of contents for Markdown files
| [liuchengxu/vista.vim] | Viewer & Finder for LSP symbols and tags in Vim
| [junegunn/fzf] | Powerful command-line fuzzy finder
| [junegunn/fzf.vim] | Fzf integration
| [Ron89/thesaurus_query.vim] | Multi-language thesaurus query and replacement

#### Interface

| Name           | Description
| -------------- | ----------------------
| [haya14busa/vim-asterisk] | Improved * motions
| [rhysd/accelerated-jk] | Up/down movement acceleration
| [haya14busa/vim-edgemotion] | Jump to the edge of block
| [t9md/vim-quickhl] | Highlight words quickly
| [hotwatermorning/auto-git-diff] | Display Git diff for interactive rebase
| [rafi/vim-sidemenu] | Small side-menu useful for terminal users
| [machakann/vim-highlightedyank] | Make the yanked region apparent
| [wellle/context.vim] | Show context of current visible code hierarchy
| [itchyny/cursorword] | Underlines word under cursor
| [airblade/vim-gitgutter] | Show git changes at Vim gutter and un/stages hunks
| [kshenoy/vim-signature] | Display and toggle marks
| [nathanaelkane/vim-indent-guides] | Visually display indent levels in code
| [rhysd/committia.vim] | Pleasant editing on Git commit messages
| [junegunn/goyo] | Distraction-free writing
| [junegunn/limelight] | Hyperfocus-writing
| [itchyny/calendar.vim] | Calendar application
| [deris/vim-shot-f] | Highlight characters to move directly with f/t/F/T
| [vimwiki/vimwiki] | Personal Wiki for Vim
| [norcalli/nvim-colorizer.lua] | The fastest Neovim colorizer

#### Completion & Code-Analysis

| Name           | Description
| -------------- | ----------------------
| [prabirshrestha/async.vim] | Normalize async job control API for Vim and Neovim
| [prabirshrestha/asyncomplete.vim] | Async-completion in pure Vimscript for Vim8 and Neovim
| [prabirshrestha/asyncomplete-lsp.vim] | Provide Language Server Protocol autocompletion source
| [prabirshrestha/vim-lsp] | Async Language Server Protocol plugin for Vim and Neovim
| [mattn/vim-lsp-settings] | Auto LSP configurations for vim-lsp
| [Shougo/neco-vim] | Completion source for Vimscript
| [prabirshrestha/asyncomplete-necovim.vim] | Provides syntax autocomplete via neco-vim
| [prabirshrestha/asyncomplete-buffer.vim] | Provides buffer autocomplete
| [prabirshrestha/asyncomplete-tags.vim] | Provides tag autocomplete via vim tagfiles
| [prabirshrestha/asyncomplete-file.vim] | Provides file autocomplete
| [wellle/tmux-complete.vim] | Completion of words in adjacent tmux panes
| [prabirshrestha/asyncomplete-ultisnips.vim] | Provides UltiSnips autocomplete
| [SirVer/ultisnips] | Ultimate snippet solution
| [honza/vim-snippets] | Community-maintained snippets for programming languages
| [mattn/emmet-vim] | Provides support for expanding abbreviations alá emmet
| [ncm2/float-preview.nvim] | Less annoying completion preview window
| [ludovicchabant/vim-gutentags] | Manages your tag files
| [Raimondi/delimitMate] | Auto-completion for quotes, parens, brackets

#### Denite

| Name           | Description
| -------------- | ----------------------
| [Shougo/denite.nvim] | Dark powered asynchronous unite all interfaces
| [Shougo/neomru.vim] | Denite plugin for MRU
| [Shougo/neoyank.vim] | Denite plugin for yank history
| [Shougo/junkfile.vim] | Denite plugin for temporary files
| [chemzqm/unite-location] | Denite location & quickfix lists
| [rafi/vim-denite-session] | Browse and open sessions
| [rafi/vim-denite-z] | Filter and browse Z (jump around) data file

#### Operators & Text Objects

| Name           | Description
| -------------- | ----------------------
| [kana/vim-operator-user] | Define your own custom operators
| [kana/vim-operator-replace] | Operator to replace text with register content
| [machakann/vim-sandwich] | Search, select, and edit sandwich text objects
| [kana/vim-textobj-user] | Create your own text objects
| [terryma/vim-expand-region] | Visually select increasingly larger regions of text
| [AndrewRadev/sideways.vim] | Match function arguments
| [AndrewRadev/splitjoin.vim] | Transition code between multi-line and single-line
| [AndrewRadev/linediff.vim] | Perform diffs on blocks of code
| [AndrewRadev/dsf.vim] | Delete surrounding function call
| [kana/vim-textobj-function] | Text objects for functions

[Shougo/dein.vim]: https://github.com/Shougo/dein.vim
[rafi/awesome-colorschemes]: https://github.com/rafi/awesome-vim-colorschemes
[itchyny/vim-gitbranch]: https://github.com/itchyny/vim-gitbranch
[itchyny/vim-parenmatch]: https://github.com/itchyny/vim-parenmatch
[thinca/vim-localrc]: https://github.com/thinca/vim-localrc
[romainl/vim-cool]: https://github.com/romainl/vim-cool
[sgur/vim-editorconfig]: https://github.com/sgur/vim-editorconfig
[christoomey/tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[tpope/vim-sleuth]: https://github.com/tpope/vim-sleuth
[roxma/nvim-yarp]: https://github.com/roxma/nvim-yarp
[roxma/vim-hug-neovim-rpc]: https://github.com/roxma/vim-hug-neovim-rpc

[hail2u/vim-css3-syntax]: https://github.com/hail2u/vim-css3-syntax
[othree/csscomplete.vim]: https://github.com/othree/csscomplete.vim
[cakebaker/scss-syntax.vim]: https://github.com/cakebaker/scss-syntax.vim
[groenewege/vim-less]: https://github.com/groenewege/vim-less
[iloginow/vim-stylus]: https://github.com/iloginow/vim-stylus
[mustache/vim-mustache-handlebars]: https://github.com/mustache/vim-mustache-handlebars
[digitaltoad/vim-pug]: https://github.com/digitaltoad/vim-pug
[othree/html5.vim]: https://github.com/othree/html5.vim
[plasticboy/vim-markdown]: https://github.com/plasticboy/vim-markdown
[rhysd/vim-gfm-syntax]: https://github.com/rhysd/vim-gfm-syntax
[pangloss/vim-javascript]: https://github.com/pangloss/vim-javascript
[HerringtonDarkholme/yats.vim]: https://github.com/HerringtonDarkholme/yats.vim
[MaxMEllon/vim-jsx-pretty]: https://github.com/MaxMEllon/vim-jsx-pretty
[leafOfTree/vim-svelte-plugin]: https://github.com/leafOfTree/vim-svelte-plugin
[heavenshell/vim-jsdoc]: https://github.com/heavenshell/vim-jsdoc
[jparise/vim-graphql]: https://github.com/jparise/vim-graphql
[moll/vim-node]: https://github.com/moll/vim-node
[kchmck/vim-coffee-script]: https://github.com/kchmck/vim-coffee-script
[elzr/vim-json]: https://github.com/elzr/vim-json
[posva/vim-vue]: https://github.com/posva/vim-vue
[fatih/vim-go]: https://github.com/fatih/vim-go
[vim-python/python-syntax]: https://github.com/vim-python/python-syntax
[Vimjas/vim-python-pep8-indent]: https://github.com/Vimjas/vim-python-pep8-indent
[vim-scripts/python_match.vim]: https://github.com/vim-scripts/python_match.vim
[raimon49/requirements.txt.vim]: https://github.com/raimon49/requirements.txt.vim
[StanAngeloff/php.vim]: https://github.com/StanAngeloff/php.vim
[tbastos/vim-lua]: https://github.com/tbastos/vim-lua
[vim-ruby/vim-ruby]: https://github.com/vim-ruby/vim-ruby
[keith/swift.vim]: https://github.com/keith/swift.vim
[rust-lang/rust.vim]: https://github.com/rust-lang/rust.vim
[vim-jp/syntax-vim-ex]: https://github.com/vim-jp/syntax-vim-ex
[chrisbra/csv.vim]: https://github.com/chrisbra/csv.vim
[tpope/vim-git]: https://github.com/tpope/vim-git
[ekalinin/Dockerfile.vim]: https://github.com/ekalinin/Dockerfile.vim
[tmux-plugins/vim-tmux]: https://github.com/tmux-plugins/vim-tmux
[MTDL9/vim-log-highlighting]: https://github.com/MTDL9/vim-log-highlighting
[cespare/vim-toml]: https://github.com/cespare/vim-toml
[mboughaba/i3config.vim]: https://github.com/mboughaba/i3config.vim
[dag/vim-fish]: https://github.com/dag/vim-fish
[jstrater/mpvim]: https://github.com/jstrater/mpvim
[robbles/logstash.vim]: https://github.com/robbles/logstash.vim
[lifepillar/pgsql.vim]: https://github.com/lifepillar/pgsql.vim
[chr4/nginx.vim]: https://github.com/chr4/nginx.vim
[towolf/vim-helm]: https://github.com/towolf/vim-helm
[pearofducks/ansible-vim]: https://github.com/pearofducks/ansible-vim
[hashivim/vim-terraform]: https://github.com/hashivim/vim-terraform

[Shougo/defx.nvim]: https://github.com/Shougo/defx.nvim
[kristijanhusak/defx-git]: https://github.com/kristijanhusak/defx-git
[kristijanhusak/defx-icons]: https://github.com/kristijanhusak/defx-icons
[tyru/caw.vim]: https://github.com/tyru/caw.vim
[Shougo/context_filetype.vim]: https://github.com/Shougo/context_filetype.vim
[liuchengxu/vim-which-key]: https://github.com/liuchengxu/vim-which-key
[mbbill/undotree]: https://github.com/mbbill/undotree
[reedes/vim-wordy]: https://github.com/reedes/vim-wordy
[jreybert/vimagit]: https://github.com/jreybert/vimagit
[tweekmonster/helpful.vim]: https://github.com/tweekmonster/helpful.vim
[lambdalisue/gina.vim]: https://github.com/lambdalisue/gina.vim
[kana/vim-altr]: https://github.com/kana/vim-altr
[Shougo/vinarise.vim]: https://github.com/Shougo/vinarise.vim
[guns/xterm-color-table.vim]: https://github.com/guns/xterm-color-table.vim
[cocopon/colorswatch.vim]: https://github.com/cocopon/colorswatch.vim
[dstein64/vim-startuptime]: https://github.com/dstein64/vim-startuptime
[brooth/far.vim]: https://github.com/brooth/far.vim
[jaawerth/nrun.vim]: https://github.com/jaawerth/nrun.vim
[Vigemus/iron.nvim]: https://github.com/Vigemus/iron.nvim
[kana/vim-niceblock]: https://github.com/kana/vim-niceblock
[t9md/vim-choosewin]: https://github.com/t9md/vim-choosewin
[lambdalisue/suda.vim]: https://github.com/lambdalisue/suda.vim
[mzlogin/vim-markdown-toc]: https://github.com/mzlogin/vim-markdown-toc
[liuchengxu/vista.vim]: https://github.com/liuchengxu/vista.vim
[junegunn/fzf]: https://github.com/junegunn/fzf
[junegunn/fzf.vim]: https://github.com/junegunn/fzf.vim
[Ron89/thesaurus_query.vim]: https://github.com/Ron89/thesaurus_query.vim

[haya14busa/vim-asterisk]: https://github.com/haya14busa/vim-asterisk
[rhysd/accelerated-jk]: https://github.com/rhysd/accelerated-jk
[haya14busa/vim-edgemotion]: https://github.com/haya14busa/vim-edgemotion
[t9md/vim-quickhl]: https://github.com/t9md/vim-quickhl
[hotwatermorning/auto-git-diff]: https://github.com/hotwatermorning/auto-git-diff
[rafi/vim-sidemenu]: https://github.com/rafi/vim-sidemenu
[machakann/vim-highlightedyank]: https://github.com/machakann/vim-highlightedyank
[wellle/context.vim]: https://github.com/wellle/context.vim
[itchyny/cursorword]: https://github.com/itchyny/vim-cursorword
[airblade/vim-gitgutter]: https://github.com/airblade/vim-gitgutter
[kshenoy/vim-signature]: https://github.com/kshenoy/vim-signature
[nathanaelkane/vim-indent-guides]: https://github.com/nathanaelkane/vim-indent-guides
[rhysd/committia.vim]: https://github.com/rhysd/committia.vim
[junegunn/goyo]: https://github.com/junegunn/goyo.vim
[junegunn/limelight]: https://github.com/junegunn/limelight.vim
[itchyny/calendar.vim]: https://github.com/itchyny/calendar.vim
[deris/vim-shot-f]: https://github.com/deris/vim-shot-f
[vimwiki/vimwiki]: https://github.com/vimwiki/vimwiki
[norcalli/nvim-colorizer.lua]: https://github.com/norcalli/nvim-colorizer.lua

[prabirshrestha/async.vim]: https://github.com/prabirshrestha/async.vim
[prabirshrestha/asyncomplete.vim]: https://github.com/prabirshrestha/asyncomplete.vim
[prabirshrestha/asyncomplete-lsp.vim]: https://github.com/prabirshrestha/asyncomplete-lsp.vim
[prabirshrestha/vim-lsp]: https://github.com/prabirshrestha/vim-lsp
[mattn/vim-lsp-settings]: https://github.com/mattn/vim-lsp-settings
[Shougo/neco-vim]: https://github.com/Shougo/neco-vim
[prabirshrestha/asyncomplete-necovim.vim]: https://github.com/prabirshrestha/asyncomplete-necovim.vim
[prabirshrestha/asyncomplete-buffer.vim]: https://github.com/prabirshrestha/asyncomplete-buffer.vim
[prabirshrestha/asyncomplete-tags.vim]: https://github.com/prabirshrestha/asyncomplete-tags.vim
[prabirshrestha/asyncomplete-file.vim]: https://github.com/prabirshrestha/asyncomplete-file.vim
[wellle/tmux-complete.vim]: https://github.com/wellle/tmux-complete.vim
[prabirshrestha/asyncomplete-ultisnips.vim]: https://github.com/prabirshrestha/asyncomplete-ultisnips.vim
[SirVer/ultisnips]: https://github.com/SirVer/ultisnips
[honza/vim-snippets]: https://github.com/honza/vim-snippets
[mattn/emmet-vim]: https://github.com/mattn/emmet-vim
[ncm2/float-preview.nvim]: https://github.com/ncm2/float-preview.nvim
[ludovicchabant/vim-gutentags]: https://github.com/ludovicchabant/vim-gutentags
[Raimondi/delimitMate]: https://github.com/Raimondi/delimitMate

[Shougo/denite.nvim]: https://github.com/Shougo/denite.nvim
[Shougo/neomru.vim]: https://github.com/Shougo/neomru.vim
[Shougo/neoyank.vim]: https://github.com/Shougo/neoyank.vim
[Shougo/junkfile.vim]: https://github.com/Shougo/junkfile.vim
[chemzqm/unite-location]: https://github.com/chemzqm/unite-location
[rafi/vim-denite-session]: https://github.com/rafi/vim-denite-session
[rafi/vim-denite-z]: https://github.com/rafi/vim-denite-z

[kana/vim-operator-user]: https://github.com/kana/vim-operator-user
[kana/vim-operator-replace]: https://github.com/kana/vim-operator-replace
[machakann/vim-sandwich]: https://github.com/machakann/vim-sandwich
[kana/vim-textobj-user]: https://github.com/kana/vim-textobj-user
[terryma/vim-expand-region]: https://github.com/terryma/vim-expand-region
[AndrewRadev/sideways.vim]: https://github.com/AndrewRadev/sideways.vim
[AndrewRadev/splitjoin.vim]: https://github.com/AndrewRadev/splitjoin.vim
[AndrewRadev/linediff.vim]: https://github.com/AndrewRadev/linediff.vim
[AndrewRadev/dsf.vim]: https://github.com/AndrewRadev/dsf.vim
[kana/vim-textobj-function]: https://github.com/kana/vim-textobj-function

</details>

## Custom Key-mappings

Note that,

* **Leader** key set as <kbd>Space</kbd>
* **Local-Leader** key set as <kbd>;</kbd> and used for navigation and search
  (Denite and Defx)
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
| <kbd>v</kbd> / <kbd>V</kbd> | 𝐕 | Expand/reduce selection | <small>[terryma/vim-expand-region]</small>
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
| <kbd>]g</kbd> or <kbd>]g</kbd> | 𝐍 | Next/previous Git hunk | <small>[airblade/vim-gitgutter]</small>
| <kbd>]d</kbd> or <kbd>]d</kbd> | 𝐍 | Next/previous LSP diagnostic | <small>[mattn/vim-lsp-settings]</small>
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
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | 𝐈 | Jump outside of pair | <small>[Raimondi/delimitMate]</small>
| <kbd>sj</kbd> / <kbd>sk</kbd> | 𝐍 | Join/split arguments | <small>[AndrewRadev/splitjoin.vim]</small>
| <kbd>dsf</kbd> / <kbd>csf</kbd> | 𝐍 | Delete/change surrounding function call | <small>[AndrewRadev/dsf.vim]</small>

### Search & Replace

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>*</kbd> / <kbd>#</kbd> | 𝐍 𝐕 | Search selection forward/backward | <small>[haya14busa/vim-asterisk]</small>
| <kbd>g*</kbd> / <kbd>g#</kbd> | 𝐍 𝐕 | Search whole-word forward/backward | <small>[haya14busa/vim-asterisk]</small>
| <kbd>Backspace</kbd> | 𝐍 | Match bracket | `%`
| <kbd>gp</kbd> | 𝐍 | Select last paste |
| <kbd>sg</kbd> | 𝐕 | Replace within selected area | `:s/⌴/gc`
| <kbd>Ctrl</kbd>+<kbd>r</kbd> | 𝐕 | Replace selection with step-by-step confirmation | `:%s/\V/⌴/gc`

### Clipboard

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>p</kbd> | 𝐕 𝐒 | Paste without yank | <small>[kana/vim-operator-replace]</small>
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
| <kbd>gK</kbd> | 𝐍 | Open Zeal or Dash on some file-types | <small>[plugin/devhelp.vim]</small>
| <kbd>g</kbd><kbd>Ctrl</kbd>+<kbd>o</kbd> | 𝐍 | Navigate to previous file on jumplist | <small>[plugin/jumpfile.vim]</small>
| <kbd>g</kbd><kbd>Ctrl</kbd>+<kbd>i</kbd> | 𝐍 | Navigate to next file on jumplist | <small>[plugin/jumpfile.vim]</small>
| <kbd>Space</kbd>+<kbd>l</kbd> | 𝐍 | Open side-menu helper | <small>[rafi/vim-sidemenu]</small>
| <kbd>Space</kbd>+<kbd>b</kbd> | 𝐍 | Open structure window | <small>[liuchengxu/vista.vim]</small>
| <kbd>Space</kbd>+<kbd>a</kbd> | 𝐍 | Show nearby tag in structure window | <small>[liuchengxu/vista.vim]</small>
| <kbd>Space</kbd>+<kbd>se</kbd> | 𝐍 | Save current workspace session | <small>[plugin/sessions.vim]</small>
| <kbd>Space</kbd>+<kbd>sl</kbd> | 𝐍 | Load workspace session | <small>[plugin/sessions.vim]</small>
| <kbd>Space</kbd>+<kbd>n</kbd>/<kbd>N</kbd> | 𝐍 | Open alternative file | <small>[kana/vim-altr]</small>
| <kbd>Space</kbd>+<kbd>tc</kbd> | 𝐍 | Enable scroll-context window | <small>[wellle/context.vim]</small>
| <kbd>Space</kbd>+<kbd>tp</kbd> | 𝐍 | Peek scroll-context window | <small>[wellle/context.vim]</small>
| <kbd>Space</kbd>+<kbd>S</kbd> | 𝐍 𝐕 | Source selection | `y:execute @@`
| <kbd>Space</kbd>+<kbd>?</kbd> | 𝐍 | Open the macOS dictionary on current word | `:!open dict://`
| <kbd>Space</kbd>+<kbd>P</kbd> | 𝐍 | Use Marked 2 for real-time Markdown preview | <small>[Marked 2]</small>
| <kbd>Space</kbd>+<kbd>ml</kbd> | 𝐍 | Append modeline to end of buffer | <small>[config/mappings.vim]</small>
| <kbd>Space</kbd>+<kbd>mda</kbd> | 𝐕 | Sequentially mark region for diff | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mdf</kbd> | 𝐕 | Mark region for diff and compare if more than one | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mds</kbd> | 𝐍 | Shows the comparison for all marked regions | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mdr</kbd> | 𝐍 | Removes the signs denoting the diff regions | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mg</kbd> | 𝐍 | Open Magit | <small>[jreybert/vimagit]</small>
| <kbd>Space</kbd>+<kbd>mt</kbd> | 𝐍 𝐕 | Toggle highlighted word | <small>[t9md/vim-quickhl]</small>
| <kbd>Space</kbd>+<kbd>-</kbd> | 𝐍 | Switch editing window with selected | <small>[t9md/vim-choosewin]</small>
| <kbd>Space</kbd>+<kbd>G</kbd> | 𝐍 | Toggle distraction-free writing | <small>[junegunn/goyo]</small>
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
| <kbd>sx</kbd> | 𝐍 | Delete buffer, leave blank window | `:enew │ bdelete`
| <kbd>ssv</kbd> | 𝐍 | Split with previous buffer | `:split │ wincmd p │ e#`
| <kbd>ssg</kbd> | 𝐍 | Vertical split with previous buffer | `:vsplit │ wincmd p │ e#`
| <kbd>sh</kbd> | 𝐍 | Toggle colorscheme background=dark/light | `:set background` …
| <kbd>s-</kbd> | 𝐍 | Lower solarized8 colorscheme contrast | `:colorscheme ` …
| <kbd>s=</kbd> | 𝐍 | Raise solarized8 colorscheme contrast | `:colorscheme ` …

### Git Version Control

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>gs</kbd> | 𝐍 | Preview hunk | <small>[airblade/vim-gitgutter]</small>
| <kbd>gS</kbd> | 𝐍 𝐕 𝐒 | Stage hunk | <small>[airblade/vim-gitgutter]</small>
| <kbd>Space</kbd>+<kbd>gr</kbd> | 𝐍 | Revert hunk | <small>[airblade/vim-gitgutter]</small>
| <kbd>Space</kbd>+<kbd>ga</kbd> | 𝐍 | Git add current file | <small>[lambdalisue/gina.vim]</small>
| <kbd>Space</kbd>+<kbd>gd</kbd> | 𝐍 | Git diff | <small>[lambdalisue/gina.vim]</small>
| <kbd>Space</kbd>+<kbd>gc</kbd> | 𝐍 | Git branches | <small>[lambdalisue/gina.vim]</small>
| <kbd>Space</kbd>+<kbd>gc</kbd> | 𝐍 | Git commit | <small>[lambdalisue/gina.vim]</small>
| <kbd>Space</kbd>+<kbd>gb</kbd> | 𝐍 | Git blame | <small>[lambdalisue/gina.vim]</small>
| <kbd>Space</kbd>+<kbd>gs</kbd> | 𝐍 | Git status -s | <small>[lambdalisue/gina.vim]</small>
| <kbd>Space</kbd>+<kbd>gl</kbd> | 𝐍 | Git log --all | <small>[lambdalisue/gina.vim]</small>
| <kbd>Space</kbd>+<kbd>gF</kbd> | 𝐍 | Git fetch | <small>[lambdalisue/gina.vim]</small>
| <kbd>Space</kbd>+<kbd>gp</kbd> | 𝐍 | Git push | <small>[lambdalisue/gina.vim]</small>
| <kbd>Space</kbd>+<kbd>go</kbd> | 𝐍 𝐕 | Open SCM detailed URL in browser | <small>[lambdalisue/gina.vim]</small>

### Plugin: Denite

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>;r</kbd> | 𝐍 | Resumes last Denite window
| <kbd>;f</kbd> | 𝐍 | File search
| <kbd>;g</kbd> | 𝐍 | Grep search
| <kbd>;b</kbd> | 𝐍 | Buffers
| <kbd>;i</kbd> | 𝐍 | Old files and MRU
| <kbd>;d</kbd> | 𝐍 | Directories and MRU
| <kbd>;v</kbd> | 𝐍 𝐕 | Yank history
| <kbd>;l</kbd> | 𝐍 | Location list
| <kbd>;q</kbd> | 𝐍 | Quick fix
| <kbd>;n</kbd> | 𝐍 | Dein plugin list
| <kbd>;j</kbd> | 𝐍 | Jump points and change stack
| <kbd>;u</kbd> | 𝐍 | Junk files
| <kbd>;o</kbd> | 𝐍 | Outline tags
| <kbd>;s</kbd> | 𝐍 | Sessions
| <kbd>;t</kbd> | 𝐍 | Tag list
| <kbd>;p</kbd> | 𝐍 | Jumps
| <kbd>;h</kbd> | 𝐍 | Help
| <kbd>;m</kbd> | 𝐍 | Memo list
| <kbd>;z</kbd> | 𝐍 | Z (jump around)
| <kbd>;;</kbd> | 𝐍 | Command history
| <kbd>;/</kbd> | 𝐍 | Buffer lines
| <kbd>;*</kbd> | 𝐍 | Search word under cursor with lines
| <kbd>Space</kbd>+<kbd>gt</kbd> | 𝐍 | Find tags matching word under cursor
| <kbd>Space</kbd>+<kbd>gf</kbd> | 𝐍 | Find files matching word under cursor
| <kbd>Space</kbd>+<kbd>gg</kbd> | 𝐍 𝐕 | Grep word under cursor
| **Within _Denite_ window** ||
| <kbd>jj</kbd> or <kbd>Escape</kbd> | 𝐈 | Leave Insert mode
| <kbd>i</kbd> or <kbd>/</kbd> | 𝐍 | Enter Insert mode (filter input)
| <kbd>q</kbd> or <kbd>Escape</kbd> | 𝐍 | Exit denite window
| <kbd>Tab</kbd> or <kbd>Shift</kbd>+<kbd>Tab</kbd> | 𝐈 | Next/previous candidate
| <kbd>Space</kbd> | 𝐍 | Select candidate entry
| <kbd>dd</kbd> | 𝐍 | Delete entry
| <kbd>p</kbd> | 𝐍 | Preview entry
| <kbd>st</kbd> | 𝐍 | Open in a new tab
| <kbd>sg</kbd> | 𝐍 | Open in a vertical split
| <kbd>sv</kbd> | 𝐍 | Open in a split
| <kbd>'</kbd> | 𝐍 | Quick-move
| <kbd>r</kbd> | 𝐍 | Redraw
| <kbd>yy</kbd> | 𝐍 | Yank
| <kbd>Tab</kbd> | 𝐍 | List and choose action

### Plugin: Defx

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>;e</kbd> | 𝐍 | Open file-explorer (toggle)
| <kbd>;a</kbd> | 𝐍 | Focus current file in file-explorer
| **Within _Defx_ window** ||
| <kbd>j</kbd> or <kbd>k</kbd> | 𝐍 | Move up and down the tree
| <kbd>l</kbd> or <kbd>Return</kbd> | 𝐍 | Toggle collapse/expand directory or open file
| <kbd>h</kbd> | 𝐍 | Collapse directory tree
| <kbd>t</kbd> | 𝐍 | Expand directory tree recursively
| <kbd>.</kbd> | 𝐍 | Toggle hidden files
| <kbd>Space</kbd> | 𝐍 | Select entry
| <kbd>*</kbd> | 𝐍 | Invert selection (select all)
| <kbd>&</kbd> or <kbd>\</kbd> | 𝐍 | Change into current working directory
| <kbd>~</kbd> | 𝐍 | Change to user home directory
| <kbd>u</kbd> or <kbd>Backspace</kbd> | 𝐍 | Change into parent directory
| <kbd>u</kbd> <kbd>2</kbd>/<kbd>3</kbd>/<kbd>4</kbd> | 𝐍 | Change into parent directory count
| <kbd>st</kbd> | 𝐍 | Open file in new tab
| <kbd>sv</kbd> | 𝐍 | Open file in a horizontal split
| <kbd>sg</kbd> | 𝐍 | Open file in a vertical split
| <kbd>N</kbd> | 𝐍 | Create new directories and/or files
| <kbd>K</kbd> | 𝐍 | Create new directory
| <kbd>c</kbd> / <kbd>m</kbd> / <kbd>p</kbd> | 𝐍 | Copy, move, and paste
| <kbd>r</kbd> | 𝐍 | Rename file or directory
| <kbd>dd</kbd> | 𝐍 | Trash selected files and directories
| <kbd>y</kbd> | 𝐍 | Yank path to clipboard
| <kbd>w</kbd> | 𝐍 | Toggle window size
| <kbd>]g</kbd> | 𝐍 | Next dirty git item
| <kbd>[g</kbd> | 𝐍 | Previous dirty git item
| <kbd>x</kbd> or <kbd>gx</kbd> | 𝐍 | Execute associated system application
| <kbd>gd</kbd> | 𝐍 | Open git diff on selected file
| <kbd>gl</kbd> | 𝐍 | Open terminal file explorer with tmux
| <kbd>gr</kbd> | 𝐍 | Grep in current position
| <kbd>gf</kbd> | 𝐍 | Find files in current position

### Plugin: Asyncomplete and Emmet

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

## Credits & Contribution

Big thanks to the dark knight [Shougo](https://github.com/Shougo).

[config/mappings.vim]: ./config/mappings.vim
[plugin/whitespace.vim]: ./plugin/whitespace.vim
[plugin/sessions.vim]: ./plugin/sessions.vim
[plugin/devhelp.vim]: ./plugin/devhelp.vim
[plugin/jumpfile.vim]: ./plugin/jumpfile.vim
[plugin/actionmenu.vim]: ./plugin/actionmenu.vim
[Marked 2]: https://marked2app.com
[Neovim]: https://github.com/neovim/neovim
[Vim8]: https://github.com/vim/vim
[lazy-loaded]: ./config/plugins.yaml#L47
