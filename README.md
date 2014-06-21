# Vim config

This is my Vim configuration, crafted with love and care. It contains useful plugins and
a few colorschemes, awesome configurations and keybindings.

## XDG conformity

The `.vim` folder is usually placed in the home folder. However, I wanted it to conform
to the XDG standard.
Notice these topmost lines in `vimrc`:

    set runtimepath=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM,$VIMRUNTIME
    let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"

## Install

Very simple:

    git clone git://github.com/rafi/vim-config.git ~/.config/vim

Make sure you have this environment variable in your `.bashrc` or `.[bash_]profile`:

    export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

## Plugins

Name           | Description
-------------- | ----------------------
[ag] | Plugin for the_silver_searcher
[ansible-yaml] | Additional support for Ansible
[autotag] | Automatically discover and "properly" update ctags files
[css3-syntax] | CSS3 syntax support to vim's built-in `syntax/css.vim`
[csv] | Handling column separated data
[emmet] | Abbreviations expanding similar to emmet
[fugitive] | Git wrapper
[gocode] | Go bundle
[hybrid] | Dark colour scheme
[javascript] | Vastly improved Javascript indentation and syntax support
[json] | Better JSON support
[less] | Syntax for LESS
[lightline] | Light and configurable statusline/tabline
[markdown] | Markdown syntax highlighting
[mustache] | Mustache and handlebars mode
[nerdcommenter] | Intense commenting
[pathogen] | Manage your runtimepath
[phpcomplete] | Improved PHP omnicompletion
[signify] | Show a VCS diff using the sign column
[surround] | Quoting/parenthesizing made simple
[syntastic] | Syntax checking hacks
[tabular] | Text filtering and alignment
[tagbar] | Displays tags in a window, ordered by scope
[tmux-navigator] | Seamless navigation between tmux panes and vim splits
[unite] | Unite and create user interfaces
[unite-neomru] | MRU source for Unite
[unite-outline] | File "outline" source for unite
[unite-tag] | Tags source for Unite
[vimcompletesme] | Super simple, minimal and light-weight tab completion
[vimfiler] | Powerful file explorer
[vimproc] | Interactive command execution
[visual-star-search] | Start a * or # search from a visual block

[ag]: https://github.com/rking/ag.vim
[autotag]: https://github.com/craigemery/vim-autotag
[ansible-yaml]: https://github.com/chase/vim-ansible-yaml
[css3-syntax]: https://github.com/hail2u/vim-css3-syntax
[csv]: https://github.com/chrisbra/csv.vim
[emmet]: https://github.com/mattn/emmet-vim
[fugitive]: https://github.com/tpope/vim-fugitive
[gocode]: https://github.com/Blackrush/vim-gocode
[hybrid]: https://github.com/w0ng/vim-hybrid
[javascript]: https://github.com/pangloss/vim-javascript
[json]: https://github.com/elzr/vim-json
[less]: https://github.com/groenewege/vim-less
[lightline]: https://github.com/itchyny/lightline.vim
[markdown]: https://github.com/plasticboy/vim-markdown
[mustache]: https://github.com/mustache/vim-mustache-handlebars
[nerdcommenter]: https://github.com/scrooloose/nerdcommenter
[pathogen]: https://github.com/tpope/vim-pathogen
[phpcomplete]: https://github.com/shawncplus/phpcomplete.vim
[signify]: https://github.com/mhinz/vim-signify
[surround]: https://github.com/tpope/vim-surround
[syntastic]: https://github.com/scrooloose/syntastic
[tabular]: https://github.com/godlygeek/tabular
[tagbar]: https://github.com/majutsushi/tagbar
[tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[unite]: https://github.com/Shougo/unite.vim
[unite-neomru]: https://github.com/Shougo/neomru.vim
[unite-outline]: https://github.com/h1mesuke/unite-outline
[unite-tag]: https://github.com/tsukkee/unite-tag
[vimcompletesme]: https://github.com/ajh17/VimCompletesMe
[vimfiler]: https://github.com/Shougo/vimfiler.vim
[vimproc]: https://github.com/Shougo/vimproc.vim
[visual-star-search]: https://github.com/nelstrom/vim-visual-star-search

## Key bindings

Key   | Mode | Action
----- | ---- | ------------------
`Space` | Normal | **Leader**
`;` | Normal | **Command mode**
Arrows | Normal | Resize splits
`Backspace` | Normal | Match bracket (%)
`Enter` | Normal | Toggle fold (za)
`<leader>`+`y` | Normal/visual | Copy selection to X11 clipboard ("+y)
`<leader>`+`p` | Normal/visual | Paste selection from X11 clipboard ("+p)
`Ctrl`+`e` | _All_ | Scroll window downwards three lines (3<C-e>)
`Ctrl`+`y` | _All_ | Scroll window upwards three lines (3<C-y>)
`'` | Normal | Jump to mark (`)
`Q` | Normal | Format lines with motion (gq)
`S` | Normal | Insert new line above and stay in Normal mode
`Y` | Normal | Yank to the end of line (y$)
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
`W!!` | Command | Sudo write
`F2` | _All_ | Toggle paste mode
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
`f`+`r` | Normal | Resumes Unite window
`f`+`f` | Normal | Opens Unite file recursive search
`f`+`g` | Normal | Opens Unite git file search
`f`+`u` | Normal | Opens Unite source
`f`+`b` | Normal | Opens Unite buffers, mru, bookmark
`f`+`/` | Normal | Opens Unite grep with ag (the_silver_searcher)
`f`+`t` | Normal | Opens Unite tag
`f`+`R` | Normal | Opens Unite register
`f`+`j` | Normal | Opens Unite jump, change
`f`+`y` | Normal | Opens Unite history/yank
`f`+`o` | Normal | Opens Unite outline
`f`+`ma` | Normal | Opens Unite mapping
`f`+`me` | Normal | Opens Unite output messages
`F8` | Normal | Toggle Tagbar (:TagbarToggle)
`<leader>`+`t` | Normal | Toggle Tagbar (:TagbarToggle)
`F1` | Normal | Toggle file explorer
`<leader>`+`f` | Normal | Toggle file explorer
`<leader>`+`db` | Normal | Toggle file explorer in buffer directory
`<leader>`+`ds` | Normal | Toggle file explorer in split

Hope you'll enjoy!
