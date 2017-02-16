# Rafael Bodill's Neo/vim Config

Lean mean Neo/vim machine, 30-45ms startup time.

Best with Neovim or Vim 7.4+ with +lua +python extensions enabled.

## Features

- Neovim-centric
- Fast startup time
- Robust, yet light weight
- Lazy-load 90% of plugins with [dein.vim]
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

That's it, enjoy!

## Upgrade

Run `make update`

## Structure

- [config](./config)/ - Configuration
  - [plugins](./config/plugins)/ - Plugin configurations
  - [mappings.vim](./config/mappings.vim) - Key-mappings
  - [filetype.vim](./config/filetype.vim) - Language behavior
  - [general.vim](./config/general.vim) - General configuration
  - [init.vim](./config/init.vim) - `runtimepath` initialization
  - [neovim.vim](./config/neovim.vim) - Neovim specific setup
  - [plugins.vim](./config/plugins.vim) - Plugin bundles
  - [terminal.vim](./config/terminal.vim) - Terminal configuration
  - [theme.vim](./config/theme.vim) - Color-scheme and theme setup
  - [vimrc](./config/vimrc) - Initialization
- [ftplugin](./ftplugin)/ - Language specific custom settings
- [plugin](./plugin)/ - Customized small plugins
- [snippets](./snippets)/ - Personal code snippets
- [themes](./themes)/ - Themes! Combination of styles and color-scheme
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

_Note_ that 90% of the plugins are **[lazy-loaded]**.

## Non Lazy-Loaded Plugins

| Name           | Description
| -------------- | ----------------------
| [Shougo/dein.vim] | Dark powered Vim/Neovim plugin manager
| [w0ng/vim-hybrid] | 
| [rafi/vim-blocks] | 
| [itchyny/vim-gitbranch] | Lightweight git branch detection
| [itchyny/vim-parenmatch] | 
| [thinca/vim-localrc] | 
| [christoomey/tmux-navigator] | Seamless navigation between tmux panes and vim splits
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
[othree/csscomplete.vim] | 
[plasticboy/vim-markdown] | Markdown syntax highlighting
[rhysd/vim-gfm-syntax] | 
[pangloss/vim-javascript] | Enhanced Javascript syntax
[othree/jspc.vim] | 
[MaxMEllon/vim-jsx-pretty] | 
[heavenshell/vim-jsdoc] | 
[moll/vim-node] | 
[elzr/vim-json] | Better JSON support
[fatih/vim-go] | Go development
[tbastos/vim-lua] | 
[mitsuhiko/vim-python-combined] | 
[python_match.vim] | 
[raimon49/requirements.txt.vim] | 
[StanAngeloff/php.vim] | Up-to-date PHP syntax file
[osyo-manga/vim-monster] | 
[toyamarinyon/vim-swift] | 
[vim-jp/syntax-vim-ex] | 
[m2mdas/phpcomplete-extended] | 
[chrisbra/csv.vim] | Handling column separated data
[tmux-plugins/vim-tmux] | vim plugin for tmux.conf
[cespare/vim-toml] | Syntax for TOML
[PotatoesMaster/i3-vim-syntax] | i3 window manager config syntax
[dag/vim-fish] | 
[ekalinin/Dockerfile.vim] | syntax and snippets for Dockerfile
[jstrater/mpvim] | Macports portfile configuration files
[tpope/vim-git] | 
[robbles/logstash.vim] | Highlights logstash configuration files
[andreshazard/vim-logreview] | 
[exu/pgsql.vim] | 
[othree/nginx-contrib-vim] | 
[IN3D/vim-raml] | 

### Commands

