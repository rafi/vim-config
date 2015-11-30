
" Plugins with NeoBundle
"---------------------------------------------------------

" Always loaded {{{
" -------------
NeoBundle 'Shougo/vimproc.vim', {
	\ 'build' : {
	\     'cygwin' : 'make -f make_cygwin.mak',
	\     'mac' : 'make -f make_mac.mak',
	\     'linux' : 'make',
	\     'unix' : 'gmake',
	\     'windows' : 'tools\\update-dll-mingw',
	\    },
	\ }

NeoBundle 'itchyny/vim-cursorword'
NeoBundle 'itchyny/vim-gitbranch'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'kshenoy/vim-signature'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'rafi/vim-tinyline'
NeoBundle 'rafi/vim-tagabana'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'bogado/file-line'
NeoBundle 'thinca/vim-localrc'

" LAZY LOADING from here on
" --------------------------------------------------------

" Fetch repositories, but don't add to runtimepath
NeoBundleFetch 'chriskempson/base16-shell'
NeoBundleFetch 'rafi/awesome-vim-colorschemes'

" }}}
" Language {{{
" --------
NeoBundleLazy 'othree/html5.vim', { 'filetypes': 'html' }
NeoBundleLazy 'mustache/vim-mustache-handlebars', { 'filetypes': 'html' }
NeoBundleLazy 'rcmdnk/vim-markdown', { 'filetypes': 'markdown' }
NeoBundleLazy 'chase/vim-ansible-yaml', { 'filetypes': [ 'yaml', 'ansible'] }
NeoBundleLazy 'mitsuhiko/vim-jinja', { 'filetypes': [ 'htmljinja', 'jinja' ] }
NeoBundleLazy 'groenewege/vim-less', { 'filetypes': 'less' }
NeoBundleLazy 'hail2u/vim-css3-syntax', { 'filetypes': 'css' }
NeoBundleLazy 'chrisbra/csv.vim', { 'filetypes': 'csv' }
NeoBundleLazy 'hynek/vim-python-pep8-indent', { 'filetypes': 'python' }
NeoBundleLazy 'robbles/logstash.vim', { 'filetypes': 'logstash' }
NeoBundleLazy 'tmux-plugins/vim-tmux', { 'filetypes': 'tmux' }
NeoBundleLazy 'elzr/vim-json', { 'filetypes': 'json' }
NeoBundleLazy 'cespare/vim-toml', { 'filetypes': 'toml' }
NeoBundleLazy 'PotatoesMaster/i3-vim-syntax', { 'filetypes': 'i3' }
NeoBundleLazy 'ekalinin/Dockerfile.vim', { 'filetypes': 'Dockerfile' }
NeoBundleLazy 'jstrater/mpvim', { 'filetypes': 'portfile' }
NeoBundleLazy 'vim-ruby/vim-ruby', { 'filetypes': 'ruby', 'mappings': '<Plug>' }
NeoBundleLazy 'jelera/vim-javascript-syntax', { 'filetypes': 'javascript' }
NeoBundleLazy 'fatih/vim-go', {
	\ 'filetypes': 'go',
	\ 'commands': [ 'GoInstallBinaries', 'GoUpdateBinaries' ]
	\ }
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
	\ 'filetypes': 'javascript',
	\ }
NeoBundleLazy 'StanAngeloff/php.vim', { 'filetypes': 'php' }
NeoBundleLazy 'rayburgemeestre/phpfolding.vim', { 'filetypes': 'php' }
NeoBundleLazy 'rafi/vim-phpspec', {
	\ 'filetypes': 'php',
	\ 'commands': [ 'PhpSpecRun', 'PhpSpecRunCurrent' ]
	\ }

" }}}
" Commands {{{
" --------
NeoBundleLazy 'Shougo/vimfiler.vim', {
	\ 'depends': 'Shougo/unite.vim',
	\ 'mappings': '<Plug>',
	\ 'explorer': '^\h\w*:',
	\ 'commands': [
	\    {'name': ['VimFiler'], 'complete': 'customlist,vimfiler#complete'}
	\ ]}
