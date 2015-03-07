# Vim config

Lean mean Vim machine.

## Features

- Modular configuration
- NeoBundle plugin manager
- Unite centric work-flow
- Extensive Neocomplete setup
- Central location for tags
- Lightweight simple status/tabline
- Premium color-schemes

## Screenshot

![Vim screenshot](http://rafi.io/static/img/project/vim-config/features.png)

## Install

1. Clone to `~/.vim`:
```sh
git clone git://github.com/rafi/vim-config.git ~/.vim
```

2. Install plugins: `vim +NeoBundleInstall +q`
3. Run `vim`, `gvim`, or `nvim`

_Note_ that 90% of the plugins are **[lazy-loaded]**.
[lazy-loaded]: ./config/neobundle.vim

## Structure
- [colors](./colors)/ - Premium colorschemes
- [config](./config)/ - Configuration
  - [plugins](./plugins)/ - Individual plugin configurations
  - [bindings.vim](./plugins/bindings.vim) - Key bindings
  - [colors.vim](./plugins/bindings.vim) - Custom colors
  - [filetype.vim](./plugins/filetype.vim) - Language behavior
  - [general.vim](./plugins/general.vim) - VIM general configuration
  - [init.vim](./plugins/init.vim) - VIM initialization
  - [neobundle.vim](./plugins/neobundle.vim) - Plugin bundles
  - [plugins.vim](./plugins/plugins.vim) - Plugin configuration
  - [terminal.vim](./plugins/terminal.vim) - Terminal configuration
  - [utils.vim](./plugins/utils.vim) - Commands and functions
- [filetype.vim](./filetype.vim) - Exotic filetype detection
- [ftplugin](./ftplugin)/ - Language settings
- [plugin](./plugin)/ - Plugin playground
- [snippets](./snippets)/ - Code snippets
- [vimrc](./vimrc) - Primary configuration file

## Plugin Highlights

- NeoBundle with caching enabled and lazy loading
- Project-aware tabs and label
- Vimfiler as file-manager + SSH connections
- Go completion via vim-go and gocode
- Javascript completion via Tern
- PHP completion, indent, folds, syntax
- Python jedi completion, pep8 convention
- Syntaxes: Ansible, css3, csv, json, less, markdown, mustache
- Helpers: Color-picker, undo tree, bookmarks, git, tmux navigation,
    hex editor, sessions, radio stations and much more.

## XDG conformity

VIM looks for its configuration in the `~/.vim` directory. My setup **also**
supports the XDG location, `.config/vim`. If you want to use the XDG
specification standard, add this somewhere in your `.profile` or `.bashrc`:
```sh
# Set vimrc's location and source it on vim startup
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
```
If you're curious how it's done, see [vimrc:17-24](vimrc#L17-L24)
and [init.vim:42-47](./config/init.vim#L42-L47).

## Included Plugins

### Global
Name           | Description
-------------- | ----------------------
[neobundle] | Next generation package manager
[vimproc] | Interactive command execution
[hybrid] | Dark colour scheme
[file-line] | Allow opening a file in a given line
[neomru] | MRU source for Unite
[syntastic] | Syntax checking hacks
[cursorword] | Underlines word under cursor
[gitbranch] | Lightweight git branch detection
[winfix] | Fix the focus and the size of windows
[gitgutter] | Shows git diffs in the gutter
[bookmarks] | Bookmarks, works independently from vim marks
[tmux-navigator] | Seamless navigation between tmux panes and vim splits
[zoomwin] | Zoom in/out of windows
[tinyline] | Tiny great looking statusline
[tagabana] | Central location for all tags

### Language
Name           | Description
-------------- | ----------------------
[html5] | HTML5 omnicomplete and syntax
[mustache] | Mustache and handlebars mode
[markdown] | Markdown syntax highlighting
[ansible-yaml] | Additional support for Ansible
[less] | Syntax for LESS
[css3-syntax] | CSS3 syntax support to vim's built-in `syntax/css.vim`
[csv] | Handling column separated data
[pep8-indent] | Nicer Python indentation
[jedi-vim] | Python jedi autocompletion library
[go] | Go development
[json] | Better JSON support
[i3] | i3 window manager config syntax
[writing] | Highlight adjectives, weasel words and passive language
[ruby] | Ruby configuration files
[portfile] | Macports portfile configuration files
[javascript] | Enhanced Javascript syntax
[javascript-indent] | Javascript indent script
[tern] | Provides Tern-based JavaScript editing support
[php] | Up-to-date PHP syntax file
[phpfold] | PHP folding
[phpcomplete] | Improved PHP omnicompletion
[phpdoc] | PHP documenter
[phpindent] | PHP official indenting

### Commands
Name           | Description
-------------- | ----------------------
[vimfiler] | Powerful file explorer
[vinarise] | Hex editor
[fugitive] | Git wrapper
[gitv] | gitk-like interface
[gundo] | Visualize the Vim undo tree
[smartpairs] | Fantastic selection
[colorpicker] | Improved color-picker
[smalls] | Spot your cursor with simple search
[previm] | Real-time markdown/rst/textile preview
[open-browser] | Open URI with your favorite browser
[tinycomment] | Robust light-weight commenting
[phpspec] | PhpSpec integration
[prettyprint] | Pretty-print vim variables
[quickrun] | Run commands quickly
[ref] | Integrated reference viewer
[dictionary] | Dictionary.app interface
[closebuffer] | Close buffers

### Commands
Name           | Description
-------------- | ----------------------
[goyo] | Distraction-free writing
[limelight] | Hyperfocus-writing
[bufclose] | Unload buffer without closing the window
[matchit] | Intelligent pair matching
[indentline] | Display vertical indention lines
[choosewin] | Choose window to use, like tmux's 'display-pane'
[session] | Extended session management

### Completion
Name           | Description
-------------- | ----------------------
[delimitmate] | Insert mode auto-completion for quotes, parens, brackets
[echodoc] | Print objects' documentation in echo area
[smartchr] | Insert several candidates for a single key
[neocomplete] | Next generation completion framework
[neosnippet] | Contains neocomplete snippets source

### Unite
Name           | Description
-------------- | ----------------------
[unite] | Unite and create user interfaces
[unite-colorscheme] | Browse colorschemes
[unite-tig] | tig for unite
[unite-filetype] | Select file type
[unite-history] | Browse history of command/search
[unite-build] | Build with Unite interface
[unite-outline] | File "outline" source for unite
[unite-tag] | Tags source for Unite
[unite-quickfix] | Quickfix source for Unite
[neossh] | SSH interface for plugins
[unite-pull-request] | GitHub pull-request source for Unite
[junkfile] | Create temporary files for memo and testing
[unite-issue] | Issue manager for JIRA and GitHub

[neobundle]: https://github.com/Shougo/neobundle.vim
[vimproc]: https://github.com/Shougo/vimproc.vim
[hybrid]: https://github.com/w0ng/vim-hybrid
[file-line]: https://github.com/bogado/file-line
[neomru]: https://github.com/Shougo/neomru.vim
[syntastic]: https://github.com/scrooloose/syntastic
[cursorword]: https://github.com/itchyny/vim-cursorword
[gitbranch]: https://github.com/itchyny/vim-gitbranch
[winfix]: https://github.com/itchyny/vim-winfix
[gitgutter]: https://github.com/airblade/vim-gitgutter
[bookmarks]: https://github.com/MattesGroeger/vim-bookmarks
[tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[zoomwin]: https://github.com/regedarek/ZoomWin
[tinyline]: https://github.com/rafi/vim-tinyline
[tagabana]: https://github.com/rafi/vim-tagabana

[html5]: https://github.com/othree/html5.vim
[mustache]: https://github.com/mustache/vim-mustache-handlebars
[markdown]: https://github.com/rcmdnk/vim-markdown
[ansible-yaml]: https://github.com/chase/vim-ansible-yaml
[less]: https://github.com/groenewege/vim-less
[css3-syntax]: https://github.com/hail2u/vim-css3-syntax
[csv]: https://github.com/chrisbra/csv.vim
[pep8-indent]: https://github.com/hynek/vim-python-pep8-indent
[jedi-vim]: https://github.com/davidhalter/jedi-vim
[go]: https://github.com/fatih/vim-go
[json]: https://github.com/elzr/vim-json
[i3]: https://github.com/PotatoesMaster/i3-vim-syntax
[writing]: https://github.com/jamestomasino/vim-writingsyntax
[ruby]: https://github.com/vim-ruby/vim-ruby
[portfile]: http://svn.macports.org/repository/macports/contrib/mpvim

[javascript]: https://github.com/jelera/vim-javascript-syntax
[javascript-indent]: https://github.com/jiangmiao/simple-javascript-indenter
[tern]: https://github.com/marijnh/tern_for_vim

[php]: https://github.com/StanAngeloff/php.vim
[phpfold]: https://github.com/rayburgemeestre/phpfolding.vim
[phpcomplete]: https://github.com/shawncplus/phpcomplete.vim
[phpdoc]: https://github.com/tobyS/pdv
[phpindent]: https://github.com/2072/PHP-Indenting-for-VIm

[vimfiler]: https://github.com/Shougo/vimfiler.vim
[vinarise]: https://github.com/Shougo/vinarise.vim
[fugitive]: https://github.com/tpope/vim-fugitive
[gitv]: https://github.com/gregsexton/gitv
[gundo]: https://github.com/sjl/gundo.vim
[smartpairs]: https://github.com/gorkunov/smartpairs.vim
[colorpicker]: https://github.com/farseer90718/vim-colorpicker
[smalls]: https://github.com/t9md/vim-smalls
[previm]: https://github.com/kannokanno/previm
[open-browser]: https://github.com/tyru/open-browser.vim
[tinycomment]: https://github.com/rafi/vim-tinycomment
[phpspec]: https://github.com/rafi/vim-phpspec
[prettyprint]: https://github.com/thinca/vim-prettyprint
[quickrun]: https://github.com/thinca/vim-quickrun
[ref]: https://github.com/thinca/vim-ref
[dictionary]: https://github.com/itchyny/dictionary.vim
[closebuffer]: https://github.com/itchyny/vim-closebuffer

[goyo]: https://github.com/junegunn/goyo.vim
[limelight]: https://github.com/junegunn/limelight.vim
[bufclose]: https://github.com/vim-scripts/BufClose.vim
[matchit]: http://www.vim.org/scripts/script.php?script_id=39
[indentline]: https://github.com/Yggdroot/indentLine
[choosewin]: https://github.com/t9md/vim-choosewin
[session]: https://github.com/xolox/vim-session

[delimitmate]: https://github.com/Raimondi/delimitMate
[echodoc]: https://github.com/Shougo/echodoc.vim
[smartchr]: https://github.com/kana/vim-smartchr
[neocomplete]: https://github.com/Shougo/neocomplete.vim
[neosnippet]: https://github.com/Shougo/neosnippet.vim

[unite]: https://github.com/Shougo/unite.vim
[unite-colorscheme]: https://github.com/ujihisa/unite-colorscheme
[unite-tig]: https://github.com/Kocha/vim-unite-tig
[unite-filetype]: https://github.com/osyo-manga/unite-filetype
[unite-history]: https://github.com/thinca/vim-unite-history
[unite-build]: https://github.com/Shougo/unite-build
[unite-outline]: https://github.com/h1mesuke/unite-outline
[unite-tag]: https://github.com/tsukkee/unite-tag
[unite-quickfix]: https://github.com/osyo-manga/unite-quickfix
[neossh]: https://github.com/Shougo/neossh.vim
[unite-pull-request]: https://github.com/joker1007/unite-pull-request
[junkfile]: https://github.com/Shougo/junkfile.vim
[unite-issue]: https://github.com/rafi/vim-unite-issue

## Custom Key bindings

Key   | Mode | Action
----- |:----:| ------------------
`Space` | Normal | **Leader**
`\` | Normal | **Local Leader**
`;` | Normal | **Command mode**
Arrows | Normal | Resize splits (* Enable `g:elite_mode` in `.vault.vim`)
`Backspace` | Normal | Match bracket (%)
`K` | Normal | Open Zeal or Dash on many filetypes (not in vim and python)
`<leader>`+`y` | Normal/visual | Copy selection to X11 clipboard ("+y)
`<leader>`+`p` | Normal/visual | Paste selection from X11 clipboard ("+p)
`'` | Normal | Jump to mark (`)
`\`` | Normal | Jump to mark (')
`Y` | Normal | Yank to the end of line (y$)
`Enter` | Normal | Toggle fold (za)
`hjkl` | Normal | Smart cursor movements (g/hjkl)
`Ctrl`+`f` | Normal | Smart page forward (C-f/C-d)
`Ctrl`+`b` | Normal | Smart page backwards (C-b/C-u)
`Ctrl`+`e` | Normal | Smart scroll down (3C-e/j)
`Ctrl`+`y` | Normal | Smart scroll up (3C-y/k)
`Ctrl`+`x` | Normal | Switch buffer and placement
`Ctrl`+`q` | Normal | `Ctrl`+`w`
`+` | Normal | Increment (C-a)
`-` | Normal | Decrement (C-x)
`}` | Normal | After paragraph motion go to first non-blank char (}^)
`<` | Visual | Indent to left and re-select (<gv)
`>` | Visual | Indent to right and re-select (>gv|)
`Tab` | Normal | Indent to right (>>_)
`Shift`+`Tab` | Normal | Indent to left (<<_)
`Tab` | Visual | Indent to right and re-select (>gv)
`Shift`+`Tab` | Normal | Indent to left and re-select (<gv)
`gp` | Normal | Select last paste
`Q`/`gQ` | Normal | Disable EX-mode (<Nop>)
`Escape` | Visual | Go to starting position after visual mode
`Ctrl`+`a` | Command | Navigation in command line
`Ctrl`+`f` | Command | Move cursor forward in command line
`Ctrl`+`b` | Command | Move cursor backward in command line
`Ctrl`+`g` | Command | C-g in command line
`Escape` | Select | Escape from select mode (C-c)
`<leader>`+`cd` | Normal | Switch to the directory of opened buffer (:cd %:p:h)
`<leader>`+`w` | Normal/visual | Write (:w)
`Ctrl`+`s` | _All_ | Write (:w)
`W!!` | Command | Write as root
`F2` | _All_ | Toggle paste mode
`F3` | Normal | Show highlight group that matches current cursor
`<leader>`+`ts` | Normal | Toggle spell-checker (:setlocal spell!)
`<leader>`+`tn` | Normal | Toggle line numbers (:setlocal nonumber!)
`<leader>`+`tl` | Normal | Toggle hidden characters (:setlocal nolist!)
`<leader>`+`th` | Normal | Toggle highlighted search (:set hlsearch!)
`<leader>`+`st` | Normal | Open new tab (:tabnew)
`Ctrl`+`t` | Normal/Insert | Open new tab (:tabnew)
`g0` | Normal | Go to first tab (:tabfirst)
`g$` | Normal | Go to last tab (:tablast)
`Ctrl`+`Tab` | Normal | Switch to next tab (:tabn)
`Ctrl`+`Shift`+`Tab` | Normal | Switch to previous tab (:tabp)
`Ctrl`+`Space` | Normal | Show tags (C-t)
`<leader>`+`sv` | Normal | Split (:sp)
`<leader>`+`sg` | Normal | Vertical split (:vsp)
`Shift`+`Right` | _All_ | Switch to next buffer (:bnext)
`Shift`+`Left` | _All_ | Switch to previous buffer (:bprev)
`Ctrl`+`j` | Normal | Move to split below (<C-w>j)
`Ctrl`+`k` | Normal | Move to upper split (<C-w>k)
`Ctrl`+`h` | Normal | Move to left split (<C-w>h)
`Ctrl`+`l` | Normal | Move to right split (<C-w>l)
`<leader>`+`q` | Normal | Closes current buffer (:close)
`<leader>`+`x` | Normal | Removes current buffer (:bdelete)
`<leader>`+`z` | Normal | Executes :BufClose
`,`+`Space` | Normal | Remove all spaces at EOL
`,`+`d` | Normal | Toggle diff
`Escape`+`Escape` | Normal | Clear search and disable paste
`*` | Visual | Search selection forwards
`#` | Visual | Search selection backwards
`Ctrl`+`r` | Visual | Replace selection
`<leader>`+`lj` | Normal | Next on location list
`<leader>`+`lk` | Normal | Previous on location list
`<leader>`+`S` | Normal/visual | Source selection
`<leader>`+`ml` | Normal | Append modeline
`f`+`z` | Normal | Focus the current fold by closing all others (mzzM`zzv)
`f`+`y` | Normal | Yank filepath to X11 clipboard
| **Within _quickfix_ and _diff_** |||
`q` | Normal | Quit buffer

### Plugin: Unite

Key   | Mode | Action
----- |:----:| ------------------
`f`+`r` | Normal | Resumes Unite window
`f`+`f` | Normal | Opens Unite file recursive search
`f`+`i` | Normal | Opens Unite git file search
`f`+`g` | Normal | Opens Unite grep with ag (the_silver_searcher)
`f`+`u` | Normal | Opens Unite source
`f`+`t` | Normal | Opens Unite tag
`f`+`T` | Normal | Opens Unite tag/include
`f`+`l` | Normal | Opens Unite location list
`f`+`q` | Normal | Opens Unite quick fix
`f`+`e` | Normal | Opens Unite register
`f`+`j` | Normal | Opens Unite jump, change
`f`+`h` | Normal | Opens Unite history/yank
`f`+`s` | Normal | Opens Unite session
`f`+`o` | Normal | Opens Unite outline
`f`+`ma` | Normal | Opens Unite mapping
`f`+`me` | Normal | Opens Unite output messages
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
`'` | Normal | Toggle mark current candidate, up
`e` | Normal | Run default action
`Ctrl`+`v` | Normal | Open in a split
`Ctrl`+`s` | Normal | Open in a vertical split
`Ctrl`+`t` | Normal | Open in a new tab
`Tab` | Normal | `Ctrl`+`w`+`w`
`Escape` | Normal | Exit unite
`jj` | Insert | Leave Insert mode
`r` | Normal | Replace ('search' profile) or rename
`Tab` | Insert | Unite autocompletion
`Ctrl`+`z` | Normal/insert | Toggle transpose window
`Ctrl`+`w` | Insert | Delete backward path

### Plugin: VimFiler

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`f` | Normal | Toggle file explorer
`<leader>`+`fa` | Normal | Toggle file explorer on current file
| **Within _VimFiler_ buffers** |||
`Ctrl`+`j` | Normal | Un-map
`Ctrl`+`l` | Normal | Un-map
`E` | Normal | Un-map
`sv` | Normal | Split edit
`sg` | Normal | Vertical split edit
`p` | Normal | Preview
`i` | Normal | Switch to directory history
`Ctrl`+`r` | Normal | Redraw
`Ctrl`+`q` | Normal | Quick look

### Plugin: neocomplete

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

### Plugin: TinyComment

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
`m`+`m` | Normal | Bookmark current line
`m`+`n` | Normal | Jump to next bookmark
`m`+`p` | Normal | Jump to previous bookmark

### Plugin: Fugitive

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`ga` | Normal | Git add current file
`<leader>`+`gs` | Normal | Git status
`<leader>`+`gd` | Normal | Git diff
`<leader>`+`gD` | Normal | Close diff
`<leader>`+`gc` | Normal | Git commit
`<leader>`+`gb` | Normal | Git blame
`<leader>`+`gp` | Normal | Git push
`<leader>`+`gB` | Normal | Open in browser
`<leader>`+`gbd` | Normal | Open branch in browser

### Plugin: Gitgutter

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`hj` | Normal | Jump to next hunk
`<leader>`+`hk` | Normal | Jump to previous hunk
`<leader>`+`ha` | Normal | Stage hunk
`<leader>`+`hu` | Normal | Revert hunk
`<leader>`+`hp` | Normal | Preview hunk

### Misc Plugins

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`gl` | Normal | Gitv
`<leader>`+`gu` | Normal | Gundo
`<leader>`+`i` | Normal | Toggle indentLine
`<leader>`+`co` | Normal | Colorpicker
`<leader>`+`r` | Normal | Quickrun
`<leader>`+`?` | Normal | Dictionary
`Ctrl`+`w` | Normal/Insert | Closebuffer

## Xterm and Tmux

- Make Ctrl+Tab work in console, add these lines to your .Xresources:
	```
	! Make Ctrl+Tab work nicely with Vim
	URxvt*keysym.C-Tab:            \033[27;5;9~
	URxvt*keysym.C-S-Tab:          \033[27;6;9~
	URxvt*keysym.C-S-ISO_Left_Tab: \033[27;6;9~

	URxvt.keysym.C-Up:     \033[1;5A
	URxvt.keysym.C-Down:   \033[1;5B
	URxvt.keysym.C-Left:   \033[1;5D
	URxvt.keysym.C-Right:  \033[1;5C
	```
- Cursor: Blinking underscore in Insert mode, blinking block otherwise

## Enjoy!
