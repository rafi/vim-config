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
[css3-syntax] | CSS3 syntax support to vim's built-in `syntax/css.vim`
[csv] | Handling column separated data
[ctrlp] | Fuzzy file, buffer, mru, tag, etc finder
[easymotion] | Motions on speed
[fugitive] | Git wrapper
[gitgutter] | Shows a git diff in the gutter and stages/reverts hunks
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
[surround] | Quoting/parenthesizing made simple
[syntastic] | Syntax checking hacks
[tabular] | Text filtering and alignment
[tagbar] | Displays tags in a window, ordered by scope
[tmux-navigator] | Seamless navigation between tmux panes and vim splits
[unite] | Unite and create user interfaces
[vimcompletesme] | Super simple, minimal and light-weight tab completion
[vimfiler] | Powerful file explorer
[visual-star-search] | Start a * or # search from a visual block

[ag]: https://github.com/rking/ag.vim
[ansible-yaml]: https://github.com/chase/vim-ansible-yaml
[css3-syntax]: https://github.com/hail2u/vim-css3-syntax
[csv]: https://github.com/chrisbra/csv.vim
[ctrlp]: https://github.com/kien/ctrlp.vim
[easymotion]: https://github.com/vim-scripts/AutoComplPop
[fugitive]: https://github.com/tpope/vim-fugitive
[gitgutter]: https://github.com/airblade/vim-gitgutter
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
[surround]: https://github.com/tpope/vim-surround
[syntastic]: https://github.com/scrooloose/syntastic
[tabular]: https://github.com/godlygeek/tabular
[tagbar]: https://github.com/majutsushi/tagbar
[tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[unite]: https://github.com/Shougo/unite.vim
[vimcompletesme]: https://github.com/ajh17/VimCompletesMe
[vimfiler]: https://github.com/Shougo/vimfiler.vim
[visual-star-search]: https://github.com/nelstrom/vim-visual-star-search

## Key bindings

Key   | Mode | Action
----- | ---- | ------------------
`Space` | Normal | **Leader**
`;` | Normal | **Command mode**
Arrows | Normal | Resize splits
`Backspace` | Normal | Match bracket (%)
`'` | Normal | Jump to mark (`)
`Q` | Normal | Format lines with motion (gq)
`S` | Normal | Insert new line above and stay in Normal mode
`Y` | Normal | Yank to the end of line (y$)
`Enter` | Normal | Toggle fold (za)
`W!!` | Command | Sudo write
`<leader>`+`sv` | Normal | Split (:sp)
`<leader>`+`sg` | Normal | Vertical split (:vsp)
`Ctrl`+`j` | Normal | Move to split below (<C-w>j)
`Ctrl`+`k` | Normal | Move to upper split (<C-w>k)
`Ctrl`+`h` | Normal | Move to left split (<C-w>h)
`Ctrl`+`l` | Normal | Move to right split (<C-w>l)
`<leader>`+`w` | Normal/visual | Write (:w)
`Ctrl`+`s` | Normal/visual/insert | Write (:w)
`>` | Visual | Indent to right and re-select (>gv)
`<` | Visual | Indent to left and re-select (<gv)
`Tab` | Normal | Indent to right (>>_)
`Shift`+`Tab` | Normal | Indent to left (<<_)
`Tab` | Visual | Indent to right and re-select (>gv)
`Shift`+`Tab` | Normal | Indent to left and re-select (<gv)
`<leader>`+`l` | Normal | Toggle line numbers (:set nonumber!)
`<leader>`+`hh` | Normal | Clear highlighted search (:set nohlsearch)
`<leader>`+`s` | Normal | Toggle hidden characters (:set nolist!)
`Ctrl`+`e` | _All_ | Scroll window downwards three lines (3<C-e>)
`Ctrl`+`y` | _All_ | Scroll window upwards three lines (3<C-y>)
`<leader>`+`y` | Normal/visual | Copy selection to X11 clipboard ("+y)
`<leader>`+`p` | Normal/visual | Paste selection from X11 clipboard ("+p)
`F8` | Normal | Toggle Tagbar (:TagbarToggle)
`<leader>`+`t` | Normal | Toggle Tagbar (:TagbarToggle)
`<leader>`+`cd` | Normal | Switch to the directory of opened buffer (:cd %:p:h)
`<leader>`+`flf` | Normal | Focus the current fold by closing all others (mzzM`zzv)
`<leader>`+`ev` | Normal | Load vimrc file (:e $MYVIMRC)
`<leader>`+`es` | Normal | Source vimrc file (:so $MYVIMRC)
`F1` | Normal | Toggle file explorer
`<leader>`+`f` | Normal | Toggle file explorer
`<leader>`+`b` | Normal | Opens Unite buffers
`F2` | _All_ | Toggle paste mode
`Shift`+`Right` | _All_ | Switch to next buffer (:bnext)
`Shift`+`Left` | _All_ | Switch to previous buffer (:bprev)
`<leader>`+`q` | Normal | Closes current buffer (:close)
`<leader>`+`x` | Normal | Removes current buffer (:bdelete)
`Ctrl`+`Tab` | Normal | Switch to next tab (:tabn)
`Ctrl`+`Shift`+`Tab` | Normal | Switch to previous tab (:tabn)

Hope you'll enjoy!
