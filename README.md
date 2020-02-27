# Rafael Bodill's Neo/vim Config

Lean mean Neo/vim machine, 30-45ms startup time.

Best with [Neovim] or [Vim8] and <small style="background-color: #eee">python3</small> enabled.

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
  * [General](#general)
  * [File Operations](#file-operations)
  * [Editor UI](#editor-ui)
  * [Window Management](#window-management)
  * [Plugin: Denite](#plugin-denite)
  * [Plugin: Defx](#plugin-defx)
  * [Plugin: Asyncomplete and Emmet](#plugin-asyncomplete-and-emmet)
  * [Plugin: Caw (comments)](#plugin-caw-comments)
  * [Plugin: Edge Motion](#plugin-edge-motion)
  * [Plugin: Signature](#plugin-signature)
  * [Plugin: Easygit](#plugin-easygit)
  * [Plugin: GitGutter](#plugin-gitgutter)
  * [Plugin: Linediff](#plugin-linediff)
  * [Misc Plugins](#misc-plugins)
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
brew install shellcheck vint jsonlint yamllint tflint ansible-lint
brew install tidy-html5 proselint write-good
```

* Node.js based linters:

```sh
yarn global add eslint jshint jsxhint stylelint sass-lint
yarn global add markdownlint-cli raml-cop
```

* Python based linters:

```sh
pip3 install --user pycodestyle pyflakes flake8
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
- { repo: dense-analysis/ale, if: 0 }
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
| [IN3D/vim-raml] | Syntax and language settings for RAML
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
| [brooth/far.vim] | Fast find and replace plugin
| [jreybert/vimagit] | Ease your git work-flow within Vim
| [tweekmonster/helpful.vim] | Display vim version numbers in docs
| [lambdalisue/gina.vim] | Asynchronously control git repositories
| [kana/vim-altr] | Switch to the alternate file without interaction
| [Shougo/vinarise.vim] | Hex editor
| [guns/xterm-color-table.vim] | Display 256 xterm colors with their RGB equivalents
| [cocopon/colorswatch.vim] | Generate a beautiful color swatch for the current buffer
| [dstein64/vim-startuptime] | Visually profile Vim's startup time
| [jaawerth/nrun.vim] | "which" and "exec" functions targeted at local node project bin
| [Vigemus/iron.nvim] | Interactive REPL over Neovim
| [kana/vim-niceblock] | Make blockwise Visual mode more useful
| [t9md/vim-choosewin] | Choose window to use, like tmux's 'display-pane'
| [lambdalisue/suda.vim] | An alternative sudo.vim for Vim and Neovim
| [mzlogin/vim-markdown-toc] | Generate table of contents for Markdown files
| [chemzqm/vim-easygit] | Git wrapper focus on simplity and usability
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
| [norcalli/nvim-colorizer.lua] | The fastest Neovim colorizer
| [airblade/vim-gitgutter] | Show git changes at Vim gutter and un/stages hunks
| [kshenoy/vim-signature] | Display and toggle marks
| [nathanaelkane/vim-indent-guides] | Visually display indent levels in code
| [rhysd/committia.vim] | Pleasant editing on Git commit messages
| [junegunn/goyo] | Distraction-free writing
| [junegunn/limelight] | Hyperfocus-writing
| [itchyny/calendar.vim] | Calendar application
| [vimwiki/vimwiki] | Personal Wiki for Vim

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
| [prabirshrestha/asyncomplete-tags.vim] | Provides tag autocomplete via vim tagfiles
| [prabirshrestha/asyncomplete-file.vim] | Provides file autocomplete
| [wellle/tmux-complete.vim] | Completion of words in adjacent tmux panes
| [prabirshrestha/asyncomplete-ultisnips.vim] | Provides UltiSnips autocomplete
| [SirVer/ultisnips] | Ultimate snippet solution
| [honza/vim-snippets] | Community-maintained snippets for programming languages
| [dense-analysis/ale] | Check syntax asynchronously and fix files with LSP support
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
| [chemzqm/denite-git] | gitlog, gitstatus and gitchanged sources
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
| [osyo-manga/vim-textobj-multiblock] | Handle bracket objects
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
[IN3D/vim-raml]: https://github.com/IN3D/vim-raml
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
[brooth/far.vim]: https://github.com/brooth/far.vim
[jreybert/vimagit]: https://github.com/jreybert/vimagit
[tweekmonster/helpful.vim]: https://github.com/tweekmonster/helpful.vim
[lambdalisue/gina.vim]: https://github.com/lambdalisue/gina.vim
[kana/vim-altr]: https://github.com/kana/vim-altr
[Shougo/vinarise.vim]: https://github.com/Shougo/vinarise.vim
[guns/xterm-color-table.vim]: https://github.com/guns/xterm-color-table.vim
[cocopon/colorswatch.vim]: https://github.com/cocopon/colorswatch.vim
[dstein64/vim-startuptime]: https://github.com/dstein64/vim-startuptime
[jaawerth/nrun.vim]: https://github.com/jaawerth/nrun.vim
[Vigemus/iron.nvim]: https://github.com/Vigemus/iron.nvim
[kana/vim-niceblock]: https://github.com/kana/vim-niceblock
[t9md/vim-choosewin]: https://github.com/t9md/vim-choosewin
[lambdalisue/suda.vim]: https://github.com/lambdalisue/suda.vim
[mzlogin/vim-markdown-toc]: https://github.com/mzlogin/vim-markdown-toc
[chemzqm/vim-easygit]: https://github.com/chemzqm/vim-easygit
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
[norcalli/nvim-colorizer.lua]: https://github.com/norcalli/nvim-colorizer.lua
[airblade/vim-gitgutter]: https://github.com/airblade/vim-gitgutter
[kshenoy/vim-signature]: https://github.com/kshenoy/vim-signature
[nathanaelkane/vim-indent-guides]: https://github.com/nathanaelkane/vim-indent-guides
[rhysd/committia.vim]: https://github.com/rhysd/committia.vim
[junegunn/goyo]: https://github.com/junegunn/goyo.vim
[junegunn/limelight]: https://github.com/junegunn/limelight.vim
[itchyny/calendar.vim]: https://github.com/itchyny/calendar.vim
[vimwiki/vimwiki]: https://github.com/vimwiki/vimwiki

[prabirshrestha/async.vim]: https://github.com/prabirshrestha/async.vim
[prabirshrestha/asyncomplete.vim]: https://github.com/prabirshrestha/asyncomplete.vim
[prabirshrestha/asyncomplete-lsp.vim]: https://github.com/prabirshrestha/asyncomplete-lsp.vim
[prabirshrestha/vim-lsp]: https://github.com/prabirshrestha/vim-lsp
[mattn/vim-lsp-settings]: https://github.com/mattn/vim-lsp-settings
[Shougo/neco-vim]: https://github.com/Shougo/neco-vim
[prabirshrestha/asyncomplete-necovim.vim]: https://github.com/prabirshrestha/asyncomplete-necovim.vim
[prabirshrestha/asyncomplete-tags.vim]: https://github.com/prabirshrestha/asyncomplete-tags.vim
[prabirshrestha/asyncomplete-file.vim]: https://github.com/prabirshrestha/asyncomplete-file.vim
[wellle/tmux-complete.vim]: https://github.com/wellle/tmux-complete.vim
[prabirshrestha/asyncomplete-ultisnips.vim]: https://github.com/prabirshrestha/asyncomplete-ultisnips.vim
[SirVer/ultisnips]: https://github.com/SirVer/ultisnips
[honza/vim-snippets]: https://github.com/honza/vim-snippets
[dense-analysis/ale]: https://github.com/dense-analysis/ale
[mattn/emmet-vim]: https://github.com/mattn/emmet-vim
[ncm2/float-preview.nvim]: https://github.com/ncm2/float-preview.nvim
[ludovicchabant/vim-gutentags]: https://github.com/ludovicchabant/vim-gutentags
[Raimondi/delimitMate]: https://github.com/Raimondi/delimitMate

[Shougo/denite.nvim]: https://github.com/Shougo/denite.nvim
[Shougo/neomru.vim]: https://github.com/Shougo/neomru.vim
[Shougo/neoyank.vim]: https://github.com/Shougo/neoyank.vim
[Shougo/junkfile.vim]: https://github.com/Shougo/junkfile.vim
[chemzqm/unite-location]: https://github.com/chemzqm/unite-location
[chemzqm/denite-git]: https://github.com/chemzqm/denite-git
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
[osyo-manga/vim-textobj-multiblock]: https://github.com/osyo-manga/vim-textobj-multiblock
[kana/vim-textobj-function]: https://github.com/kana/vim-textobj-function

</details>

## Custom Key-mappings

Note that,

* Leader key set as <kbd>Space</kbd>
* Local-leader set as <kbd>;</kbd> and used for navigation and search
  (Denite and Defx)

<details open>
  <summary>
    <strong>Key-mappings</strong>
    <small><i>(🔎 Click to expand/collapse)</i></small>
  </summary>

### General

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Space</kbd> | _All_ | **Leader** key
| <kbd>;</kbd> | _All_ | **Local Leader** key
| <kbd>←</kbd> <kbd>↑</kbd> <kbd>→</kbd> <kbd>↓</kbd> | Normal | Resize splits (* Enable `g:elite_mode` in `.vault.vim`)
| <kbd>;</kbd>+<kbd>c</kbd> | Normal | Open context-menu
| <kbd>Space</kbd>+<kbd>l</kbd> | Normal | Open side-menu helper
| <kbd>Backspace</kbd> | Normal | Match bracket (`%`)
| <kbd>gK</kbd> | Normal | Open Zeal or Dash on some file-types
| <kbd>Y</kbd> | Normal | Yank to the end of line (`y$`)
| <kbd>Return</kbd> | Normal | Toggle fold (`za`)
| <kbd>Shift</kbd>+<kbd>Return</kbd> | Normal | Focus the current fold by closing all others (`zMzvzt`)
| <kbd>Shift</kbd>+<kbd>Return</kbd> | Insert | Start new line from any cursor position (`<C-o>o`)
| <kbd>j</kbd> / <kbd>k</kbd> | Normal/Visual | Cursor moves through display-lines (`g/jk`)
| <kbd>Ctrl</kbd>+<kbd>f</kbd> | Normal | Smart page forward (`C-f/C-d`)
| <kbd>Ctrl</kbd>+<kbd>b</kbd> | Normal | Smart page backwards (`C-b/C-u`)
| <kbd>Ctrl</kbd>+<kbd>e</kbd> | Normal | Smart scroll down (`3C-e/j`)
| <kbd>Ctrl</kbd>+<kbd>y</kbd> | Normal | Smart scroll up (`3C-y/k`)
| <kbd>Ctrl</kbd>+<kbd>q</kbd> | Normal | Remap to <kbd>Ctrl</kbd>+<kbd>w</kbd>
| <kbd>Ctrl</kbd>+<kbd>x</kbd> | Normal | Rotate window placement
| <kbd>!</kbd> | Normal | Shortcut for `:!`
| <kbd><<</kbd> | Visual | Indent to left and re-select
| <kbd>>></kbd> | Visual | Indent to right and re-select
| <kbd>Tab</kbd> | Visual | Indent to right and re-select
| <kbd>Shift</kbd>+<kbd>Tab</kbd> | Visual | Indent to left and re-select
| <kbd>gh</kbd> | Normal | Show highlight groups for word
| <kbd>gp</kbd> | Normal | Select last paste
| <kbd>Q</kbd> | Normal | Start/stop macro recording
| <kbd>gQ</kbd> | Normal | Play macro 'q'
| <kbd>Space</kbd>+<kbd>j</kbd> or <kbd>k</kbd> | Normal/Visual | Move lines down/up
| <kbd>Space</kbd>+<kbd>cp</kbd> | Normal | Duplicate paragraph
| <kbd>Space</kbd>+<kbd>cn</kbd> / <kbd>cN</kbd> | Normal/Visual | Change current word in a repeatable manner
| <kbd>s</kbd><kbd>g</kbd> | Visual | Replace within selected area
| <kbd>Ctrl</kbd>+<kbd>a</kbd> | Command | Navigation in command line
| <kbd>Ctrl</kbd>+<kbd>b</kbd> | Command | Move cursor backward in command line
| <kbd>Ctrl</kbd>+<kbd>f</kbd> | Command | Move cursor forward in command line
| <kbd>Ctrl</kbd>+<kbd>r</kbd> | Visual | Replace selection with step-by-step confirmation
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>q</kbd> | Normal | Exit Vim, confirm unsaved changes
| <kbd>Space</kbd>+<kbd>cw</kbd> | Normal | Remove all spaces at EOL
| <kbd>Space</kbd>+<kbd>Space</kbd> | Normal | Enter visual line-mode
| <kbd>Space</kbd>+<kbd>sl</kbd> | Normal | Load workspace session
| <kbd>Space</kbd>+<kbd>se</kbd> | Normal | Save current workspace session
| <kbd>Space</kbd>+<kbd>d</kbd> | Normal/Visual | Duplicate line or selection
| <kbd>Space</kbd>+<kbd>S</kbd> | Normal/Visual | Source selection
| <kbd>Space</kbd>+<kbd>ml</kbd> | Normal | Append modeline

### File Operations

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Space</kbd>+<kbd>cd</kbd> | Normal | Switch to the directory of opened buffer (`:lcd %:p:h`)
| <kbd>Space</kbd>+<kbd>w</kbd> | Normal/Visual | Write (`:w`)
| <kbd>Space</kbd>+<kbd>y</kbd> | Normal | Copy relative file-path to clipboard
| <kbd>Space</kbd>+<kbd>Y</kbd> | Normal | Copy absolute file-path to clipboard
| <kbd>Ctrl</kbd>+<kbd>s</kbd> | _All_ | Write (`:w`)

### Editor UI

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Space</kbd>+<kbd>ti</kbd> | Normal | Toggle indentation lines
| <kbd>Space</kbd>+<kbd>ts</kbd> | Normal | Toggle spell-checker (`:setlocal spell!`)
| <kbd>Space</kbd>+<kbd>tn</kbd> | Normal | Toggle line numbers (`:setlocal nonumber!`)
| <kbd>Space</kbd>+<kbd>tl</kbd> | Normal | Toggle hidden characters (`:setlocal nolist!`)
| <kbd>Space</kbd>+<kbd>th</kbd> | Normal | Toggle highlighted search (`:set hlsearch!`)
| <kbd>Space</kbd>+<kbd>tw</kbd> | Normal | Toggle wrap (`:setlocal wrap! breakindent!`)
| <kbd>g1</kbd> | Normal | Go to first tab (`:tabfirst`)
| <kbd>g9</kbd> | Normal | Go to last tab (`:tablast`)
| <kbd>g5</kbd> | Normal | Go to previous tab (`:tabprevious`)
| <kbd>Ctrl</kbd>+<kbd>j</kbd> | Normal | Move to split below
| <kbd>Ctrl</kbd>+<kbd>k</kbd> | Normal | Move to upper split
| <kbd>Ctrl</kbd>+<kbd>h</kbd> | Normal | Move to left split
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | Normal | Move to right split
| <kbd>*</kbd> | Visual | Search selection forwards
| <kbd>#</kbd> | Visual | Search selection backwards
| <kbd>]</kbd>+<kbd>c</kbd> or <kbd>q</kbd> | Normal | Next on location/quickfix list
| <kbd>]</kbd>+<kbd>c</kbd> or <kbd>q</kbd> | Normal | Previous on location/quickfix list
| <kbd>s</kbd>+<kbd>h</kbd> | Normal | Toggle colorscheme background dark/light
| <kbd>s</kbd>+<kbd>-</kbd> | Normal | Lower colorscheme contrast (Support solarized8)
| <kbd>s</kbd>+<kbd>=</kbd> | Normal | Raise colorscheme contrast (Support solarized8)

### Window Management

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>q</kbd> | Normal | Quit window (and Vim, if last window)
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | Normal | Next tab
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Tab</kbd> | Normal | Previous tab
| <kbd>s</kbd>+<kbd>v</kbd> | Normal | Horizontal split (`:split`)
| <kbd>s</kbd>+<kbd>g</kbd> | Normal | Vertical split (`:vsplit`)
| <kbd>s</kbd>+<kbd>t</kbd> | Normal | Open new tab (`:tabnew`)
| <kbd>s</kbd>+<kbd>o</kbd> | Normal | Close other windows (`:only`)
| <kbd>s</kbd>+<kbd>b</kbd> | Normal | Previous buffer (`:b#`)
| <kbd>s</kbd>+<kbd>c</kbd> | Normal | Closes current buffer (`:close`)
| <kbd>s</kbd>+<kbd>x</kbd> | Normal | Remove buffer, leave blank window
| <kbd>Space</kbd>+<kbd>sv</kbd> | Normal | Split with previous buffer
| <kbd>Space</kbd>+<kbd>sg</kbd> | Normal | Vertical split with previous buffer

### Plugin: Denite

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>;</kbd>+<kbd>r</kbd> | Normal | Resumes last Denite window
| <kbd>;</kbd>+<kbd>f</kbd> | Normal | File search
| <kbd>;</kbd>+<kbd>b</kbd> | Normal | Buffers and MRU
| <kbd>;</kbd>+<kbd>d</kbd> | Normal | Directories
| <kbd>;</kbd>+<kbd>v</kbd> | Normal/Visual | Yank history
| <kbd>;</kbd>+<kbd>l</kbd> | Normal | Location list
| <kbd>;</kbd>+<kbd>q</kbd> | Normal | Quick fix
| <kbd>;</kbd>+<kbd>n</kbd> | Normal | Dein plugin list
| <kbd>;</kbd>+<kbd>g</kbd> | Normal | Grep search
| <kbd>;</kbd>+<kbd>j</kbd> | Normal | Jump points
| <kbd>;</kbd>+<kbd>u</kbd> | Normal | Junk files
| <kbd>;</kbd>+<kbd>o</kbd> | Normal | Outline tags
| <kbd>;</kbd>+<kbd>s</kbd> | Normal | Sessions
| <kbd>;</kbd>+<kbd>t</kbd> | Normal | Tag list
| <kbd>;</kbd>+<kbd>p</kbd> | Normal | Jump to previous position
| <kbd>;</kbd>+<kbd>h</kbd> | Normal | Help
| <kbd>;</kbd>+<kbd>m</kbd> | Normal | Memo list
| <kbd>;</kbd>+<kbd>z</kbd> | Normal | Z (jump around)
| <kbd>;</kbd>+<kbd>/</kbd> | Normal | Buffer lines
| <kbd>;</kbd>+<kbd>*</kbd> | Normal | Match word under cursor with lines
| <kbd>;</kbd>+<kbd>;</kbd> | Normal | Command history
| <kbd>Space</kbd>+<kbd>gl</kbd> | Normal | Git log (all)
| <kbd>Space</kbd>+<kbd>gs</kbd> | Normal | Git status
| <kbd>Space</kbd>+<kbd>gc</kbd> | Normal | Git branches
| <kbd>Space</kbd>+<kbd>gt</kbd> | Normal | Find tags matching word under cursor
| <kbd>Space</kbd>+<kbd>gf</kbd> | Normal | Find file matching word under cursor
| <kbd>Space</kbd>+<kbd>gg</kbd> | Normal/Visual | Grep word under cursor
| **Within _Denite_ window** ||
| <kbd>jj</kbd> or <kbd>kk</kbd> | Insert | Leave Insert mode
| <kbd>q</kbd> or <kbd>Escape</kbd> | Normal | Exit denite window
| <kbd>Space</kbd> | Normal | Select entry
| <kbd>Tab</kbd> | Normal | List and choose action
| <kbd>i</kbd> | Normal | Open filter input
| <kbd>dd</kbd> | Normal | Delete entry
| <kbd>p</kbd> | Normal | Preview entry
| <kbd>st</kbd> | Normal | Open in a new tab
| <kbd>sg</kbd> | Normal | Open in a vertical split
| <kbd>sv</kbd> | Normal | Open in a split
| <kbd>r</kbd> | Normal | Redraw
| <kbd>yy</kbd> | Normal | Yank
| <kbd>'</kbd> | Normal | Quick move

### Plugin: Defx

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>;</kbd>+<kbd>e</kbd> | Normal | Open file explorer (toggle)
| <kbd>;</kbd>+<kbd>a</kbd> | Normal | Open file explorer and select current file
| **Within _Defx_ window** ||
| <kbd>h</kbd> | Normal | Collapse directory tree
| <kbd>j</kbd> or <kbd>k</kbd> | Normal | Move up and down the tree
| <kbd>Return</kbd> or <kbd>l</kbd> | Normal | Toggle collapse/expand directory or open file
| <kbd>Space</kbd> | Normal | Select current file or directory
| <kbd>*</kbd> | Normal | Invert selection (select all)
| <kbd>Backspace</kbd> | Normal | Move into the parent directory
| <kbd>&</kbd> or <kbd>\</kbd> | Normal | Move to project root
| <kbd>~</kbd> | Normal | Move to user home directory
| <kbd>st</kbd> | Normal | Open file in new tab
| <kbd>sv</kbd> | Normal | Open file in a horizontal split
| <kbd>sg</kbd> | Normal | Open file in a vertical split
| <kbd>N</kbd> | Normal | Create new directories and/or files
| <kbd>K</kbd> | Normal | Create new directory
| <kbd>c</kbd> / <kbd>m</kbd> / <kbd>p</kbd> | Normal | Copy, move, and paste
| <kbd>r</kbd> | Normal | Rename file or directory
| <kbd>dd</kbd> | Normal | Delete selected files and directories
| <kbd>y</kbd> | Normal | Yank selected item to clipboard
| <kbd>w</kbd> | Normal | Toggle window size
| <kbd>]</kbd>+<kbd>g</kbd> | Normal | Next dirty git item
| <kbd>[</kbd>+<kbd>g</kbd> | Normal | Previous dirty git item
| <kbd>x</kbd> / <kbd>gx</kbd> | Normal | Execute associated system application
| <kbd>gd</kbd> | Normal | Open git diff on selected file
| <kbd>gl</kbd> | Normal | Open terminal file explorer
| <kbd>gr</kbd> | Normal | Grep in selected directory
| <kbd>gf</kbd> | Normal | Find files in selected directory

### Plugin: Asyncomplete and Emmet

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Tab</kbd> / <kbd>Shift-Tab</kbd> | Insert | Navigate completion-menu
| <kbd>Enter</kbd> | Insert | Select completion or expand snippet
| <kbd>Ctrl</kbd>+<kbd>j</kbd> <kbd>k</kbd> <kbd>d</kbd> <kbd>u</kbd> | Insert | Movement in completion pop-up
| <kbd>Ctrl</kbd>+<kbd>Return</kbd> | Insert | Expand Emmet sequence
| <kbd>Ctrl</kbd>+<kbd>Space</kbd> | Insert | Refresh and show candidates
| <kbd>Ctrl</kbd>+<kbd>y</kbd> | Insert | Close pop-up
| <kbd>Ctrl</kbd>+<kbd>e</kbd> | Insert | Cancel selection and close pop-up
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | Insert | Expand snippet at cursor
| <kbd>Ctrl</kbd>+<kbd>f</kbd> | Insert/select | Jump to next snippet placeholder
| <kbd>Ctrl</kbd>+<kbd>b</kbd> | Insert/select | Jump to previous snippet placeholder

### Plugin: Caw (comments)

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>gc</kbd> | Normal/visual | Prefix
| <kbd>gcc</kbd> | Normal/visual | Toggle comments
| <kbd>Space</kbd>+<kbd>v</kbd> | Normal/visual | Toggle single-line comments
| <kbd>Space</kbd>+<kbd>V</kbd> | Normal/visual | Toggle comment block

### Plugin: Edge Motion

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>g</kbd>+<kbd>j</kbd> | Normal/Visual | Jump to edge downwards
| <kbd>g</kbd>+<kbd>k</kbd> | Normal/Visual | Jump to edge upwards

### Plugin: Signature

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>m</kbd> + <kbd>/</kbd> or <kbd>?</kbd> | Normal | Show list of buffer marks/markers
| <kbd>m</kbd> + <kbd>m</kbd> | Normal | Toggle mark on current line
| <kbd>m</kbd> + <kbd>,</kbd> | Normal | Place next mark
| <kbd>m</kbd> + <kbd>a-z</kbd> | Normal | Place specific mark (Won't work for: <kbd>m</kbd>, <kbd>n</kbd>, <kbd>p</kbd>)
| <kbd>d</kbd> + <kbd>m</kbd> + <kbd>a-z</kbd> | Normal | Remove specific mark (Won't work for: <kbd>m</kbd>, <kbd>n</kbd>, <kbd>p</kbd>)
| <kbd>m</kbd> + <kbd>n</kbd> | Normal | Jump to next mark
| <kbd>m</kbd> + <kbd>p</kbd> | Normal | Jump to previous mark
| <kbd>]</kbd> + <kbd>=</kbd> | Normal | Jump to next marker
| <kbd>[</kbd> + <kbd>=</kbd> | Normal | Jump to previous marker
| <kbd>m</kbd> + <kbd>-</kbd> | Normal | Purge all on current line
| <kbd>m</kbd> + <kbd>Space</kbd> | Normal | Purge marks
| <kbd>m</kbd> + <kbd>Backspace</kbd> | Normal | Purge markers

### Plugin: Easygit

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Space</kbd>+<kbd>ga</kbd> | Normal | Git add current file
| <kbd>Space</kbd>+<kbd>gS</kbd> | Normal | Git status
| <kbd>Space</kbd>+<kbd>gd</kbd> | Normal | Git diff
| <kbd>Space</kbd>+<kbd>gD</kbd> | Normal | Close diff
| <kbd>Space</kbd>+<kbd>gc</kbd> | Normal | Git commit
| <kbd>Space</kbd>+<kbd>gb</kbd> | Normal | Git blame
| <kbd>Space</kbd>+<kbd>gB</kbd> | Normal | Open in browser
| <kbd>Space</kbd>+<kbd>gp</kbd> | Normal | Git push

### Plugin: GitGutter

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>[</kbd>+<kbd>g</kbd> | Normal | Jump to next hunk
| <kbd>]</kbd>+<kbd>g</kbd> | Normal | Jump to previous hunk
| <kbd>g</kbd>+<kbd>S</kbd> | Normal | Stage hunk
| <kbd>Space</kbd>+<kbd>gr</kbd> | Normal | Revert hunk
| <kbd>g</kbd>+<kbd>s</kbd> | Normal | Preview hunk

### Plugin: Linediff

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Space</kbd>+<kbd>mda</kbd> | Visual | Sequentially mark region for diff
| <kbd>Space</kbd>+<kbd>mdf</kbd> | Visual | Mark region for diff and compare if more than one
| <kbd>Space</kbd>+<kbd>mds</kbd> | Normal | Shows the comparison for all marked regions
| <kbd>Space</kbd>+<kbd>mdr</kbd> | Normal | Removes the signs denoting the diff regions

### Misc Plugins

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>v</kbd> / <kbd>V</kbd> | Visual/select | Expand/reduce selection (expand-region)
| <kbd>-</kbd> | Normal | Choose a window to edit (choosewin)
| <kbd>Space</kbd>+<kbd>mg</kbd> | Normal | Open Magit
| <kbd>Space</kbd>+<kbd>mt</kbd> | Normal/Visual | Toggle highlighted word (quickhl)
| <kbd>Space</kbd>+<kbd>-</kbd> | Normal | Switch editing window with selected (choosewin)
| <kbd>Space</kbd>+<kbd>o</kbd> | Normal/Visual | Open SCM detailed URL in browser (`:OpenSCM`)
| <kbd>Space</kbd>+<kbd>t</kbd> | Normal | Open structure window (`:Vista`)
| <kbd>Space</kbd>+<kbd>a</kbd> | Normal | Show nearby tag in structure window (`:Vista show`)
| <kbd>Space</kbd>+<kbd>G</kbd> | Normal | Toggle distraction-free writing (goyo)
| <kbd>Space</kbd>+<kbd>gu</kbd> | Normal | Open undo-tree
| <kbd>Space</kbd>+<kbd>W</kbd> | Normal | VimWiki
| <kbd>Space</kbd>+<kbd>K</kbd> | Normal | Thesaurus

</details>

## Credits & Contribution

Big thanks to the dark knight [Shougo].

[Neovim]: https://github.com/neovim/neovim
[Vim8]: https://github.com/vim/vim
[Shougo]: https://github.com/Shougo
[lazy-loaded]: ./config/plugins.yaml#L47
[yaml2json]: https://github.com/bronze1man/yaml2json
