
" Plugins with NeoBundle
"---------------------------------------------------------

" Always loaded {{{
" -------------
NeoBundle 'Shougo/vimproc.vim', {
	\  'build': {
	\    'unix': 'make -f make_unix.mak',
	\    'mac': 'make -f make_mac.mak',
	\    'cygwin': 'make -f make_cygwin.mak',
	\    'windows': 'tools\\update-dll-mingw'
	\ }}

NeoBundle 'itchyny/vim-cursorword'
NeoBundle 'itchyny/vim-gitbranch'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'MattesGroeger/vim-bookmarks'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'rafi/vim-tinyline'
NeoBundle 'rafi/vim-tagabana'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'bogado/file-line'

" LAZY LOADING from here on
" --------------------------------------------------------

" Fetch repositories, but don't add to runtimepath
NeoBundleFetch 'chriskempson/base16-shell'
NeoBundleFetch 'rafi/awesome-vim-colorschemes', {
	\ 'directory': 'colorschemes' }

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
NeoBundleLazy 'fatih/vim-go', { 'filetypes': 'go' }
NeoBundleLazy 'vim-ruby/vim-ruby', {'filetypes': 'ruby', 'mappings': '<Plug>'}
NeoBundleLazy 'jelera/vim-javascript-syntax', { 'filetypes': 'javascript' }
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
	\ 'filetypes': 'javascript',
	\ }
NeoBundleLazy 'StanAngeloff/php.vim', { 'filetypes': 'php' }
NeoBundleLazy 'rayburgemeestre/phpfolding.vim', { 'filetypes': 'php' }
NeoBundleLazy 'rafi/vim-phpspec', {
	\ 'filetypes': 'php',
	\ 'commands': [ 'PhpSpecRun', 'PhpSpecRunCurrent' ]
	\ }

if $VIM_MINIMAL == ''
	NeoBundleLazy 'davidhalter/jedi-vim', { 'filetypes': 'python' }
	NeoBundleLazy 'shawncplus/phpcomplete.vim', {
		\ 'insert': 1,
		\ 'filetypes': 'php'
		\ }
	NeoBundleLazy 'marijnh/tern_for_vim', {
		\   'build': { 'others': 'npm install' },
		\   'disabled': ! executable('npm'),
		\   'filetypes': 'javascript'
		\ }
endif

" }}}
" Commands {{{
" --------
NeoBundleLazy 'Shougo/vimfiler.vim', {
	\ 'depends': [
	\   'Shougo/unite.vim',
	\   'Shougo/tabpagebuffer.vim',
	\   't9md/vim-choosewin'
	\ ],
	\ 'mappings': '<Plug>',
	\ 'explorer': 1,
	\ 'commands': [
	\    { 'name': [ 'VimFiler', 'VimFilerExplorer' ],
	\      'complete': 'customlist,vimfiler#complete' }
	\ ]}
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
	\ 'rev': 'feature/gita-blame-feature',
	\ 'autoload': { 'commands': [ 'Gita' ] }
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

if $VIM_MINIMAL == ''
	NeoBundleLazy 'scrooloose/syntastic', {
		\ 'commands': [
		\   'SyntasticCheck', 'SyntasticStatuslineFlag',
		\   'SyntasticToggleMode', 'Errors', 'SyntasticInfo'
		\ ]}
	NeoBundleLazy 'lambdalisue/vim-gista', {
		\ 'commands': 'Gista',
		\ 'mappings': '<Plug>',
		\ 'unite_sources': 'gista',
		\ }
	NeoBundleLazy 'thinca/vim-ref', { 'unite_sources': 'ref' }
	NeoBundleLazy 'thinca/vim-guicolorscheme', { 'commands': 'GuiColorScheme' }
	NeoBundleLazy 'guns/xterm-color-table.vim', { 'commands': 'XtermColorTable' }
	NeoBundleLazy 'thinca/vim-prettyprint', { 'commands': 'PP' }
	NeoBundleLazy 'thinca/vim-quickrun', { 'mappings': '<Plug>' }
	NeoBundleLazy 'itchyny/dictionary.vim', { 'commands': 'Dictionary' }
	NeoBundleLazy 'beloglazov/vim-online-thesaurus', {
		\ 'commands': [ 'OnlineThesaurusCurrentWord', 'Thesaurus' ]}
	NeoBundleLazy 'junegunn/goyo.vim', {
		\ 'depends': 'junegunn/limelight.vim',
		\ 'commands': 'Goyo'
		\ }
	NeoBundleLazy 'vimwiki/vimwiki', {
		\ 'rev': 'dev',
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
NeoBundleLazy 'Yggdroot/indentLine', { 'filetypes': 'all' }
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
NeoBundleLazy 'Shougo/deoplete.nvim', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'disabled': ! has('nvim'),
	\ 'insert': 1
	\ }
NeoBundleLazy 'Shougo/neocomplete', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'disabled': ! has('lua'),
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

" }}}
" Unite {{{
" -----
NeoBundleLazy 'Shougo/unite.vim', {
	\ 'depends': 'Shougo/tabpagebuffer.vim',
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

if $VIM_MINIMAL == ''
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
NeoBundleLazy 'chikatoike/concealedyank.vim', {
	\ 'mappings': [[ 'x', '<Plug>(operator-concealedyank)' ]]
	\ }

" }}}
" Textobjs {{{
" --------
NeoBundleLazy 'kana/vim-textobj-user'
NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', {
	\ 'depends': 'vim-textobj-user',
	\ 'mappings': [[ 'ox', '<Plug>' ]]
	\ }
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