NeoBundleLazy 'tyru/caw.vim', { 'mappings': '<Plug>' }
NeoBundleLazy 'rafi/vim-tinycomment', {
	\ 'augroup': 'tinycomment',
	\ 'commands': [ 'TinyCommentLines', 'TinyCommentBlock' ],
	\ 'mappings': [
	\   [ 'n', '<leader>v' ], [ 'v', '<leader>v' ],
	\   [ 'v', '<leader>V' ]
	\ ]}
NeoBundleLazy 'Shougo/vinarise.vim', {
	\ 'commands': [
	\   { 'name': 'Vinarise', 'complete': 'file' }
	\ ]}
NeoBundleLazy 'lambdalisue/vim-gita', {
	\ 'autoload': { 'commands': [ 'Gita' ] }
	\ }
NeoBundleLazy 't9md/vim-choosewin', {
	\ 'mappings': '<Plug>(choosewin)'
	\ }
NeoBundleLazy 'haya14busa/vim-asterisk', {
	\ 'mappings': '<Plug>(asterisk-'
	\ }
NeoBundleLazy 'haya14busa/incsearch.vim', {
	\ 'mappings': '<Plug>(incsearch-'
	\ }
NeoBundleLazy 'mbbill/undotree', { 'commands': 'UndotreeToggle' }
NeoBundleLazy 'terryma/vim-expand-region', {
	\ 'mappings': [[ 'x', '<Plug>' ]]
	\ }
NeoBundleLazy 'lambdalisue/vim-findent', {'explorer': 1}

if $VIM_MINIMAL ==? ''
	NeoBundleLazy 'lambdalisue/vim-gista', {
		\ 'commands': 'Gista',
		\ 'mappings': '<Plug>',
		\ 'unite_sources': 'gista',
		\ }
	NeoBundleLazy 'thinca/vim-guicolorscheme', { 'commands': 'GuiColorScheme' }
	NeoBundleLazy 'guns/xterm-color-table.vim', { 'commands': 'XtermColorTable' }
	NeoBundleLazy 'thinca/vim-quickrun', { 'mappings': '<Plug>' }
	NeoBundleLazy 'itchyny/dictionary.vim', { 'commands': 'Dictionary' }
	NeoBundleLazy 'thinca/vim-prettyprint', {
		\ 'commands': 'PP', 'functions': 'PP' }
	NeoBundleLazy 'beloglazov/vim-online-thesaurus', {
		\ 'commands': [ 'OnlineThesaurusCurrentWord', 'Thesaurus' ]}
	NeoBundleLazy 'junegunn/goyo.vim', {
		\ 'depends': 'junegunn/limelight.vim',
		\ 'commands': 'Goyo'
		\ }
	NeoBundleLazy 'vimwiki/vimwiki', {
		\ 'commands': [
		\   'VimwikiIndex', 'VimwikiTabIndex', 'VimwikiUISelect',
		\   'VimwikiMakeDiaryNote', 'VimwikiTabMakeDiaryNote',
		\   'VimwikiDiaryIndex'
		\ ]}
endif

" }}}
" Interface {{{
" ---------
NeoBundleLazy 'matchit.zip', { 'mappings': [[ 'nxo', '%', 'g%' ]]}
NeoBundleLazy 'kana/vim-niceblock', { 'mappings': '<Plug>' }
NeoBundleLazy 'rhysd/accelerated-jk', { 'mappings': '<Plug>' }
NeoBundleLazy 'rhysd/clever-f.vim', {
	\ 'mappings': [[ 'n', 'f', 'F', 't', 'T' ]]
	\ }

" }}}
" Completion {{{
" ----------
NeoBundleLazy 'Shougo/deoplete.nvim', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'disabled': ! has('nvim'),
	\ 'insert': 1,
	\ 'neovim': 1
	\ }
NeoBundleLazy 'Shougo/neocomplete', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'disabled': ! has('lua') || has('nvim'),
	\ 'vim_version': '7.3.885',
	\ 'insert': 1
	\ }
