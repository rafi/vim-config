# Rafael Bodill's Neo/vim Config

Lean mean Neo/vim machine, 30-45ms startup time.

Best with Neovim or Vim 8 with +lua +python extensions enabled.

## Features

- Neovim-centric
- Fast startup time
- Robust, yet light weight
- Lazy-load 90% of plugins with [Shougo/dein.vim]
- Modular configuration
- Denite (Unite successor) centric work-flow
- Extensive Deoplete and Neocomplete setup
- Lightweight simple status/tabline
- Easy customizable theme
- Premium color-schemes
- Central location for tags

## Screenshot

![Vim screenshot](http://rafi.io/static/img/project/vim-config/features.png)

## Install

**_1._** Let's clone this repo! Clone to `~/.config/nvim`,
we'll also symlink it for Vim:

```sh
mkdir ~/.config
git clone git://github.com/rafi/vim-config.git ~/.config/nvim
ln -s ~/.vim ~/.config/nvim
```

* _Note:_ If your system sets `$XDG_CONFIG_HOME`,
  use that instead of `~/.config` in the code above.
  Nvim follows the XDG base-directories convention.

**_2._** Almost done! You'll need a YAML interpreter,
either install [yaml2json], or use PyYAML:

```sh
pip install --user PyYAML
```

**_3._** If you are a _first-time Neovim user_, you need the python-neovim
packages. Don't worry, run the script provided:

```sh
cd ~/.config/nvim
./venv.sh
```

**_4._** Run `make test` to test your nvim/vim version and compatibility.

**_5._** Run `make` to install all plugins.

Enjoy!

### Recommended Linters

* Node.js based linters:
  ```sh
  npm -g install jshint jsonlint stylelint markdownlint-cli sass-lint
  npm -g install jsxhint write-good raml-cop
  ```
* Python based linters:
  ```sh
  pip install --user pycodestyle pyflakes flake8 vim-vint proselint yamllint
  ```
* Shell lint: [shellcheck.net](https://www.shellcheck.net/)
* HTML Tidy: [html-tidy.org](http://www.html-tidy.org/)

### Recommended Tools

* Tern: `npm -g install tern`
* Universal ctags: [ctags.io](https://ctags.io/)
* The Silver Searcher: [ggreer/the_silver_searcher](https://github.com/ggreer/the_silver_searcher)
* Fuzzy file finders: [fzf](https://github.com/junegunn/fzf) or [peco](https://github.com/peco/peco)
* z - jump around: [rupa/z](https://github.com/rupa/z)

## Upgrade

Run `make update`

## Structure

- [config/](./config) - Configuration
  - [plugins/](./config/plugins) - Plugin configurations
  - [plugins.yaml](./config/plugins.yaml) - _**Plugins!**_
  - [vimrc](./config/vimrc) - Initialization
  - [init.vim](./config/init.vim) - `runtimepath` initialization
  - [general.vim](./config/general.vim) - General configuration
  - [neovim.vim](./config/neovim.vim) - Neovim specific setup
  - [mappings.vim](./config/mappings.vim) - Key-mappings
  - [theme.vim](./config/theme.vim) - Color-scheme and theme setup
  - [filetype.vim](./config/filetype.vim) - Language behavior
  - [menus.vim](./config/menus.vim) - User menus for reference
  - [terminal.vim](./config/terminal.vim) - Terminal configuration
- [ftplugin/](./ftplugin) - Language specific custom settings
- [plugin/](./plugin) - Customized small plugins
- [snippets/](./snippets) - Personal code snippets
- [themes/](./themes) - Themes! Combination of styles and color-scheme
- [filetype.vim](./filetype.vim) - Custom filetype detection

## Plugin Highlights

- Package management with caching enabled and lazy loading
- Project-aware tabs and label
- Vimfiler as file-manager + SSH connections
- Go completion via vim-go and gocode
- Javascript completion via Tern
- PHP completion, indent, folds, syntax
- Python jedi completion, pep8 convention
- Languages: Ansible, css3, csv, json, less, markdown, mustache
- Helpers: Undo tree, bookmarks, git, tmux navigation,
    hex editor, sessions, and much more.

_Note_ that 95% of the plugins are **[lazy-loaded]**.

## Non Lazy-Loaded Plugins

| Name           | Description
| -------------- | ----------------------
| [Shougo/dein.vim] | Dark powered Vim/Neovim plugin manager
| [rafi/awesome-colorschemes] | Awesome color-schemes
| [rafi/vim-blocks] | Bite-size blocks for Vim tab & status lines.
| [itchyny/vim-gitbranch] | Lightweight git branch detection
| [itchyny/vim-parenmatch] | Efficient alternative to the standard matchparen plugin
| [thinca/vim-localrc] | Enable configuration file of each directory
| [christoomey/tmux-navigator] | Seamless navigation between tmux panes and vim splits
| [tpope/vim-sleuth] | Heuristically set buffer indent options
| [itchyny/cursorword] | Underlines word under cursor

## Lazy-Loaded Plugins

### Language

Name           | Description
-------------- | ----------------------
[othree/html5.vim] | HTML5 omnicomplete and syntax
[mustache/vim-mustache-handlebars] | Mustache and handlebars syntax
[pearofducks/ansible-vim] | Additional support for Ansible
[mitsuhiko/vim-jinja] | Jinja support in vim
[groenewege/vim-less] | Syntax for LESS
[hail2u/vim-css3-syntax] | CSS3 syntax support to vim's built-in `syntax/css.vim`
[othree/csscomplete.vim] | Updated built-in CSS complete with latest standards
[plasticboy/vim-markdown] | Markdown syntax highlighting
[rhysd/vim-gfm-syntax] | GitHub Flavored Markdown syntax highlight extension
[pangloss/vim-javascript] | Enhanced Javascript syntax
[othree/jspc.vim] | JavaScript Parameter Complete
[MaxMEllon/vim-jsx-pretty] | React JSX syntax pretty highlighting
[heavenshell/vim-jsdoc] | Generate JSDoc to your JavaScript code
[moll/vim-node] | Superb development with Node.js
[elzr/vim-json] | Better JSON support
[fatih/vim-go] | Go development
[tbastos/vim-lua] | Improved Lua 5.3 syntax and indentation support
[vim-python/python-syntax] | Enhanced version of the original Python syntax
[Vimjas/vim-python-pep8-indent] | A nicer Python indentation style
[python_match.vim] | Extend the % motion for Python files
[raimon49/requirements.txt.vim] | Python requirements file format
[StanAngeloff/php.vim] | Up-to-date PHP syntax file (5.3 – 7.1 support)
[osyo-manga/vim-monster] | Ruby code completion
[toyamarinyon/vim-swift] | Swift support
[vim-jp/syntax-vim-ex] | Excellent Vim syntax highlighting
[m2mdas/phpcomplete-extended] | Fast PHP auto-complete with code inspection
[chrisbra/csv.vim] | Handling column separated data
[tmux-plugins/vim-tmux] | vim plugin for tmux.conf
[cespare/vim-toml] | Syntax for TOML
[PotatoesMaster/i3-vim-syntax] | i3 window manager config syntax
[dag/vim-fish] | Fish shell edit support
[ekalinin/Dockerfile.vim] | syntax and snippets for Dockerfile
[jstrater/mpvim] | Macports portfile configuration files
[tpope/vim-git] | Git runtime files
[robbles/logstash.vim] | Highlights logstash configuration files
[andreshazard/vim-logreview] | Bueatify log viewing
[exu/pgsql.vim] | PostgreSQL syntax
[othree/nginx-contrib-vim] | Fork official vim nginx
[IN3D/vim-raml] | Syntax and language settings for RAML

### Commands

Name           | Description
-------------- | ----------------------
[scrooloose/nerdtree] | Tree explorer plugin
[Xuyuanp/nerdtree-git-plugin] | NERDTree plugin for showing git status
[tpope/vim-commentary] | Comment stuff out
[lambdalisue/vim-gita] | An awesome git handling plugin
[t9md/vim-choosewin] | Choose window to use, like tmux's 'display-pane'
[Shougo/vinarise.vim] | Hex editor
[kana/vim-niceblock] | Make blockwise Visual mode more useful
[guns/xterm-color-table.vim] | Display 256 xterm colors with their RGB equivalents
[thinca/vim-prettyprint] | Pretty-print vim variables
[mbbill/undotree] | Ultimate undo history visualizer
[metakirby5/codi.vim] | The interactive scratchpad for hackers
[Shougo/vimproc.vim] | Interactive command execution
[reedes/vim-wordy] | Uncover usage problems in your writing
[kien/tabman.vim] | Tab management
[hecal3/vim-leader-guide] | Keymap-display loosely inspired by emacs's guide-key
[majutsushi/tagbar] | Displays tags in a window, ordered by scope
[lambdalisue/vim-gista] | Manipulate gists in Vim
[beloglazov/vim-online-thesaurus] | Look up words in an online thesaurus

### Interface

Name           | Description
-------------- | ----------------------
[haya14busa/vim-asterisk] | Improved * motions
[rhysd/accelerated-jk] | Accelerate up-down moving
[Shougo/tabpagebuffer.vim] | Tabpage buffer interface
[airblade/vim-gitgutter] | Show git diff in the gutter and stages/undoes hunks
[nathanaelkane/vim-indent-guides] | Visually display indent levels in code
[MattesGroeger/vim-bookmarks] | Bookmarks, works independently from vim marks
[rhysd/committia.vim] | Pleasant editing on Git commit messages
[benekastah/neomake] | Asynchronous linting and make framework
[goyo] | Distraction-free writing
[limelight] | Hyperfocus-writing
[junegunn/vim-peekaboo] | See the contents of the registers
[itchyny/calendar.vim] | Calendar application
[vimwiki/vimwiki] | Personal Wiki for Vim

### Completion

Name           | Description
-------------- | ----------------------
[Shougo/deoplete.nvim] | Neovim: Dark powered asynchronous completion framework
[Shougo/neocomplete] | Next generation completion framework
[Shougo/neosnippet.vim] | Contains neocomplete snippets source
[Raimondi/delimitMate] | Auto-completion for quotes, parens, brackets
[ludovicchabant/vim-gutentags] | Manages your tag files
[mattn/emmet-vim] | Provides support for expanding abbreviations alá emmet
[Shougo/echodoc.vim] | Print objects' documentation in echo area
[Shougo/neosnippet-snippets] | Standard snippets repository for neosnippet
[davidhalter/jedi-vim] | Python jedi autocompletion library
[zchee/deoplete-go] | deoplete.nvim source for Go
[zchee/deoplete-jedi] | deoplete.nvim source for Python
[carlitux/deoplete-ternjs] | deoplete.nvim source for javascript
[wellle/tmux-complete.vim] | Completion of words in adjacent tmux panes
[ternjs/tern_for_vim] | Provides Tern-based JavaScript editing support

### Denite

Name           | Description
-------------- | ----------------------
[Shougo/denite.nvim] | Dark powered asynchronous unite all interfaces
[nixprime/cpsm] | File matcher, specialized for paths
[chemzqm/unite-location] | Denite location & quickfix lists
[rafi/vim-denite-mpc] | Denite source for browsing your MPD music library

### Operators & Text Objects

Name           | Description
-------------- | ----------------------
[kana/vim-operator-user] | Define your own operator easily
[kana/vim-operator-replace] | Operator to replace text with register content
[rhysd/vim-operator-surround] | Operator to enclose text objects
[haya14busa/vim-operator-flashy] | Highlight yanked area
[kana/vim-textobj-user] | Create your own text objects
[bkad/CamelCaseMotion] | Provide CamelCase motion through words
[erryma/vim-expand-region] | Visually select increasingly larger regions of text
[AndrewRadev/sideways.vim] | Match function arguments
[AndrewRadev/splitjoin.vim] | Transition code between multi-line and single-line
[AndrewRadev/linediff.vim] | Perform diffs on blocks of code
[glts/vim-textobj-comment] | Text objects for comments
[AndrewRadev/dsf.vim] | Delete surrounding function call
[osyo-manga/vim-textobj-multiblock] | Handle multiple brackets objects
[kana/vim-textobj-function] | Text objects for functions

[Shougo/dein.vim]: https://github.com/Shougo/dein.vim
[rafi/awesome-colorschemes]: https://github.com/rafi/awesome-vim-colorschemes
[rafi/vim-blocks]: https://github.com/rafi/vim-blocks
[itchyny/vim-gitbranch]: https://github.com/itchyny/vim-gitbranch
[itchyny/vim-parenmatch]: https://github.com/itchyny/vim-parenmatch
[thinca/vim-localrc]: https://github.com/thinca/vim-localrc
[christoomey/tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[tpope/vim-sleuth]: https://github.com/tpope/vim-sleuth
[itchyny/cursorword]: https://github.com/itchyny/vim-cursorword

[othree/html5.vim]: https://github.com/othree/html5.vim
[mustache/vim-mustache-handlebars]: https://github.com/mustache/vim-mustache-handlebars
[pearofducks/ansible-vim]: https://github.com/pearofducks/ansible-vim
[mitsuhiko/vim-jinja]: https://github.com/mitsuhiko/vim-jinja
[groenewege/vim-less]: https://github.com/groenewege/vim-less
[hail2u/vim-css3-syntax]: https://github.com/hail2u/vim-css3-syntax
[othree/csscomplete.vim]: https://github.com/othree/csscomplete.vim
[plasticboy/vim-markdown]: https://github.com/plasticboy/vim-markdown
[rhysd/vim-gfm-syntax]: https://github.com/rhysd/vim-gfm-syntax
[pangloss/vim-javascript]: https://github.com/pangloss/vim-javascript
[othree/jspc.vim]: https://github.com/othree/jspc.vim
[MaxMEllon/vim-jsx-pretty]: https://github.com/MaxMEllon/vim-jsx-pretty
[heavenshell/vim-jsdoc]: https://github.com/heavenshell/vim-jsdoc
[moll/vim-node]: https://github.com/moll/vim-node
[elzr/vim-json]: https://github.com/elzr/vim-json
[fatih/vim-go]: https://github.com/fatih/vim-go
[tbastos/vim-lua]: https://github.com/tbastos/vim-lua
[vim-python/python-syntax]: https://github.com/vim-python/python-syntax
[Vimjas/vim-python-pep8-indent]: https://github.com/Vimjas/vim-python-pep8-indent
[python_match.vim]: https://github.com/vim-scripts/python_match.vim
[raimon49/requirements.txt.vim]: https://github.com/raimon49/requirements.txt.vim
[StanAngeloff/php.vim]: https://github.com/StanAngeloff/php.vim
[osyo-manga/vim-monster]: https://github.com/osyo-manga/vim-monster
[toyamarinyon/vim-swift]: https://github.com/toyamarinyon/vim-swift
[vim-jp/syntax-vim-ex]: https://github.com/vim-jp/syntax-vim-ex
[m2mdas/phpcomplete-extended]: https://github.com/m2mdas/phpcomplete-extended
[chrisbra/csv.vim]: https://github.com/chrisbra/csv.vim
[tmux-plugins/vim-tmux]: https://github.com/tmux-plugins/vim-tmux
[cespare/vim-toml]: https://github.com/cespare/vim-toml
[PotatoesMaster/i3-vim-syntax]: https://github.com/PotatoesMaster/i3-vim-syntax
[dag/vim-fish]: https://github.com/dag/vim-fish
[ekalinin/Dockerfile.vim]: https://github.com/ekalinin/Dockerfile.vim
[jstrater/mpvim]: https://github.com/jstrater/mpvim
[tpope/vim-git]: https://github.com/tpope/vim-git
[robbles/logstash.vim]: https://github.com/robbles/logstash.vim
[andreshazard/vim-logreview]: https://github.com/andreshazard/vim-logreview
[exu/pgsql.vim]: https://github.com/exu/pgsql.vim
[othree/nginx-contrib-vim]: https://github.com/othree/nginx-contrib-vim
[IN3D/vim-raml]: https://github.com/IN3D/vim-raml

[scrooloose/nerdtree]: https://github.com/scrooloose/nerdtree
[Xuyuanp/nerdtree-git-plugin]: https://github.com/Xuyuanp/nerdtree-git-plugin
[tpope/vim-commentary]: https://github.com/tpope/vim-commentary
[lambdalisue/vim-gita]: https://github.com/lambdalisue/vim-gita
[t9md/vim-choosewin]: https://github.com/t9md/vim-choosewin
[Shougo/vinarise.vim]: https://github.com/Shougo/vinarise.vim
[kana/vim-niceblock]: https://github.com/kana/vim-niceblock
[guns/xterm-color-table.vim]: https://github.com/guns/xterm-color-table.vim
[thinca/vim-prettyprint]: https://github.com/thinca/vim-prettyprint
[mbbill/undotree]: https://github.com/mbbill/undotree
[metakirby5/codi.vim]: https://github.com/metakirby5/codi.vim
[Shougo/vimproc.vim]: https://github.com/Shougo/vimproc.vim
[reedes/vim-wordy]: https://github.com/reedes/vim-wordy
[kien/tabman.vim]: https://github.com/kien/tabman.vim
[hecal3/vim-leader-guide]: https://github.com/hecal3/vim-leader-guide
[majutsushi/tagbar]: https://github.com/majutsushi/tagbar
[lambdalisue/vim-gista]: https://github.com/lambdalisue/vim-gista
[beloglazov/vim-online-thesaurus]: https://github.com/beloglazov/vim-online-thesaurus

[haya14busa/vim-asterisk]: https://github.com/haya14busa/vim-asterisk
[rhysd/accelerated-jk]: https://github.com/rhysd/accelerated-jk
[Shougo/tabpagebuffer.vim]: https://github.com/Shougo/tabpagebuffer.vim
[airblade/vim-gitgutter]: https://github.com/airblade/vim-gitgutter
[nathanaelkane/vim-indent-guides]: https://github.com/nathanaelkane/vim-indent-guides
[MattesGroeger/vim-bookmarks]: https://github.com/MattesGroeger/vim-bookmarks
[rhysd/committia.vim]: https://github.com/rhysd/committia.vim
[benekastah/neomake]: https://github.com/neomake/neomake
[goyo]: https://github.com/junegunn/goyo.vim
[limelight]: https://github.com/junegunn/limelight.vim
[junegunn/vim-peekaboo]: https://github.com/junegunn/vim-peekaboo
[itchyny/calendar.vim]: https://github.com/itchyny/calendar.vim
[vimwiki/vimwiki]: https://github.com/vimwiki/vimwiki

[Shougo/deoplete.nvim]: https://github.com/Shougo/deoplete.nvim
[Shougo/neocomplete]: https://github.com/Shougo/neocomplete.vim
[Shougo/neosnippet.vim]: https://github.com/Shougo/neosnippet.vim
[Raimondi/delimitMate]: https://github.com/Raimondi/delimitMate
[ludovicchabant/vim-gutentags]: https://github.com/ludovicchabant/vim-gutentags
[mattn/emmet-vim]: https://github.com/mattn/emmet-vim
[Shougo/echodoc.vim]: https://github.com/Shougo/echodoc.vim
[Shougo/neosnippet-snippets]: https://github.com/Shougo/neosnippet-snippets
[davidhalter/jedi-vim]: https://github.com/davidhalter/jedi-vim
[zchee/deoplete-go]: https://github.com/zchee/deoplete-go
[zchee/deoplete-jedi]: https://github.com/zchee/deoplete-jedi
[carlitux/deoplete-ternjs]: https://github.com/carlitux/deoplete-ternjs
[wellle/tmux-complete.vim]: https://github.com/wellle/tmux-complete.vim
[ternjs/tern_for_vim]: https://github.com/ternjs/tern_for_vim

[Shougo/denite.nvim]: https://github.com/Shougo/denite.nvim
[nixprime/cpsm]: https://github.com/nixprime/cpsm
[chemzqm/unite-location]: https://github.com/chemzqm/unite-location
[rafi/vim-denite-mpc]: https://github.com/rafi/vim-denite-mpc

[kana/vim-operator-user]: https://github.com/kana/vim-operator-user
[kana/vim-operator-replace]: https://github.com/kana/vim-operator-replace
[rhysd/vim-operator-surround]: https://github.com/rhysd/vim-operator-surround
[haya14busa/vim-operator-flashy]: https://github.com/haya14busa/vim-operator-flashy
[kana/vim-textobj-user]: https://github.com/kana/vim-textobj-user
[bkad/CamelCaseMotion]: https://github.com/bkad/CamelCaseMotion
[terryma/vim-expand-region]: https://github.com/terryma/vim-expand-region
[AndrewRadev/sideways.vim]: https://github.com/AndrewRadev/sideways.vim
[AndrewRadev/splitjoin.vim]: https://github.com/AndrewRadev/splitjoin.vim
[AndrewRadev/linediff.vim]: https://github.com/AndrewRadev/linediff.vim
[glts/vim-textobj-comment]: https://github.com/glts/vim-textobj-comment
[AndrewRadev/dsf.vim]: https://github.com/AndrewRadev/dsf.vim
[osyo-manga/vim-textobj-multiblock]: https://github.com/osyo-manga/vim-textobj-multiblock
[kana/vim-textobj-function]: https://github.com/kana/vim-textobj-function

## Custom Key-mappings

Key   | Mode | Action
----- |:----:| ------------------
`Space` | Normal | **Leader**
Arrows | Normal | Resize splits (* Enable `g:elite_mode` in `.vault.vim`)
`Backspace` | Normal | Match bracket (%)
`K` | Normal | Open Zeal or Dash on many file types (except Python+Vim script)
`Y` | Normal | Yank to the end of line (y$)
`<Return>` | Normal | Toggle fold (za)
`S`+`<Return>` | Normal | Focus the current fold by closing all others (zMza)
`S`+`<Return>` | Insert | Start new line from any cursor position (\<C-o>o)
`hjkl` | Normal | Smart cursor movements (g/hjkl)
`Ctrl`+`f` | Normal | Smart page forward (C-f/C-d)
`Ctrl`+`b` | Normal | Smart page backwards (C-b/C-u)
`Ctrl`+`e` | Normal | Smart scroll down (3C-e/j)
`Ctrl`+`y` | Normal | Smart scroll up (3C-y/k)
`Ctrl`+`q` | Normal | `Ctrl`+`w`
`Ctrl`+`x` | Normal | Switch buffer and placement
`F2` | _All_ | Toggle paste mode
`!` | Normal | Shortcut for `:!`
`}` | Normal | After paragraph motion go to first non-blank char (}^)
`<` | Visual/Normal | Indent to left and re-select
`>` | Visual/Normal | Indent to right and re-select
`Tab` | Visual | Indent to right and re-select
`Shift`+`Tab` | Visual | Indent to left and re-select
`gh` | Normal | Show highlight group that matches current cursor
`gp` | Normal | Select last paste
`Q`/`gQ` | Normal | Disable EX-mode (\<Nop>)
`s` | Visual | Replace within selected area
`Ctrl`+`a` | Command | Navigation in command line
`Ctrl`+`b` | Command | Move cursor backward in command line
`Ctrl`+`f` | Command | Move cursor forward in command line
`Ctrl`+`r` | Visual | Replace selection with step-by-step confirmation
`,`+`Space` | Normal | Remove all spaces at EOL
`,`+`d` | Normal | Toggle diff
`<leader>`+`os` | Normal | Load last session
`<leader>`+`se` | Normal | Save current workspace as last session
`<leader>`+`d` | Normal/Visual | Duplicate line or selection
`<leader>`+`S` | Normal/visual | Source selection
`<leader>`+`ml` | Normal | Append modeline

### File Operations

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`cd` | Normal | Switch to the directory of opened buffer (:lcd %:p:h)
`<leader>`+`w` | Normal/visual | Write (:w)
`<leader>`+`y` | Normal | Copy file-path to X11 clipboard
`Ctrl`+`s` | _All_ | Write (:w)
`W!!` | Command | Write as root

### Editor UI

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`ti` | Normal | Toggle indentation lines
`<leader>`+`ts` | Normal | Toggle spell-checker (:setlocal spell!)
`<leader>`+`tn` | Normal | Toggle line numbers (:setlocal nonumber!)
`<leader>`+`tl` | Normal | Toggle hidden characters (:setlocal nolist!)
`<leader>`+`th` | Normal | Toggle highlighted search (:set hlsearch!)
`<leader>`+`tw` | Normal | Toggle wrap (:setlocal wrap! breakindent!)
`g0` | Normal | Go to first tab (:tabfirst)
`g$` | Normal | Go to last tab (:tablast)
`gr` | Normal | Go to preview tab (:tabprevious)
`Ctrl`+`j` | Normal | Move to split below (\<C-w>j)
`Ctrl`+`k` | Normal | Move to upper split (\<C-w>k)
`Ctrl`+`h` | Normal | Move to left split (\<C-w>h)
`Ctrl`+`l` | Normal | Move to right split (\<C-w>l)
`*` | Visual | Search selection forwards
`#` | Visual | Search selection backwards
`<leader>`+`j` | Normal | Next on location list
`<leader>`+`k` | Normal | Previous on location list
`<leader>`+`b` | Normal | Toggle colorscheme background dark/light
`s`+`-` | Normal | Lower colorscheme contrast (Only solarized8)
`s`+`=` | Normal | Raise colorscheme contrast (Only solarized8)

### Window Management

Key   | Mode | Action
----- |:----:| ------------------
`q` | Normal | Smart buffer close
`s`+`p` | Normal | Split nicely
`s`+`v` | Normal | Horizontal (:split)
`s`+`g` | Normal | Vertical split (:vsplit)
`s`+`t` | Normal | Open new tab (:tabnew)
`s`+`o` | Normal | Close other windows (:only)
`s`+`x` | Normal | Remove buffer, leave blank window
`s`+`q` | Normal | Closes current buffer (:close)
`s`+`Q` | Normal | Removes current buffer (:bdelete)
`Tab` | Normal | Next window or tab
`Shift`+`Tab` | Normal | Previous window or tab
`<leader>`+`sv` | Normal | Split with previous buffer
`<leader>`+`sg` | Normal | Vertical split with previous buffer

### Plugin: Denite

Key   | Mode | Action
----- |:----:| ------------------
`;`+`r` | Normal | Resumes Denite window
`;`+`f` | Normal | Open file recursive search
`;`+`b` | Normal | List buffers and MRU
`;`+`d` | Normal | List directories
`;`+`l` | Normal | Open location list entries
`;`+`q` | Normal | Open quick fix entries
`;`+`n` | Normal | Open Dein plugin list
`;`+`g` | Normal | Input for grep search
`;`+`j` | Normal | Open file jump points
`;`+`k` | Normal | Open all marks
`;`+`s` | Normal | List all sessions
`;`+`/` | Normal | List all lines
`;`+`*` | Normal | Search word in all lines
`<leader>`+`gf` | Normal | Open matching file results with word at cursor
`<leader>`+`gg` | Visual | Open grep results with word at cursor
| **Within _Denite_ mode** |||
`Escape` | Normal/Insert | Toggle modes
`jj` | Insert | Leave Insert mode
`Ctrl`+`y` | Insert | Redraw
`r` | Normal | Redraw
`st` | Normal | Open in a new tab
`sg` | Normal | Open in a vertical split
`sv` | Normal | Open in a split
`'` | Normal | Toggle mark current candidate

### Plugin: NERDTree

Key   | Mode | Action
----- |:----:| ------------------
`;`+`e` | Normal | Toggle file explorer
`;`+`a` | Normal | Toggle file explorer on current file
| **Within _NERDTree_ buffers** |||
`h/j/k/l` | Normal | Movement + collapse/expand + file open
`w` | Normal | Toggle window size
`N` | Normal | Create new file or directory
`yy` | Normal | Yank selected item to clipboard
`sv` | Normal | Open file in new tab
`sv` | Normal | Open file in a horizontal split
`sg` | Normal | Open file in a vertical split
`&` | Normal | Jump to project root
`gh` | Normal | Jump to user's home directory
`gd` | Normal | Open split diff on selected file
`gf` | Normal | Search in selected directory for files
`gr` | Normal | Grep in selected directory

### Plugin: deoplete / neocomplete

Key   | Mode | Action
----- |:----:| ------------------
`Enter` | Insert | Smart snippet expansion
`Tab` | Insert/select | Smart tab movement or completion
`Ctrl`+`j/k/f/b` | Insert | Movement in popup
`Ctrl`+`g` | Insert | Undo completion
`Ctrl`+`l` | Insert | Complete common string
`Ctrl`+`o` | Insert | Expand snippet
`Ctrl`+`y` | Insert | Close pop-up
`Ctrl`+`e` | Insert | Close pop-up
`Ctrl`+`l` | Insert | Complete common string
`Ctrl`+`d` | Insert | Scroll down
`Ctrl`+`u` | Insert | Scroll up

### Plugin: Commentary

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`v` | Normal/visual | Toggle single-line comments
`<leader>`+`V` | Normal/visual | Toggle comment block

### Plugin: Expand-Region

Key   | Mode | Action
----- |:----:| ------------------
`v` | Visual/Select | Expand selection
`V` | Visual/Select | Reduce selection

### Plugin: ChooseWin

Key   | Mode | Action
----- |:----:| ------------------
`-` | Normal | Choose a window to edit
`<leader>`+`-` | Normal | Switch editing window with selected

### Plugin: Bookmarks

Key   | Mode | Action
----- |:----:| ------------------
`m`+`a` | Normal | Show list of all bookmarks
`m`+`m` | Normal | Toggle bookmark in current line
`m`+`n` | Normal | Jump to next bookmark
`m`+`p` | Normal | Jump to previous bookmark
`m`+`i` | Normal | Annotate bookmark

### Plugin: Tagbar

Key   | Mode | Action
----- |:----:| ------------------
`h` | Normal | Close fold
`l` | Normal | Open fold

### Plugin: Gita

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`gs` | Normal | Git status
`<leader>`+`gd` | Normal | Git diff
`<leader>`+`gc` | Normal | Git commit
`<leader>`+`gb` | Normal | Git blame
`<leader>`+`gB` | Normal | Open in browser
`<leader>`+`gp` | Normal | Git push

### Plugin: GitGutter

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`hj` | Normal | Jump to next hunk
`<leader>`+`hk` | Normal | Jump to previous hunk
`<leader>`+`hs` | Normal | Stage hunk
`<leader>`+`hr` | Normal | Revert hunk
`<leader>`+`hp` | Normal | Preview hunk

### Misc Plugins

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`o` | Normal | Open tag-bar
`<leader>`+`tt` | Normal | Open tab-manager
`<leader>`+`G` | Normal | Toggle distraction-free writing
`<leader>`+`gu` | Normal | Open undo tree
`<leader>`+`W` | Normal | Wiki
`<leader>`+`K` | Normal | Thesaurus

## Credits & Contribution

Big thanks to the dark knight [Shougo].

[Shougo]: https://github.com/Shougo
[lazy-loaded]: ./config/plugins.yaml
[yaml2json]: https://github.com/koraa/large-yaml2json-json2yaml
