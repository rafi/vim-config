
" Plugins with NeoBundle {{{1
"------------------------------------------------------------------------------

NeoBundleFetch 'Shougo/neobundle.vim.git'

NeoBundle 'Shougo/vimproc.vim.git', {
					\ 'build': {
					\   'unix': 'make -f make_unix.mak',
					\   'mac': 'make -f make_mac.mak',
					\   'cygwin': 'make -f make_cygwin.mak',
					\   'windows': 'tools\\update-dll-mingw'
					\ }}

NeoBundle 'w0ng/vim-hybrid.git', { 'directory': 'hybrid' }

" My plugins
NeoBundle 'rafi/vim-tinyline.git', { 'directory': 'tinyline' }
NeoBundle 'rafi/vim-tagabana.git', { 'directory': 'tagabana' }

" Filetypes
" TODO: Turn lazy
NeoBundle '2072/PHP-Indenting-for-VIm.git', { 'directory': 'php-indent' }
NeoBundle 'mustache/vim-mustache-handlebars.git', { 'directory': 'mustache' }
NeoBundle 'chase/vim-ansible-yaml.git', { 'directory': 'ansible-yaml' }
NeoBundle 'plasticboy/vim-markdown.git', { 'directory': 'markdown' }
NeoBundle 'pangloss/vim-javascript.git',
					\ { 'directory': 'javascript', 'rev': '51a337b' }
NeoBundle 'groenewege/vim-less.git', { 'directory': 'less', 'rev': '5d965c2' }

NeoBundleLazy 'hail2u/vim-css3-syntax.git',
							\ { 'directory': 'css3-syntax', 'filetypes': 'css' }
NeoBundleLazy 'chrisbra/csv.vim.git', { 'filetypes': 'csv' }
NeoBundleLazy 'fatih/vim-go.git', { 'directory': 'go', 'filetypes': 'go' }
NeoBundleLazy 'elzr/vim-json.git', { 'directory': 'json', 'filetypes': 'json' }
NeoBundleLazy 'StanAngeloff/php.vim.git', { 'filetypes': 'php' }
NeoBundleLazy 'rayburgemeestre/phpfolding.vim.git', { 'filetypes': 'php' }

" Utilities
NeoBundle 'bogado/file-line.git'
NeoBundle 'gregsexton/gitv.git'
NeoBundle 'scrooloose/syntastic.git'
NeoBundle 'godlygeek/tabular.git'
NeoBundle 'majutsushi/tagbar.git'
NeoBundle 'farseer90718/vim-colorpicker.git', { 'directory': 'colorpicker' }
NeoBundle 'sjl/gundo.vim.git', {
					\ 'disabled': ! has('python'),
					\ 'vim_version': '7.3'
					\ }
NeoBundle 'MattesGroeger/vim-bookmarks.git', { 'directory': 'bookmarks' }
NeoBundle 'BufClose.vim', { 'directory': 'bufclose' }
NeoBundle 'Raimondi/delimitMate.git', { 'directory': 'delimitmate' }
NeoBundle 'mattn/emmet-vim.git', { 'directory': 'emmet' }
NeoBundle 'tpope/vim-fugitive.git',
					\ { 'directory': 'fugitive', 'augroup': 'fugitive' }
NeoBundle 'shawncplus/phpcomplete.vim.git'
NeoBundle 'tobyS/pdv.git', {
					\ 'directory': 'phpdoc',
					\ 'depends': 'tobyS/vmustache.git'
					\ }
NeoBundle 'mhinz/vim-signify.git', { 'directory': 'signify' }
NeoBundle 'marijnh/tern_for_vim.git',
					\ { 'directory': 'tern', 'build': { 'others': 'npm install' }}
NeoBundle 'christoomey/vim-tmux-navigator.git',
					\ { 'directory': 'tmux-navigator' }
NeoBundle 'regedarek/ZoomWin.git', { 'directory': 'zoomwin' }
NeoBundleLazy 'matchit.zip', { 'mappings': [[ 'nxo', '%', 'g%' ]]}
NeoBundleLazy 't9md/vim-choosewin.git',
							\ { 'directory': 'choosewin', 'mappings': '<Plug>' }

" Insert mode plugins
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
NeoBundle 'Shougo/neomru.vim.git'

" Unite sources
NeoBundleLazy 'Shougo/unite-outline.git'
NeoBundleLazy 'Shougo/unite-session.git'
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