Name           | Description
-------------- | ----------------------
[scrooloose/nerdtree] | 
[Xuyuanp/nerdtree-git-plugin] | 
[tpope/vim-commentary] | 
[lambdalisue/vim-gita] | An awesome git handling plugin
[t9md/vim-choosewin] | Choose window to use, like tmux's 'display-pane'
[Shougo/vinarise.vim] | Hex editor
[kana/vim-niceblock] | 
[guns/xterm-color-table.vim] | 
[thinca/vim-prettyprint] | Pretty-print vim variables
[mbbill/undotree] | Ultimate undo history visualizer
[metakirby5/codi.vim] | 
[Shougo/vimproc.vim] | Interactive command execution
[reedes/vim-wordy] | 
[kien/tabman.vim] | 
[hecal3/vim-leader-guide] | 
[majutsushi/tagbar] | 
[lambdalisue/vim-gista] | Manipulate gists in Vim
[beloglazov/vim-online-thesaurus] | Look up words in an online thesaurus

### Interface

Name           | Description
-------------- | ----------------------
[haya14busa/vim-asterisk] | 
[rhysd/accelerated-jk] | 
[Shougo/tabpagebuffer.vim] | 
[airblade/vim-gitgutter] | 
[lambdalisue/vim-findent] | 
[nathanaelkane/vim-indent-guides] | 
[MattesGroeger/vim-bookmarks] | Bookmarks, works independently from vim marks
[rhysd/committia.vim] | 
[benekastah/neomake] | 
[goyo] | Distraction-free writing
[limelight] | Hyperfocus-writing
[junegunn/vim-peekaboo] | 
[itchyny/calendar.vim] | 
[vimwiki/vimwiki] | Personal Wiki for Vim

### Completion

Name           | Description
-------------- | ----------------------
[Shougo/deoplete.nvim] | Neovim: Dark powered asynchronous completion framework
[Shougo/neocomplete] | Next generation completion framework
[Shougo/neosnippet.vim] | Contains neocomplete snippets source
[Raimondi/delimitMate] | Insert mode auto-completion for quotes, parens, brackets
[ludovicchabant/vim-gutentags] | 
[mattn/emmet-vim] | 
[Shougo/echodoc.vim] | Print objects' documentation in echo area
[Shougo/neosnippet-snippets] | 
[davidhalter/jedi-vim] | Python jedi autocompletion library
[zchee/deoplete-go] | 
[zchee/deoplete-jedi] | 
[carlitux/deoplete-ternjs] | 
[wellle/tmux-complete.vim] | 
[ternjs/tern_for_vim] | Provides Tern-based JavaScript editing support

### Denite

Name           | Description
-------------- | ----------------------
[Shougo/denite.nvim] | 
[nixprime/cpsm] | 
[chemzqm/unite-location] | 
[rafi/vim-denite-mpc] | 

### Operators & Text Objects

Name           | Description
-------------- | ----------------------
[kana/vim-operator-user] | Define your own operator easily
[kana/vim-operator-replace] | Operator to replace text with register content
[rhysd/vim-operator-surround] | Operator to enclose text objects
[haya14busa/vim-operator-flashy] | 
[kana/vim-textobj-user] | Create your own text objects
[bkad/CamelCaseMotion] | 
[AndrewRadev/sideways.vim] | 
[AndrewRadev/splitjoin.vim] | 
[AndrewRadev/linediff.vim] | 
[glts/vim-textobj-comment] | 
[AndrewRadev/dsf.vim] | 
[osyo-manga/vim-textobj-multiblock] | Handle multiple brackets objects
[kana/vim-textobj-function] | 

