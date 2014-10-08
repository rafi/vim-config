
" Plugins with NeoBundle
"------------------------------------------------------------------------------
NeoBundleFetch 'Shougo/neobundle.vim'

" Always loaded {{{
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
NeoBundle 'regedarek/ZoomWin'  " TODO: Lazy has problems restoring splits

" My home-made plugins, usually working-tree is dirty
NeoBundle 'rafi/vim-tinyline.git', { 'directory': 'tinyline' }
NeoBundle 'rafi/vim-tagabana.git', { 'directory': 'tagabana' }
NeoBundle 'rafi/vim-tinycomment.git', { 'directory': 'tinycomment' }
NeoBundle 'rafi/vim-phpspec.git', { 'directory': 'phpspec' }
NeoBundleLazy 'rafi/vim-unite-issue.git', {
	\  'directory': 'unite-issue',
	\  'depends': [ 'mattn/webapi-vim', 'tyru/open-browser.vim' ],
	\  'unite_sources': [ 'issue' ]
	\ }

" }}}
" Language {{{
" --------
NeoBundleLazy 'othree/html5.vim', { 'filetypes': 'html' }
NeoBundleLazy 'mustache/vim-mustache-handlebars', { 'filetypes': 'html' }
NeoBundleLazy 'plasticboy/vim-markdown', { 'filetypes': 'mkd' }
NeoBundleLazy 'chase/vim-ansible-yaml', { 'filetypes': 'yaml' }
NeoBundleLazy 'groenewege/vim-less', { 'rev': '5d965c2', 'filetypes': 'less' }
NeoBundleLazy 'hail2u/vim-css3-syntax', { 'filetypes': 'css' }
NeoBundleLazy 'chrisbra/csv.vim', { 'filetypes': 'csv' }
NeoBundleLazy 'fatih/vim-go', { 'filetypes': 'go' }
NeoBundleLazy 'elzr/vim-json', { 'filetypes': 'json' }

" JavaScript {{{
" ----------
NeoBundleLazy 'pangloss/vim-javascript', {
	\   'rev': '51a337b',
	\   'filetypes': 'javascript'
	\ }
NeoBundleLazy 'marijnh/tern_for_vim', {
	\   'build': { 'others': 'npm install' },
	\   'autoload': { 'filetypes': 'javascript' }
	\ }

" }}}
" PHP {{{
" ---
NeoBundleLazy 'StanAngeloff/php.vim', { 'filetypes': 'php' }
NeoBundleLazy 'rayburgemeestre/phpfolding.vim', { 'filetypes': 'php' }
NeoBundleLazy 'shawncplus/phpcomplete.vim', { 'insert': 1, 'filetypes': 'php' }
NeoBundleLazy 'tobyS/pdv', {
	\ 'filetypes': 'php',
	\ 'depends': 'tobyS/vmustache'
	\ }
NeoBundleLazy '2072/PHP-Indenting-for-VIm', {
	\ 'filetypes': 'php',
	\ 'directory': 'php-indent'
	\ }
" }}}

" }}}
" Commands {{{
" --------
NeoBundleLazy 'Shougo/vimfiler.vim', {
	\ 'depends': 'Shougo/unite.vim',
	\ 'autoload' : {
	\   'mappings' : [ '<Plug>(vimfiler_switch)' ],
	\   'commands' : [
	\     { 'name' : 'VimFiler', 'complete' : 'customlist,vimfiler#complete' },
	\     'VimFilerExplorer', 'Edit', 'Read', 'Source', 'Write'
	\ ]}}
NeoBundleLazy 'Shougo/vinarise.vim', {
	\ 'autoload' : { 'commands' : 'Vinarise' }
	\ }
NeoBundleLazy 'tpope/vim-fugitive', {
	\ 'autoload': {
	\   'augroup': 'fugitive',
	\   'commands': [
	\     'Git', 'Gdiff', 'Gstatus', 'Gwrite', 'Gcd', 'Glcd',
	\     'Ggrep', 'Glog', 'Gcommit', 'Gblame', 'Gbrowse'
	\   ]
	\ }}
