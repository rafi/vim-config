
" Plugins with NeoBundle {{{1
"------------------------------------------------------------------------------

" Manage NeoBundle itself
NeoBundleFetch 'Shougo/neobundle.vim.git'

" Rafi's plugins, usually working-tree is dirty
NeoBundle 'rafi/vim-tinyline.git', { 'directory': 'tinyline' }
NeoBundle 'rafi/vim-tagabana.git', { 'directory': 'tagabana' }

" Filetypes
" TODO: Turn lazy
NeoBundle 'mustache/vim-mustache-handlebars.git'
NeoBundle 'chase/vim-ansible-yaml.git'
NeoBundle 'plasticboy/vim-markdown.git'
NeoBundle 'groenewege/vim-less.git', { 'rev': '5d965c2' }
NeoBundleLazy 'hail2u/vim-css3-syntax.git', { 'filetypes': 'css' }
NeoBundleLazy 'chrisbra/csv.vim.git', { 'filetypes': 'csv' }
NeoBundleLazy 'fatih/vim-go.git', { 'filetypes': 'go' }
NeoBundleLazy 'elzr/vim-json.git', { 'filetypes': 'json' }

" JavaScript
NeoBundle 'pangloss/vim-javascript.git', { 'rev': '51a337b' }
NeoBundle 'marijnh/tern_for_vim.git', { 'build': { 'others': 'npm install' }}

" PHP
NeoBundleLazy 'StanAngeloff/php.vim.git', { 'filetypes': 'php' }
NeoBundleLazy 'rayburgemeestre/phpfolding.vim.git', { 'filetypes': 'php' }
NeoBundle 'tobyS/pdv.git', { 'depends': 'tobyS/vmustache.git' }
NeoBundle 'shawncplus/phpcomplete.vim.git'
NeoBundle '2072/PHP-Indenting-for-VIm.git', { 'directory': 'php-indent' }

" Utilities
NeoBundle 'tpope/vim-fugitive.git', { 'augroup': 'fugitive' }
NeoBundle 'gregsexton/gitv.git'
NeoBundle 'mhinz/vim-signify.git'
NeoBundle 'sjl/gundo.vim.git', {
					\ 'disabled': ! has('python'),
					\ 'vim_version': '7.3'
					\ }

" UI
NeoBundle 'w0ng/vim-hybrid.git'
NeoBundle 'BufClose.vim'
NeoBundle 'regedarek/ZoomWin.git'
NeoBundle 'christoomey/vim-tmux-navigator.git'
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

NeoBundle 'farseer90718/vim-colorpicker.git'
NeoBundle 'bogado/file-line.git'
NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'majutsushi/tagbar.git'
NeoBundle 'MattesGroeger/vim-bookmarks.git'

NeoBundle 'godlygeek/tabular.git'
NeoBundle 'mattn/emmet-vim.git'

" Insert mode plugins
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

" Shougo
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'Shougo/vinarise.vim.git'
NeoBundle 'Shougo/vimfiler.vim.git'
NeoBundle 'Shougo/vimproc.vim.git', {
					\ 'build': {
					\   'unix': 'make -f make_unix.mak',
					\   'mac': 'make -f make_mac.mak',
					\   'cygwin': 'make -f make_cygwin.mak',
					\   'windows': 'tools\\update-dll-mingw'
					\ }}

" Unite sources
NeoBundle 'Shougo/neomru.vim.git'
NeoBundleLazy 'Shougo/unite-outline.git'
NeoBundleLazy 'Shougo/neossh.vim.git', {
							\ 'filetypes': 'vimfiler',
							\ 'sources': 'ssh',
							\ }
NeoBundleLazy 'osyo-manga/unite-quickfix.git'
NeoBundleLazy 'tsukkee/unite-tag.git'
NeoBundleLazy 'joker1007/unite-pull-request.git', {
							\ 'depends': 'mattn/webapi-vim.git'
							\ }

" Operators
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

" Textobjs
NeoBundleLazy 'kana/vim-textobj-user'
NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', {
							\ 'depends' : 'vim-textobj-user',
							\ 'autoload' : {
							\   'mappings' : [['ox', '<Plug>' ]]
							\ }}
