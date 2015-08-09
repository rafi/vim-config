
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

NeoBundle 'bogado/file-line'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'itchyny/vim-cursorword'
NeoBundle 'itchyny/vim-gitbranch'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'rafi/vim-tinyline', { 'directory': 'tinyline' }
NeoBundle 'rafi/vim-tagabana', { 'directory': 'tagabana' }
NeoBundle 'MattesGroeger/vim-bookmarks'
NeoBundle 'christoomey/vim-tmux-navigator'

NeoBundleFetch 'chriskempson/base16-shell'
NeoBundleFetch 'rafi/awesome-vim-colorschemes', {
	\ 'directory': 'colorschemes' }


" LAZY LOADING from here on
" --------------------------------------------------------

" }}}
" Color tools {{{
" -------------
NeoBundleLazy 'godlygeek/csapprox'
NeoBundleLazy 'thinca/vim-guicolorscheme'
NeoBundleLazy 'guns/xterm-color-table.vim', { 'commands': 'XtermColorTable' }

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
NeoBundleLazy 'fatih/vim-go', {
	\ 'filetypes': 'go',
	\ 'disabled': len($SSH_CLIENT)
	\ }
NeoBundleLazy 'davidhalter/jedi-vim', {
	\ 'disabled': len($SSH_CLIENT),
	\ 'filetypes': 'python'
	\ }
NeoBundleLazy 'vim-ruby/vim-ruby', {
	\ 'mappings': '<Plug>',
	\ 'filetypes': 'ruby'
	\ }

" }}}
" JavaScript {{{
" ----------
NeoBundleLazy 'jelera/vim-javascript-syntax', { 'filetypes': 'javascript' }
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
	\ 'filetypes': 'javascript',
	\ }
NeoBundleLazy 'marijnh/tern_for_vim', {
	\   'build': { 'others': 'npm install' },
	\   'disabled': ! executable('npm') || len($SSH_CLIENT),
	\   'filetypes': 'javascript'
	\ }

" }}}
" PHP {{{
" ---
NeoBundleLazy 'StanAngeloff/php.vim', { 'filetypes': 'php' }
NeoBundleLazy 'rayburgemeestre/phpfolding.vim', { 'filetypes': 'php' }
NeoBundleLazy 'shawncplus/phpcomplete.vim', {
	\ 'disabled': len($SSH_CLIENT),
	\ 'insert': 1,
	\ 'filetypes': 'php'
	\ }
NeoBundleLazy '2072/PHP-Indenting-for-VIm', {
	\ 'filetypes': 'php',
	\ 'directory': 'php-indent'
	\ }
NeoBundleLazy 'rafi/vim-phpspec', {
	\ 'filetypes': 'php',
	\ 'directory': 'phpspec',
	\ 'commands': [ 'PhpSpecRun', 'PhpSpecRunCurrent' ]
	\ }
" }}}

" }}}
" Commands {{{
" --------
NeoBundleLazy 'Shougo/vimfiler.vim', {
	\ 'depends': [
	\   'Shougo/unite.vim',
	\   'Shougo/tabpagebuffer.vim',
	\   'itchyny/unite-preview',
	\   't9md/vim-choosewin'
	\ ],
	\ 'mappings': '<Plug>',
	\ 'explorer': 1,
	\ 'commands': [
	\    { 'name': [ 'VimFiler', 'VimFilerExplorer' ],
	\      'complete': 'customlist,vimfiler#complete' }
	\ ]}
NeoBundleLazy 'rafi/vim-tinycomment', {
	\ 'directory': 'tinycomment',
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
NeoBundleLazy 'scrooloose/syntastic', {
	\ 'disabled': len($SSH_CLIENT),
	\ 'autoload': {
	\   'commands': [
	\     'SyntasticCheck', 'SyntasticStatuslineFlag',
	\     'SyntasticToggleMode', 'Errors', 'SyntasticInfo'
	\   ]
	\ }}
NeoBundleLazy 'lambdalisue/vim-gita', {
	\ 'rev': 'feature/gita-blame-feature',
	\ 'autoload': { 'commands': [ 'Gita' ] }
	\ }
NeoBundleLazy 'lambdalisue/vim-gista', {
	\ 'commands': 'Gista',
	\ 'mappings': '<Plug>',
	\ 'unite_sources': 'gista',
	\ }
NeoBundleLazy 'sjl/gundo.vim', {
	\ 'vim_version': '7.3',
	\ 'autoload': { 'commands': [ 'GundoToggle' ] }
	\ }
NeoBundleLazy 'haya14busa/incsearch.vim', {
	\ 'mappings': '<Plug>(incsearch-'
	\ }
NeoBundleLazy 'terryma/vim-expand-region', {
	\ 'mappings': [[ 'x', '<Plug>' ]]
	\ }
NeoBundleLazy 'tyru/open-browser.vim', {
	\ 'disabled': len($SSH_CLIENT),
	\ 'mappings': '<Plug>',
	\ 'functions': 'openbrowser#open'
	\ }
NeoBundleLazy 'thinca/vim-prettyprint', { 'commands': 'PP' }
NeoBundleLazy 'thinca/vim-quickrun', { 'mappings': '<Plug>' }
NeoBundleLazy 'thinca/vim-ref', { 'unite_sources': 'ref' }
NeoBundleLazy 'itchyny/dictionary.vim', { 'commands': 'Dictionary' }
NeoBundleLazy 'vimwiki/vimwiki', {
	\ 'disabled': len($SSH_CLIENT),
	\ 'rev': 'dev',
	\ 'commands': [
	\   'VimwikiIndex', 'VimwikiTabIndex', 'VimwikiUISelect',
	\   'VimwikiMakeDiaryNote', 'VimwikiTabMakeDiaryNote',
	\   'VimwikiDiaryIndex'
	\ ]}
NeoBundleLazy 'beloglazov/vim-online-thesaurus', {
	\ 'disabled': len($SSH_CLIENT),
	\ 'commands': [
	\   'OnlineThesaurusCurrentWord', 'Thesaurus'
	\ ]}

" }}}
" Interface {{{
" ---------
NeoBundleLazy 'junegunn/goyo.vim', {
	\ 'depends': 'junegunn/limelight.vim',
	\ 'autoload': {
	\   'commands': 'Goyo'
	\ }}
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
	\ 'disabled': ! has('nvim') || len($SSH_CLIENT),
	\ 'insert': 1
	\ }
NeoBundleLazy 'Shougo/neocomplete', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'disabled': ! has('lua') || len($SSH_CLIENT),
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
NeoBundleLazy 'joker1007/unite-pull-request', {
	\ 'disabled': len($SSH_CLIENT),
	\ 'depends': 'mattn/webapi-vim',
	\ 'unite_sources': [ 'pull_request', 'pull_request_file' ]
	\ }
NeoBundleLazy 'Shougo/junkfile.vim', {
	\ 'disabled': len($SSH_CLIENT),
	\ 'unite_sources': 'junkfile'
	\ }
NeoBundleLazy 'rafi/vim-unite-issue', {
	\  'directory': 'unite-issue',
	\  'depends': [ 'mattn/webapi-vim', 'tyru/open-browser.vim' ]
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