NeoBundleLazy 'gregsexton/gitv', {
	\ 'depends': 'tpope/vim-fugitive',
	\ 'autoload': { 'commands': [ 'Gitv' ] }
	\ }
NeoBundleLazy 'sjl/gundo.vim', {
	\ 'disabled': ! has('python'),
	\ 'vim_version': '7.3',
	\ 'autoload': { 'commands': [ 'GundoToggle' ] }
	\ }
NeoBundleLazy 'gorkunov/smartpairs.vim', {
	\ 'autoload': {
	\  'commands': [ 'SmartPairs', 'SmartPairsI', 'SmartPairsA' ],
	\  'mappings': [[ 'n', 'viv' ], [ 'v', 'v' ]]
	\ }}
NeoBundleLazy 'farseer90718/vim-colorpicker', {
	\ 'disabled': ! has('python'),
	\ 'commands': 'ColorPicker'
	\ }

" }}}
" Interface {{{
" ---------
NeoBundleLazy 'junegunn/goyo.vim', {
	\ 'depends': 'junegunn/limelight.vim',
	\ 'autoload': {
	\   'commands': 'Goyo'
	\ }}
NeoBundleLazy 'BufClose.vim', { 'commands': [ 'BufClose' ]}
NeoBundleLazy 'matchit.zip', { 'mappings': [[ 'nxo', '%', 'g%' ]]}
NeoBundleLazy 't9md/vim-choosewin', { 'mappings': '<Plug>' }
NeoBundleLazy 'xolox/vim-session', {
	\ 'depends': 'xolox/vim-misc',
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

" }}}
" Completion {{{
" ----------
NeoBundleLazy 'Raimondi/delimitMate', { 'insert': 1 }
NeoBundleLazy 'Shougo/echodoc.vim', { 'insert': 1 }
NeoBundleLazy 'kana/vim-smartchr', { 'insert' : 1 }
NeoBundleLazy 'Shougo/neocomplete', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'disabled': ! has('lua'),
	\ 'vim_version': '7.3.885',
	\ 'insert': 1
	\ }
NeoBundleLazy 'Shougo/neosnippet.vim', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'insert': 1,
	\ 'filetypes': 'snippet',
	\ 'unite_sources': [
	\    'neosnippet', 'neosnippet/user', 'neosnippet/runtime'
	\ ]}

" }}}
" Unite {{{
" -----
NeoBundleLazy 'Shougo/unite.vim', {
	\ 'autoload': {
	\   'commands': [
	\     { 'name': 'Unite', 'complete': 'customlist,unite#complete_source' },
	\     'UniteWithCursorWord', 'UniteWithInput' ]
	\ }}

" Unite sources {{{
" -------------
NeoBundleLazy 'Shougo/neossh.vim', {
	\ 'filetypes': 'vimfiler',
	\ 'sources': 'ssh',
	\ }
NeoBundleLazy 'Shougo/unite-outline', {
	\  'unite_sources': 'outline'
	\ }
NeoBundleLazy 'osyo-manga/unite-quickfix', {
	\  'unite_sources': [ 'quickfix', 'location_list' ]
	\ }
NeoBundleLazy 'tsukkee/unite-tag', {
	\  'unite_sources': [ 'tag', 'tag/file', 'tag/include' ]
	\ }
NeoBundleLazy 'joker1007/unite-pull-request', {
	\  'depends': 'mattn/webapi-vim',
	\  'unite_sources': [ 'pull_request', 'pull_request_file' ]
	\ }
" }}}

" }}}
" Operators {{{
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

" }}}
" Textobjs {{{
" --------
NeoBundleLazy 'kana/vim-textobj-user'
NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', {
	\ 'depends': 'vim-textobj-user',
	\ 'autoload': {
	\   'mappings': [[ 'ox', '<Plug>' ]]
	\ }}
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