[Shougo/dein.vim]: https://github.com/Shougo/dein.vim
[w0ng/vim-hybrid]: 
[rafi/vim-blocks]: 
[itchyny/vim-gitbranch]: https://github.com/itchyny/vim-gitbranch
[itchyny/vim-parenmatch]: 
[thinca/vim-localrc]: 
[christoomey/tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[itchyny/cursorword]: https://github.com/itchyny/vim-cursorword

[othree/html5.vim]: https://github.com/othree/html5.vim
[mustache/vim-mustache-handlebars]: https://github.com/mustache/vim-mustache-handlebars
[pearofducks/ansible-vim]: https://github.com/pearofducks/ansible-vim
[mitsuhiko/vim-jinja]: https://github.com/mitsuhiko/vim-jinja
[groenewege/vim-less]: https://github.com/groenewege/vim-less
[hail2u/vim-css3-syntax]: https://github.com/hail2u/vim-css3-syntax
[othree/csscomplete.vim]: 
[plasticboy/vim-markdown]: https://github.com/plasticboy/vim-markdown
[rhysd/vim-gfm-syntax]: 
[pangloss/vim-javascript]: https://github.com/pangloss/vim-javascript
[othree/jspc.vim]: 
[MaxMEllon/vim-jsx-pretty]: 
[heavenshell/vim-jsdoc]: 
[moll/vim-node]: 
[elzr/vim-json]: https://github.com/elzr/vim-json
[fatih/vim-go]: https://github.com/fatih/vim-go
[tbastos/vim-lua]: 
[mitsuhiko/vim-python-combined]: 
[python_match.vim]: 
[raimon49/requirements.txt.vim]: 
[StanAngeloff/php.vim]: https://github.com/StanAngeloff/php.vim
[osyo-manga/vim-monster]: 
[toyamarinyon/vim-swift]: 
[vim-jp/syntax-vim-ex]: 
[m2mdas/phpcomplete-extended]: 
[chrisbra/csv.vim]: https://github.com/chrisbra/csv.vim
[tmux-plugins/vim-tmux]: https://github.com/tmux-plugins/vim-tmux
[cespare/vim-toml]: https://github.com/cespare/vim-toml
[PotatoesMaster/i3-vim-syntax]: https://github.com/PotatoesMaster/i3-vim-syntax
[dag/vim-fish]: 
[ekalinin/Dockerfile.vim]: https://github.com/ekalinin/Dockerfile.vim
[jstrater/mpvim]: https://github.com/jstrater/mpvim
[tpope/vim-git]: 
[robbles/logstash.vim]: https://github.com/robbles/logstash.vim
[andreshazard/vim-logreview]: 
[exu/pgsql.vim]: 
[othree/nginx-contrib-vim]: 
[IN3D/vim-raml]: 

[scrooloose/nerdtree]: 
[Xuyuanp/nerdtree-git-plugin]: 
[tpope/vim-commentary]: 
[lambdalisue/vim-gita]: https://github.com/lambdalisue/vim-gita
[t9md/vim-choosewin]: https://github.com/t9md/vim-choosewin
[Shougo/vinarise.vim]: https://github.com/Shougo/vinarise.vim
[kana/vim-niceblock]: 
[guns/xterm-color-table.vim]: 
[thinca/vim-prettyprint]: https://github.com/thinca/vim-prettyprint
[mbbill/undotree]: https://github.com/mbbill/undotree
[metakirby5/codi.vim]: 
[Shougo/vimproc.vim]: https://github.com/Shougo/vimproc.vim
[reedes/vim-wordy]:
[kien/tabman.vim]:
[hecal3/vim-leader-guide]:
[majutsushi/tagbar]:
[lambdalisue/vim-gista]: https://github.com/lambdalisue/vim-gista
[beloglazov/vim-online-thesaurus]: https://github.com/beloglazov/vim-online-thesaurus

[haya14busa/vim-asterisk]:
[rhysd/accelerated-jk]:
[Shougo/tabpagebuffer.vim]:
[airblade/vim-gitgutter]: https://github.com/airblade/vim-gitgutter
[lambdalisue/vim-findent]:
[nathanaelkane/vim-indent-guides]:
[MattesGroeger/vim-bookmarks]: https://github.com/MattesGroeger/vim-bookmarks
[rhysd/committia.vim]: 
[benekastah/neomake]: 
[goyo]: https://github.com/junegunn/goyo.vim
[limelight]: https://github.com/junegunn/limelight.vim
[junegunn/vim-peekaboo]: 
[itchyny/calendar.vim]: 
[vimwiki/vimwiki]: https://github.com/vimwiki/vimwiki

[Shougo/deoplete.nvim]: https://github.com/Shougo/deoplete.nvim
[Shougo/neocomplete]: https://github.com/Shougo/neocomplete.vim
[Shougo/neosnippet.vim]: https://github.com/Shougo/neosnippet.vim
[Raimondi/delimitMate]: https://github.com/Raimondi/delimitMate
[ludovicchabant/vim-gutentags]: 
[mattn/emmet-vim]: 
[Shougo/echodoc.vim]: https://github.com/Shougo/echodoc.vim
[Shougo/neosnippet-snippets]: 
[davidhalter/jedi-vim]: https://github.com/davidhalter/jedi-vim
[zchee/deoplete-go]: 
[zchee/deoplete-jedi]: 
[carlitux/deoplete-ternjs]: 
[wellle/tmux-complete.vim]: 
[ternjs/tern_for_vim]: https://github.com/ternjs/tern_for_vim

[Shougo/denite.nvim]: 
[nixprime/cpsm]: 
[chemzqm/unite-location]: 
[rafi/vim-denite-mpc]: 

[kana/vim-operator-user]: https://github.com/kana/vim-operator-user
[kana/vim-operator-replace]: https://github.com/kana/vim-operator-replace
[rhysd/vim-operator-surround]: https://github.com/rhysd/vim-operator-surround
[haya14busa/vim-operator-flashy]: 
[kana/vim-textobj-user]: https://github.com/kana/vim-textobj-user
[bkad/CamelCaseMotion]: 
[AndrewRadev/sideways.vim]: 
[AndrewRadev/splitjoin.vim]: 
[AndrewRadev/linediff.vim]: 
[glts/vim-textobj-comment]: 
[AndrewRadev/dsf.vim]: 
[osyo-manga/vim-textobj-multiblock]: https://github.com/osyo-manga/vim-textobj-multiblock
[kana/vim-textobj-function]: 

## Custom Key-mappings

Key   | Mode | Action
----- |:----:| ------------------
`Space` | Normal | **Leader**
Arrows | Normal | Resize splits (* Enable `g:elite_mode` in `.vault.vim`)
`Backspace` | Normal | Match bracket (%)
`K` | Normal | Open Zeal or Dash on many file types (except Python+Vim script)
`Y` | Normal | Yank to the end of line (y$)
`<Return>` | Normal | Toggle fold (za)
`S`+`<Return>` | Insert | Start new line from any cursor position (\<C-o>o)
`S`+`<Return>` | Normal | Focus the current fold by closing all others
`hjkl` | Normal | Smart cursor movements (g/hjkl)
`Ctrl`+`f` | Normal | Smart page forward (C-f/C-d)
`Ctrl`+`b` | Normal | Smart page backwards (C-b/C-u)
`Ctrl`+`e` | Normal | Smart scroll down (3C-e/j)
`Ctrl`+`y` | Normal | Smart scroll up (3C-y/k)
`Ctrl`+`q` | Normal | `Ctrl`+`w`
`Ctrl`+`x` | Normal | Switch buffer and placement
`F2` | _All_ | Toggle paste mode
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
`<leader>`+`cd` | Normal | Switch to the directory of opened buffer (:cd %:p:h)
`<leader>`+`w` | Normal/visual | Write (:w)
`<leader>`+`y` | Normal | Copy file-path to X11 clipboard
`Ctrl`+`s` | _All_ | Write (:w)
`W!!` | Command | Write as root

### Editor UI

Key   | Mode | Action
----- |:----:| ------------------
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

### Window Management

Key   | Mode | Action
----- |:----:| ------------------
`q` | Normal | Smart buffer close
`s`+`p` | Normal | Split nicely
`s`+`v` | Normal | :split
`s`+`g` | Normal | :vsplit
`s`+`t` | Normal | Open new tab (:tabnew)
`s`+`o` | Normal | Close other windows (:only)
`s`+`x` | Normal | Remove buffer, leave blank window
`s`+`q` | Normal | Closes current buffer (:close)
`s`+`Q` | Normal | Removes current buffer (:bdelete)
`Tab` | Normal | Next window or tab
`Shift`+`Tab` | Normal | Previous window or tab
`<leader>`+`sv` | Normal | Split with previous buffer
`<leader>`+`sg` | Normal | Vertical split with previous buffer

### Plugin: Unite

Key   | Mode | Action
----- |:----:| ------------------
`;`+`r` | Normal | Resumes Unite window
`;`+`f` | Normal | Opens Unite file recursive search
`;`+`i` | Normal | Opens Unite git file search
`;`+`g` | Normal | Opens Unite grep with ag (the_silver_searcher)
`;`+`u` | Normal | Opens Unite source
`;`+`t` | Normal | Opens Unite tag
`;`+`T` | Normal | Opens Unite tag/include
`;`+`l` | Normal | Opens Unite location list
`;`+`q` | Normal | Opens Unite quick fix
`;`+`e` | Normal | Opens Unite register
`;`+`j` | Normal | Opens Unite jump, change
`;`+`h` | Normal | Opens Unite history/yank
`;`+`s` | Normal | Opens Unite session
`;`+`o` | Normal | Opens Unite outline
`;`+`ma` | Normal | Opens Unite mapping
`;`+`me` | Normal | Opens Unite output messages
`<leader>`+`b` | Normal | Opens Unite buffers, mru, bookmark
`<leader>`+`ta` | Normal | Opens Unite tab
`<leader>`+`gf` | Normal | Opens Unite file with word at cursor
`<leader>`+`gt` | Normal/visual | Opens Unite tag with word at cursor
`<leader>`+`gg` | Visual | Opens Unite navigate with word at cursor
| **Within _Unite_ buffers** |||
`Ctrl`+`h/k/l/r` | Normal | Un-map
`Ctrl`+`r` | Normal | Redraw
`Ctrl`+`j` | Insert | Select next line
`Ctrl`+`k` | Insert | Select previous line
`jj` | Insert | Leave Insert mode
`'` | Normal | Toggle mark current candidate, up
`e` | Normal | Run default action
`gr` | Normal | Grep with Unite on current directory
`gf` | Normal | Find files with Unite on current directory
`gd` | Normal | Change directory for all windows in current tab
`sv` | Normal | Open in a split
`sg` | Normal | Open in a vertical split
`st` | Normal | Open in a new tab
`r` | Normal | Replace ('search' profile) or rename
`Tab` | Normal | Move to other window (`Ctrl`+`w`+`w`)
`Tab` | Insert | Unite auto-completion
`Escape` | Normal | Exit unite
`Ctrl`+`z` | Normal/insert | Toggle transpose window
`Ctrl`+`w` | Insert | Delete backward path

### Plugin: VimFiler

Key   | Mode | Action
----- |:----:| ------------------
`;`+`e` | Normal | Toggle file explorer
`;`+`a` | Normal | Toggle file explorer on current file
| **Within _VimFiler_ buffers** |||
`sv` | Normal | Split edit
`sg` | Normal | Vertical split edit
`p` | Normal | Preview
`i` | Normal | Switch to directory history
`Ctrl`+`r` | Normal | Redraw
`Ctrl`+`q` | Normal | Quick look
`Ctrl`+`j` | Normal | Un-mapped
`Ctrl`+`l` | Normal | Un-mapped
`E` | Normal | Un-mapped

### Plugin: deoplete / neocomplete

Key   | Mode | Action
----- |:----:| ------------------
`Enter` | Insert | Smart snippet expansion
`Ctrl`+`space` | Insert | Autocomplete with Unite
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

### Plugin: Caw

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`v` | Normal/visual | Toggle single-line comments
`<leader>`+`V` | Normal/visual | Toggle comment block

### Plugin: Goyo and Limelight

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`G` | Normal | Toggle distraction-free writing

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
`<leader>`+`gu` | Normal | Open undo tree
`<leader>`+`i` | Normal | Toggle indentation lines
`<leader>`+`r` | Normal | Quickrun
`<leader>`+`?` | Normal | Dictionary
`<leader>`+`W` | Normal | Wiki
`<leader>`+`K` | Normal | Thesaurus

## Credits & Contribution

Big thanks to the dark knight [Shougo].

[Shougo]: https://github.com/Shougo
[lazy-loaded]: ./config/plugins.yaml
[yaml2json]: https://github.com/koraa/large-yaml2json-json2yaml
