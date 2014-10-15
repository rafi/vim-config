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

![Vim screenshot](https://paste.xinu.at/vMvoE/ "Ain't that a beauty?")

## XDG conformity

Vim's folder is usually placed at `~/.vim`. However, I wanted it to conform
to the XDG specification standard and place it at `.config/vim`. Both locations
are supported.

## Install

1. Clone to `~/.vim` or `~/.config/vim` recursively (pull submodules):
  ```sh
  git clone --recursive git://github.com/rafi/vim-config.git ~/.vim
  ```

2. Run `vim`, `gvim`, or `nvim`
3. When NeoBundle shows prompt, accept plugins installation. This might take a
   while, but only performed once. 90% of the plugins are lazy-loaded.

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
- Syntaxes: Ansible, css3, csv, json, less, markdown, mustache
- Helpers: Color-picker, undo tree, bookmarks, git, tmux navigation,
    hex editor, sessions, radio stations and much more.

## Included Plugins

### Global
Name           | Description
-------------- | ----------------------
[neobundle] | Next generation package manager
[vimproc] | Interactive command execution
[neomru] | MRU source for Unite
[gitgutter] | Shows git diffs in the gutter
[syntastic] | Syntax checking hacks
[file-line] | Allow opening a file in a given line
[bookmarks] | Bookmarks, works independently from vim marks
[hybrid] | Dark colour scheme
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
[go] | Go development
[json] | Better JSON support
[javascript] | Vastly improved Javascript indentation and syntax support
[tern] | Provides Tern-based JavaScript editing support
[php] | Up-to-date PHP syntax file
[phpcomplete] | Improved PHP omnicompletion
[phpdoc] | PHP documenter
[phpfold] | PHP folding
[phpindent] | PHP official indenting
[writing] | Highlight adjectives, weasel words and passive language

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

### Commands
Name           | Description
-------------- | ----------------------
[goyo] | Distraction-free writing
[limelight] | Hyperfocus-writing
[bufclose] | Unload buffer without closing the window
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
[neossh] | SSH interface for plugins
[unite-build] | Build with Unite interface
[unite-colorscheme] | Browse colorschemes
[unite-issue] | Issue manager for JIRA and GitHub
[unite-outline] | File "outline" source for unite
[unite-quickfix] | Quickfix source for Unite
[unite-tag] | Tags source for Unite
[unite-pull-request] | GitHub pull-request source for Unite
[unite-stackoverflow] | Browse stackoverflow answers

[neobundle]: https://github.com/Shougo/neobundle.vim
[vimproc]: https://github.com/Shougo/vimproc.vim
[neomru]: https://github.com/Shougo/neomru.vim
[gitgutter]: https://github.com/airblade/vim-gitgutter
[syntastic]: https://github.com/scrooloose/syntastic
[file-line]: https://github.com/bogado/file-line
[bookmarks]: https://github.com/MattesGroeger/vim-bookmarks
[hybrid]: https://github.com/w0ng/vim-hybrid
[tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[zoomwin]: https://github.com/regedarek/ZoomWin
[tinyline]: https://github.com/rafi/vim-tinyline
[tagabana]: https://github.com/rafi/vim-tagabana

[html5]: https://github.com/othree/html5.vim
[mustache]: https://github.com/mustache/vim-mustache-handlebars
[markdown]: https://github.com/plasticboy/vim-markdown
[ansible-yaml]: https://github.com/chase/vim-ansible-yaml
[less]: https://github.com/groenewege/vim-less
[css3-syntax]: https://github.com/hail2u/vim-css3-syntax
[csv]: https://github.com/chrisbra/csv.vim
[go]: https://github.com/fatih/vim-go
[json]: https://github.com/elzr/vim-json
[javascript]: https://github.com/pangloss/vim-javascript
[tern]: https://github.com/marijnh/tern_for_vim
[php]: https://github.com/StanAngeloff/php.vim
[phpcomplete]: https://github.com/shawncplus/phpcomplete.vim
[phpdoc]: https://github.com/tobyS/pdv
[phpfold]: https://github.com/rayburgemeestre/phpfolding.vim
[phpindent]: https://github.com/2072/PHP-Indenting-for-VIm
[writing]: https://github.com/jamestomasino/vim-writingsyntax

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

[goyo]: https://github.com/junegunn/goyo.vim
[limelight]: https://github.com/junegunn/limelight.vim
[bufclose]: https://github.com/vim-scripts/BufClose.vim
[choosewin]: https://github.com/t9md/vim-choosewin
[session]: https://github.com/xolox/vim-session

[delimitmate]: https://github.com/Raimondi/delimitMate
[echodoc]: https://github.com/Shougo/echodoc.vim
[smartchr]: https://github.com/kana/vim-smartchr
[neocomplete]: https://github.com/Shougo/neocomplete.vim
[neosnippet]: https://github.com/Shougo/neosnippet.vim

[unite]: https://github.com/Shougo/unite.vim
[neossh]: https://github.com/Shougo/neossh.vim
[unite-build]: https://github.com/Shougo/unite-build
[unite-colorscheme]: https://github.com/ujihisa/unite-colorscheme
[unite-issue]: https://github.com/rafi/vim-unite-issue
[unite-outline]: https://github.com/h1mesuke/unite-outline
[unite-quickfix]: https://github.com/osyo-manga/unite-quickfix
[unite-tag]: https://github.com/tsukkee/unite-tag
[unite-pull-request]: https://github.com/joker1007/unite-pull-request
[unite-stackoverflow]: https://github.com/rhysd/unite-stackoverflow.vim

## Custom Key bindings

Key   | Mode | Action
----- |:----:| ------------------
`Space` | Normal | **Leader**
`;` | Normal | **Command mode**
Arrows | Normal | Resize splits
`Backspace` | Normal | Match bracket (%)
`<leader>`+`y` | Normal/visual | Copy selection to X11 clipboard ("+y)
`<leader>`+`p` | Normal/visual | Paste selection from X11 clipboard ("+p)
`Ctrl`+`e` | _All_ | Scroll window downwards three lines (3<C-e>)
`Ctrl`+`y` | _All_ | Scroll window upwards three lines (3<C-y>)
`'` | Normal | Jump to mark (`)
`Q` | Normal | Format lines with motion (gq)
`Y` | Normal | Yank to the end of line (y$)
`Enter` | Normal | Toggle fold (za)
`>` | Visual | Indent to right and re-select (>gv)
`<` | Visual | Indent to left and re-select (<gv)
`Tab` | Normal | Indent to right (>>_)
`Shift`+`Tab` | Normal | Indent to left (<<_)
`Tab` | Visual | Indent to right and re-select (>gv)
`Shift`+`Tab` | Normal | Indent to left and re-select (<gv)
`<leader>`+`cd` | Normal | Switch to the directory of opened buffer (:cd %:p:h)
`<leader>`+`ev` | Normal | Load vimrc file (:e $MYVIMRC)
`<leader>`+`es` | Normal | Source vimrc file (:so $MYVIMRC)
`<leader>`+`w` | Normal/visual | Write (:w)
`W!!` | Command | Write as root
`F2` | _All_ | Toggle paste mode
`F3` | _All_ | Show highlight group that matches current cursor
`F10` | Normal | Show highlight names under cursor
`<leader>`+`ts` | Normal | Toggle spell-checker (:setlocal spell!)
`<leader>`+`tn` | Normal | Toggle line numbers (:set nonumber!)
`<leader>`+`tl` | Normal | Toggle hidden characters (:set nolist!)
`<leader>`+`th` | Normal | Clear highlighted search (:set nohlsearch)
`<leader>`+`st` | Normal | New tab (:tabnew)
`Ctrl`+`x` | Normal | Close tab (:tabclose)
`Ctrl`+`Tab` | Normal | Switch to next tab (:tabn)
`Ctrl`+`Shift`+`Tab` | Normal | Switch to previous tab (:tabn)
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
`*` | Visual | Search selection forwards
`#` | Visual | Search selection backwards
`Ctrl`+`r` | Visual | Replace selection
`<leader>`+`lj` | Normal | Next on location list
`<leader>`+`lk` | Normal | Previous on location list
`<leader>`+`S` | Normal/visual | Source selection
`<leader>`+`ml` | Normal | Append modeline
`f`+`z` | Normal | Focus the current fold by closing all others (mzzM`zzv)
`f`+`y` | Normal | Yank filepath to X11 clipboard
| **Within _quickfix_ or _diff_** |||
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
| **Within _Unite_** |||
`Ctrl`+`j` | Normal | Un-map
`Ctrl`+`k` | Normal | Un-map
`Ctrl`+`h` | Normal | Un-map
`Ctrl`+`l` | Normal | Un-map
`Ctrl`+`r` | Normal | Redraw
`Ctrl`+`j` | Insert | Select next line
`Ctrl`+`k` | Insert | Select previous line
`'` | Normal | Toggle mark current candidate, up
`e` | Normal | Run default action
`Ctrl`+`v` | Normal | Open in a split
`Ctrl`+`s` | Normal | Open in a vertical split
`Ctrl`+`t` | Normal | Open in a new tab
`Escape` | Normal | Exit unite
`jj` | Insert | Leave Insert mode
`r` | Normal | Replace ('search' profile) or rename

### Plugin: VimFiler

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`f` | Normal | Toggle file explorer
`<leader>`+`db` | Normal | Toggle file explorer in buffer directory
`<leader>`+`ds` | Normal | Toggle file explorer in split
| **Within _VimFiler_** |||
`Ctrl`+`j` | Normal | Un-map
`Ctrl`+`l` | Normal | Un-map
`E` | Normal | Un-map
`s` | Normal | Split edit
`p` | Normal | Preview
`A` | Normal | Rename
`'` | Normal | Toggle mark current line
`Ctrl`+`r` | Normal | Redraw
`Ctrl`+`q` | Normal | Quick look
`Ctrl`+`w` | Normal | Switch to directory history

### Plugin: neocomplete

Key   | Mode | Action
----- |:----:| ------------------
`Ctrl`+`g` | Insert | Undo completion
`Ctrl`+`l` | Insert | Complete common string
`Enter` | Insert | Close pop-up
`Tab` | Insert | Completion (C-n or Tab)
`Ctrl`+`h` | Insert | Close pop-up smartly
`Backspace` | Insert | Close pop-up smartly
`Ctrl`+`y` | Insert | Close pop-up
`Ctrl`+`e` | Insert | Close pop-up

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
`<leader>`+`gc` | Normal | Git commit
`<leader>`+`gb` | Normal | Git blame
`<leader>`+`gl` | Normal | Git log
`<leader>`+`gp` | Normal | Git push
`<leader>`+`gg` | Normal | Git grep
`<leader>`+`gB` | Normal | Open in browser
`<leader>`+`gbd` | Normal | Open branch in browser

### Plugin: Syntastic

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`lj` | Normal | Display the next error in list
`<leader>`+`lk` | Normal | Display the previous error in list

## URXvt Hacks

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
