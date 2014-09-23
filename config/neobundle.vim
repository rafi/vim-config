
" Plugins with NeoBundle {{{1
"------------------------------------------------------------------------------
NeoBundleFetch 'Shougo/neobundle.vim'

" Always loaded {{{2
" -------------
NeoBundle 'Shougo/vimproc.vim', {
	\  'build': {
	\    'unix': 'make -f make_unix.mak',
	\    'mac': 'make -f make_mac.mak',
	\    'cygwin': 'make -f make_cygwin.mak',
	\    'windows': 'tools\\update-dll-mingw'
	\ }}

NeoBundle 'Shougo/neomru.vim'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'bogado/file-line'
NeoBundle 'MattesGroeger/vim-bookmarks'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'godlygeek/tabular'  " TODO: Lazy-load?
NeoBundle 'regedarek/ZoomWin'  " TODO: With lazy, problem restoring splits

" Rafi's plugins, usually working-tree is dirty
NeoBundle 'rafi/vim-tinyline.git', { 'directory': 'tinyline' }
NeoBundle 'rafi/vim-tagabana.git', { 'directory': 'tagabana' }

" Filetypes {{{2
" ---------
NeoBundleLazy 'mustache/vim-mustache-handlebars', { 'filetypes': 'html' }
NeoBundleLazy 'plasticboy/vim-markdown.git', { 'filetypes': 'mkd' }
NeoBundleLazy 'chase/vim-ansible-yaml.git', { 'filetypes': 'yaml' }
NeoBundleLazy 'groenewege/vim-less.git', { 'rev': '5d965c2', 'filetypes': 'less' }
NeoBundleLazy 'hail2u/vim-css3-syntax.git', { 'filetypes': 'css' }
NeoBundleLazy 'chrisbra/csv.vim.git', { 'filetypes': 'csv' }
NeoBundleLazy 'fatih/vim-go.git', { 'filetypes': 'go' }
NeoBundleLazy 'elzr/vim-json.git', { 'filetypes': 'json' }

" JavaScript {{{2
" ----------
NeoBundleLazy 'pangloss/vim-javascript.git', {
	\   'rev': '51a337b',
	\   'filetypes': 'javascript'
	\ }
NeoBundleLazy 'marijnh/tern_for_vim.git', {
	\   'build': { 'others': 'npm install' },
	\   'autoload': { 'filetypes': 'javascript' }
	\ }

" PHP {{{2
" ---
NeoBundleLazy 'StanAngeloff/php.vim.git', { 'filetypes': 'php' }
NeoBundleLazy 'rayburgemeestre/phpfolding.vim.git', { 'filetypes': 'php' }
NeoBundleLazy 'shawncplus/phpcomplete.vim.git', { 'insert': 1, 'filetypes': 'php' }
NeoBundleLazy 'tobyS/pdv.git', { 'depends': 'tobyS/vmustache.git' }
NeoBundleLazy '2072/PHP-Indenting-for-VIm.git', {
	\ 'filetypes': 'php',
	\ 'directory': 'php-indent'
	\ }

" Utilities {{{2
" ---------
NeoBundleLazy 'tpope/vim-fugitive.git', {
	\ 'autoload': {
	\   'augroup': 'fugitive',
	\   'commands': [
	\     'Git', 'Gdiff', 'Gstatus', 'Gwrite', 'Gcd', 'Glcd',
	\     'Ggrep', 'Glog', 'Gcommit', 'Gblame', 'Gbrowse'
	\   ]
	\ }}
NeoBundleLazy 'gregsexton/gitv.git', {
	\ 'depends': 'tpope/vim-fugitive.git',
	\ 'autoload': { 'commands': [ 'Gitv' ]}
	\ }
NeoBundleLazy 'sjl/gundo.vim.git', {
	\ 'disabled': ! has('python'),
	\ 'vim_version': '7.3',
	\ 'autoload': { 'commands': [ 'GundoToggle' ]}
	\ }
NeoBundleLazy 'gorkunov/smartpairs.vim', {
	\ 'autoload': {
	\  'commands': [ 'SmartPairs', 'SmartPairsI', 'SmartPairsA' ],
	\  'mappings': [[ 'n', 'viv' ], [ 'v', 'v' ]]
	\ }}
NeoBundleLazy 'majutsushi/tagbar.git', { 'commands': 'TagbarToggle' }
NeoBundleLazy 'farseer90718/vim-colorpicker.git', { 'commands': 'ColorPicker' }