NeoBundleLazy 'Shougo/neosnippet.vim', {
	\ 'depends': [ 'Shougo/neosnippet-snippets', 'Shougo/context_filetype.vim' ],
	\ 'insert': 1,
	\ 'filetypes': 'snippet',
	\ 'unite_sources': [
	\    'neosnippet', 'neosnippet/user', 'neosnippet/runtime'
	\ ]}
NeoBundleLazy 'Raimondi/delimitMate', { 'insert': 1 }
NeoBundleLazy 'Shougo/echodoc.vim', { 'insert': 1 }
NeoBundleLazy 'Shougo/neco-vim', { 'filetypes': 'vim', 'insert': 1 }
NeoBundleLazy 'Shougo/neco-syntax', { 'insert': 1 }
NeoBundleLazy 'Shougo/neopairs.vim', { 'insert': 1 }
NeoBundleLazy 'Shougo/neoinclude.vim', { 'filetypes': 'all' }

if $VIM_MINIMAL ==? ''
	NeoBundleLazy 'benekastah/neomake', { 'commands': [ 'Neomake' ] }
	NeoBundleLazy 'davidhalter/jedi-vim', { 'filetypes': 'python' }
	NeoBundleLazy 'shawncplus/phpcomplete.vim', {
		\ 'insert': 1,
		\ 'filetypes': 'php'
		\ }
	NeoBundleLazy 'ternjs/tern_for_vim', {
		\ 'build': { 'others': 'npm install' },
		\ 'disabled': ! executable('npm'),
		\ 'insert': 1,
		\ 'filetypes': 'javascript'
		\ }
endif

" }}}
" Unite {{{
" -----
NeoBundleLazy 'Shougo/unite.vim', {
	\ 'depends': 'Shougo/tabpagebuffer.vim',
	\ 'neovim': 1,
	\ 'commands': [
	\   { 'name': 'Unite', 'complete': 'customlist,unite#complete_source' }
	\ ]}

" Unite sources {{{
" -------------
NeoBundleLazy 'ujihisa/unite-colorscheme'
NeoBundleLazy 'osyo-manga/unite-filetype'
NeoBundleLazy 'thinca/vim-unite-history'
NeoBundleLazy 'Shougo/unite-build'
NeoBundleLazy 'Shougo/unite-outline'
NeoBundleLazy 'tacroe/unite-mark'
NeoBundleLazy 'Shougo/junkfile.vim', { 'unite_sources': 'junkfile' }
NeoBundleLazy 'tsukkee/unite-tag', {
	\  'unite_sources': [ 'tag', 'tag/file', 'tag/include' ]
	\ }
NeoBundleLazy 'osyo-manga/unite-quickfix', {
	\ 'unite_sources': [ 'quickfix', 'location_list' ]
	\ }
NeoBundleLazy 'Shougo/neossh.vim', {
	\ 'filetypes': 'vimfiler',
	\ 'sources': 'ssh',
	\ }

if $VIM_MINIMAL ==? ''
	NeoBundleLazy 'rafi/vim-unite-issue', {
		\  'depends': [ 'mattn/webapi-vim', 'tyru/open-browser.vim' ]}
	NeoBundleLazy 'joker1007/unite-pull-request', {
		\ 'depends': 'mattn/webapi-vim',
		\ 'unite_sources': [ 'pull_request', 'pull_request_file' ]
		\ }
endif
" }}}

" }}}
" Operators {{{
" ---------
NeoBundleLazy 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-operator-replace', {
	\ 'depends': 'vim-operator-user',
	\ 'mappings': [[ 'nx', '<Plug>' ]]
	\ }
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
	\ 'mappings': [[ 'ox', '<Plug>' ]]
	\ }
NeoBundleLazy 'AndrewRadev/sideways.vim', {
	\ 'mappings': [[ 'ox', '<Plug>' ]]
	\ }
NeoBundleLazy 'bkad/CamelCaseMotion', {
	\ 'mappings': ['<Plug>CamelCaseMotion_w', '<Plug>CamelCaseMotion_b']
	\ }
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
