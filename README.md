# Vim config

This is my Vim configuration, with a few colorschemes and plugins loaded with pathogen.

## XDG conformity

The `.vim` folder is usually placed in the home folder. However, I wanted it to conform
to the XDG standard.
Notice these topmost lines in `vimrc`:

    set runtimepath=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM,$VIMRUNTIME
    let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"

And this environment variable:

    export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

## Plugins

Name           | Description
-------------- | ----------------------
[autocomplpop] | Automatically opens popup menu for completions
[csv] | Handling column separated data
[ctrlp] | Fuzzy file, buffer, mru, tag, etc finder
[easymotion] | Motions on speed
[editorconfig] | Applies EditorConfig properties
[fugitive] | Git wrapper
[gitgutter] | Shows a git diff in the gutter and stages/reverts hunks
[hybrid] | Dark colour scheme
[lightline] | Light and configurable statusline/tabline
[markdown] | Markdown syntax highlighting
[mustache] | Mustache and handlebars mode
[nerdtree] | Tree explorer
[pathogen] | Manage your runtimepath
[snipmate] | Snippets features
[supertab] | Perform all your vim insert mode completions with Tab
[surround] | Quoting/parenthesizing made simple
[syntastic] | Syntax checking hacks
[tabular] | Text filtering and alignment
[tagbar] | Displays tags in a window, ordered by scope
[tagbar-phpctags] | Addon for tagbar using phpctags

[autocomplpop]: https://github.com/vim-scripts/AutoComplPop
[csv]: https://github.com/chrisbra/csv.vim
[ctrlp]: https://github.com/kien/ctrlp.vim
[easymotion]: https://github.com/vim-scripts/AutoComplPop
[editorconfig]: https://github.com/editorconfig/editorconfig-vim
[fugitive]: https://github.com/tpope/vim-fugitive
[gitgutter]: https://github.com/airblade/vim-gitgutter
[hybrid]: https://github.com/w0ng/vim-hybrid
[lightline]: https://github.com/itchyny/lightline.vim
[markdown]: https://github.com/plasticboy/vim-markdown
[mustache]: https://github.com/mustache/vim-mustache-handlebars
[nerdtree]: https://github.com/scrooloose/nerdtree
[pathogen]: https://github.com/tpope/vim-pathogen
[snipmate]: https://github.com/msanders/snipmate.vim
[supertab]: https://github.com/ervandew/supertab
[surround]: https://github.com/tpope/vim-surround
[syntastic]: https://github.com/scrooloose/syntastic
[tabular]: https://github.com/godlygeek/tabular
[tagbar]: https://github.com/majutsushi/tagbar
[tagbar-phpctags]: https://github.com/vim-php/tagbar-phpctags.vim

## Key bindings

Key   | Mode | Action
----- | ---- | ------------------
`Space` | Normal | **Leader**
`;` | Normal | **Command mode**
Arrows | _All_ | **Disabled**! Force good habits
`w!!` | Command | Sudo write
`jk` | Insert | Exit insert mode
`<leader>`+`sh` | Normal | Split (:sp)
`<leader>`+`sv` | Normal | Vertical split (:vsp)
`Alt`+`m` | Normal | Move to split below (<C-w>j)
`Alt`+`,` | Normal | Move to upper split (<C-w>k)
`Alt`+`n` | Normal | Move to left split (<C-w>h)
`Alt`+`.` | Normal | Move to right split (<C-w>l)
`<leader>`+`w` | Normal/visual | Write (:w)
`Ctrl`+`s` | Normal/visual/insert | Write (:w)
`<` | Visual | Indent to left and re-select (<gv)
`>` | Visual | Indent to left and re-select (>gv)
`<leader>`+`l` | Normal | Toggle line numbers (:set nonumber!)
`<leader>`+`h` | Normal | Clear highlighted search (:set nohlsearch)
`<leader>`+`s` | Normal | Toggle hidden characters (:set nolist!)
`Ctrl`+`e` | _All_ | Scroll window downwards three lines (3<C-e>)
`Ctrl`+`y` | _All_ | Scroll window upwards three lines (3<C-y>)
`<leader>`+`y` | Normal/visual | Copy selection to X11 clipboard ("+y)
`<leader>`+`p` | Normal/visual | Paste selection from X11 clipboard ("+p)
`F8` | Normal | Toggle Tagbar (:TagbarToggle)
`<leader>`+`t` | Normal | Toggle Tagbar (:TagbarToggle)
`<leader>`+`cd` | Normal | Switch to the directory of opened buffer (:cd %:p:h)
`Ctrl`+`Space` | Insert | Word completion (Ctrl+N)
`<leader>`+`ev` | Normal | Load vimrc file (:e $MYVIMRC)
`<leader>`+`es` | Normal | Source vimrc file (:so $MYVIMRC)
`F1` | Normal | Toggle NERD Tree (:NERDTreeToggle)
`F2` | _All_ | Toggle paste mode
`Shift`+`Right` | _All_ | Switch to next buffer (:bn)
`Shift`+`Left` | _All_ | Switch to previous buffer (:bp)
`<leader>`+`q` | Normal | Closes current buffer (:close)
`Ctrl`+`Tab` | Normal | Switch to next tab (:tabn)
`Ctrl`+`Shift`+`Tab` | Normal | Switch to previous tab (:tabn)

Hope you'll enjoy!