" UI {{{2
" --
NeoBundleLazy 'BufClose.vim', { 'commands': [ 'BufClose' ]}
NeoBundleLazy 'matchit.zip', { 'mappings': [[ 'nxo', '%', 'g%' ]]}
NeoBundleLazy 't9md/vim-choosewin.git', { 'mappings': '<Plug>' }
NeoBundleLazy 'xolox/vim-session.git', {
	\ 'depends': 'xolox/vim-misc.git',
	\ 'augroup': 'PluginSession',
	\ 'autoload': {
	\ 'commands': [
	\   { 'name': [ 'OpenSession', 'CloseSession' ],
	\     'complete': 'customlist,xolox#session#complete_names' },
	\   { 'name': [ 'SaveSession' ],
	\     'complete': 'customlist,xolox#session#complete_names_with_suggestions' }
	\ ],
	\ 'functions': [ 'xolox#session#complete_names',
	\                'xolox#session#complete_names_with_suggestions' ],
	\ 'unite_sources': [ 'session', 'session/new' ]
	\ }}

" Insert Mode {{{2
" -----------
NeoBundleLazy 'Raimondi/delimitMate.git', { 'insert': 1 }
NeoBundleLazy 'Shougo/echodoc.vim.git', { 'insert': 1 }
NeoBundleLazy 'kana/vim-smartchr', { 'insert' : 1 }
NeoBundleLazy 'Shougo/neocomplete.git', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'disabled': ! has('lua'),
	\ 'vim_version': '7.3.885',
	\ 'insert': 1
	\ }
NeoBundleLazy 'Shougo/neosnippet.vim.git', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'insert': 1,
	\ 'filetypes': 'snippet',
	\ 'unite_sources': [
	\    'neosnippet', 'neosnippet/user', 'neosnippet/runtime'
	\ ]}

" Shougo {{{2
" ------
NeoBundleLazy 'Shougo/unite.vim.git', {
	\ 'autoload': {
	\   'commands': [
	\     { 'name' : 'Unite', 'complete' : 'customlist,unite#complete_source' },
	\     'UniteWithCursorWord', 'UniteWithInput' ]
	\ }}
NeoBundleLazy 'Shougo/vimfiler.vim.git', {
	\ 'depends': 'Shougo/unite.vim',
	\ 'autoload' : {
	\   'mappings' : [ '<Plug>(vimfiler_switch)' ],
	\   'commands' : [
	\     { 'name' : 'VimFiler', 'complete' : 'customlist,vimfiler#complete' },
	\     'VimFilerExplorer', 'Edit', 'Read', 'Source', 'Write'
	\ ]}}
NeoBundleLazy 'Shougo/vinarise.vim.git', {
	\ 'autoload' : { 'commands' : 'Vinarise' }
	\ }

" Unite sources
NeoBundleLazy 'Shougo/neossh.vim.git', {
	\ 'filetypes': 'vimfiler',
	\ 'sources': 'ssh',
	\ }
NeoBundleLazy 'Shougo/unite-outline.git', {
	\  'unite_sources': 'outline'
	\ }
NeoBundleLazy 'osyo-manga/unite-quickfix.git', {
	\  'unite_sources': [ 'quickfix', 'location_list' ]
	\ }
NeoBundleLazy 'tsukkee/unite-tag.git', {
	\  'unite_sources': [ 'tag', 'tag/file', 'tag/include' ]
	\ }
NeoBundleLazy 'joker1007/unite-pull-request.git', {
	\  'depends': 'mattn/webapi-vim.git',
	\  'unite_sources': [ 'pull_request', 'pull_request_file' ]
	\ }

" Operators {{{2
" ---------
NeoBundleLazy 'kana/vim-operator-user', {
	\ 'functions': 'operator#user#define',
	\ }
NeoBundleLazy 'kana/vim-operator-replace', {
	\ 'depends': 'vim-operator-user',
	\ 'autoload': {
	\   'mappings': [[ 'nx', '<Plug>(operator-replace)' ]]
	\ }}
NeoBundleLazy 'rhysd/vim-operator-surround', {
	\ 'depends': 'vim-operator-user',
	\ 'mappings': '<Plug>'
	\ }

" Textobjs {{{2
" --------
NeoBundleLazy 'kana/vim-textobj-user'
NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', {
	\ 'depends' : 'vim-textobj-user',
	\ 'autoload' : {
	\   'mappings' : [['ox', '<Plug>' ]]
	\ }}
