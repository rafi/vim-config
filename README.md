# Vim config

This is my Vim configuration, crafted with love and care. It contains useful plugins and
a few colorschemes, awesome configurations and keybindings.

## Screenshot

![Vim screenshot](https://paste.xinu.at/P4km/ "Ain't that a beauty?")

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
3. When NeoBundle shows prompt, accept plugins installation

## Included Plugins

Name           | Description
-------------- | ----------------------
[ansible-yaml] | Additional support for Ansible
[bookmarks] | Bookmarks, works independently from vim marks
[choosewin] | Choose window to use, like tmux's 'display-pane'
[colorpicker] | Improved color-picker
[css3-syntax] | CSS3 syntax support to vim's built-in `syntax/css.vim`
[csv] | Handling column separated data
[delimitmate] | Insert mode auto-completion for quotes, parens, brackets
[emmet] | Abbreviations expanding similar to emmet
[file-line] | Allow opening a file in a given line
[fugitive] | Git wrapper
[gitv] | gitk-like interface
[go] | Go development
[gundo] | Visualize the Vim undo tree
[hybrid] | Dark colour scheme
[javascript] | Vastly improved Javascript indentation and syntax support
[json] | Better JSON support
[less] | Syntax for LESS
[markdown] | Markdown syntax highlighting
[mustache] | Mustache and handlebars mode
[neocomplete] | Next generation completion framework
[neosnippet] | Contains neocomplete snippets source
[neossh] | SSH interface for plugins
[nerdcommenter] | Intense commenting
[pathogen] | Manage your runtimepath
[php] | Up-to-date PHP syntax file
[phpcomplete] | Improved PHP omnicompletion
[signify] | Show a VCS diff using the sign column
[surround] | Quoting/parenthesizing made simple
[syntastic] | Syntax checking hacks
[tabular] | Text filtering and alignment
[tagbar] | Displays tags in a window, ordered by scope
[tern] | Provides Tern-based JavaScript editing support
[tinyline] | Tiny great looking statusline
[tmux-navigator] | Seamless navigation between tmux panes and vim splits
[unite] | Unite and create user interfaces
[unite-neomru] | MRU source for Unite
[unite-outline] | File "outline" source for unite
[unite-quickfix] | Quickfix source for Unite
[unite-session] | Session source for Unite
[unite-tag] | Tags source for Unite
[vimfiler] | Powerful file explorer
[vimproc] | Interactive command execution

[ansible-yaml]: https://github.com/chase/vim-ansible-yaml
[bookmarks]: https://github.com/MattesGroeger/vim-bookmarks
[choosewin]: https://github.com/t9md/vim-choosewin
[colorpicker]: https://github.com/farseer90718/vim-colorpicker
[css3-syntax]: https://github.com/hail2u/vim-css3-syntax
[csv]: https://github.com/chrisbra/csv.vim
[delimitmate]: https://github.com/Raimondi/delimitMate
[emmet]: https://github.com/mattn/emmet-vim
[file-line]: https://github.com/bogado/file-line
[fugitive]: https://github.com/tpope/vim-fugitive
[gitv]: https://github.com/gregsexton/gitv
[go]: https://github.com/fatih/vim-go
[gundo]: https://github.com/sjl/gundo.vim
[hybrid]: https://github.com/w0ng/vim-hybrid
[javascript]: https://github.com/pangloss/vim-javascript
[json]: https://github.com/elzr/vim-json
[less]: https://github.com/groenewege/vim-less
[markdown]: https://github.com/plasticboy/vim-markdown
[mustache]: https://github.com/mustache/vim-mustache-handlebars
[neocomplete]: https://github.com/Shougo/neocomplete.vim
[neosnippet]: https://github.com/Shougo/neosnippet.vim
[neossh]: https://github.com/Shougo/neossh.vim
[nerdcommenter]: https://github.com/scrooloose/nerdcommenter
[pathogen]: https://github.com/tpope/vim-pathogen
[php]: https://github.com/StanAngeloff/php.vim
[phpcomplete]: https://github.com/shawncplus/phpcomplete.vim
[signify]: https://github.com/mhinz/vim-signify
[surround]: https://github.com/tpope/vim-surround
[syntastic]: https://github.com/scrooloose/syntastic
[tabular]: https://github.com/godlygeek/tabular
[tagbar]: https://github.com/majutsushi/tagbar
[tern]: https://github.com/marijnh/tern_for_vim
[tinyline]: https://github.com/rafi/vim-tinyline
[tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[unite]: https://github.com/Shougo/unite.vim
[unite-neomru]: https://github.com/Shougo/neomru.vim
[unite-outline]: https://github.com/h1mesuke/unite-outline
[unite-quickfix]: https://github.com/osyo-manga/unite-quickfix
[unite-session]: https://github.com/Shougo/unite-session
[unite-tag]: https://github.com/tsukkee/unite-tag
[vimfiler]: https://github.com/Shougo/vimfiler.vim
[vimproc]: https://github.com/Shougo/vimproc.vim

## Custom Key bindings

Key   | Mode | Action
----- |:----:| ------------------
`Space` | Normal | **Leader**
`;` | Normal | **Command mode**
`F1` | Normal/visual | **Disabled**, used by [Zeal](http://zealdocs.org)
Arrows | Normal | Resize splits
`Backspace` | Normal | Match bracket (%)
`<leader>`+`y` | Normal/visual | Copy selection to X11 clipboard ("+y)
`<leader>`+`p` | Normal/visual | Paste selection from X11 clipboard ("+p)
`Ctrl`+`e` | _All_ | Scroll window downwards three lines (3<C-e>)
`Ctrl`+`y` | _All_ | Scroll window upwards three lines (3<C-y>)
`'` | Normal | Jump to mark (`)
`Q` | Normal | Format lines with motion (gq)
`S` | Normal | Insert new line above and stay in Normal mode
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
`Ctrl`+`s` | Normal/visual/insert | Write (:w)
`W!!` | Command | Write as root
`F2` | _All_ | Toggle paste mode
`F10` | Normal | Show highlight names under cursor
`<leader>`+`l` | Normal | Toggle line numbers (:set nonumber!)
`<leader>`+`s` | Normal | Toggle hidden characters (:set nolist!)
`<leader>`+`h` | Normal | Clear highlighted search (:set nohlsearch)
`<leader>`+`ss` | Normal | Toggle spell-checker (:setlocal spell!)
`Ctrl`+`t` | Normal | New tab (:tabnew)
`Ctrl`+`x` | Normal | Close tab (:tabclose)
`Ctrl`+`Tab` | Normal | Switch to next tab (:tabn)
`Ctrl`+`Shift`+`Tab` | Normal | Switch to previous tab (:tabn)
`<leader>`+`sv` | Normal | Split (:sp)
`<leader>`+`sg` | Normal | Vertical split (:vsp)
`Ctrl`+`j` | Normal | Move to split below (<C-w>j)
`Ctrl`+`k` | Normal | Move to upper split (<C-w>k)
`Ctrl`+`h` | Normal | Move to left split (<C-w>h)
`Ctrl`+`l` | Normal | Move to right split (<C-w>l)
`Shift`+`Right` | _All_ | Switch to next buffer (:bnext)
`Shift`+`Left` | _All_ | Switch to previous buffer (:bprev)
`<leader>`+`q` | Normal | Closes current buffer (:close)
`<leader>`+`x` | Normal | Removes current buffer (:bdelete)
`<leader>`+`ml` | Normal | Append modeline
`<leader>`+`ef` | Normal | Focus the current fold by closing all others (mzzM`zzv)
`<leader>`+`cy` | Normal | Yank filepath to X11 clipboard
| **Within _quickfix_** |||
`Escape` | Normal | Buffer delete
`q` | Normal | Buffer delete

### Plugin: NERDCommenter

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`ci` | Normal | Invert comments (:NERDCommenterInvert)
`<leader>`+`cc` | Normal | Invert comments (:NERDCommenterComment)

### Plugin: Unite

Key   | Mode | Action
----- |:----:| ------------------
`f`+`r` | Normal | Resumes Unite window
`f`+`f` | Normal | Opens Unite file recursive search
`f`+`i` | Normal | Opens Unite git file search
`f`+`g` | Normal | Opens Unite grep with ag (the_silver_searcher)
`f`+`u` | Normal | Opens Unite source
`f`+`t` | Normal | Opens Unite tag
`f`+`e` | Normal | Opens Unite register
`f`+`j` | Normal | Opens Unite jump, change
`f`+`h` | Normal | Opens Unite history/yank
`f`+`o` | Normal | Opens Unite outline
`f`+`ma` | Normal | Opens Unite mapping
`f`+`me` | Normal | Opens Unite output messages
`<leader>`+`b` | Normal | Opens Unite buffers, mru, bookmark
`<leader>`+`t` | Normal | Opens Unite tab
| **Within _Unite_** |||
`Ctrl`+`j` | Normal | Un-map
`Ctrl`+`k` | Normal | Un-map
`Ctrl`+`h` | Normal | Un-map
`Ctrl`+`l` | Normal | Un-map
`Ctrl`+`r` | Normal | Redraw
`Ctrl`+`j` | Insert | Select next line
`Ctrl`+`k` | Insert | Select previous line
`'` | Normal | Toggle mark current candidate, up
`;` | Normal | Enter Insert mode
`e` | Normal | Run default action
`Ctrl`+`v` | Normal | Open in a split
`Ctrl`+`s` | Normal | Open in a vertical split
`Ctrl`+`t` | Normal | Open in a new tab
`Escape` | Normal | Exit unite
`jj` or `kk` | Insert | Leave Insert mode
`r` | Normal | Replace ('search' profile) or rename

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

### Plugin: Tagbar

Key   | Mode | Action
----- |:----:| ------------------
`F8` | Normal | Toggle Tagbar (:TagbarToggle)

### Plugin: VimFiler

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`f` | Normal | Toggle file explorer
`<leader>`+`db` | Normal | Toggle file explorer in buffer directory
`<leader>`+`ds` | Normal | Toggle file explorer in split
| **Within _VimFiler_** |||
`Ctrl`+`j` | Normal | Un-map
`Ctrl`+`l` | Normal | Un-map
`Ctrl`+`r` | Normal | Redraw
`'` | Normal | Toggle mark current line
`Ctrl`+`q` | Normal | Quick look
`Ctrl`+`w` | Normal | Switch to history

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

### Plugin: Syntastic

Key   | Mode | Action
----- |:----:| ------------------
`<leader>`+`lj` | Normal | Display the next error in list
`<leader>`+`lk` | Normal | Display the previous error in list

### gvim only

Key   | Mode | Action
----- |:----:| ------------------
`Ctrl`+`F1` | Normal | Toggle display of menu
`Ctrl`+`F2` | Normal | Toggle display of toolbar
`Ctrl`+`F3` | Normal | Toggle display of scrollbar

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
