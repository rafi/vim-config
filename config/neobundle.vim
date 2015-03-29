
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

NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'bogado/file-line'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'itchyny/vim-cursorword'
NeoBundle 'itchyny/vim-gitbranch'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'MattesGroeger/vim-bookmarks'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'kopischke/vim-stay'
NeoBundle 'regedarek/ZoomWin'  " TODO: Lazy has problems restoring splits

" My own plugins
NeoBundle 'rafi/vim-tinyline', { 'directory': 'tinyline' }
NeoBundle 'rafi/vim-tagabana', { 'directory': 'tagabana' }

" LAZY LOADING from here on
" --------------------------------------------------------

NeoBundleLazy 'rafi/vim-tinycomment', {
	\ 'directory': 'tinycomment',
	\ 'augroup': 'tinycomment',
	\ 'commands': [ 'TinyCommentLines', 'TinyCommentBlock' ],
	\ 'mappings': [
	\   [ 'n', '<leader>v' ], [ 'v', '<leader>v' ],
	\   [ 'v', '<leader>V' ]
	\ ]}
NeoBundleLazy 'rafi/vim-phpspec', {
	\ 'filetypes': 'php',
	\ 'directory': 'phpspec',
	\ 'commands': [ 'PhpSpecRun', 'PhpSpecRunCurrent' ]
	\ }
NeoBundleLazy 'rafi/vim-unite-issue', {
	\  'directory': 'unite-issue',
	\  'depends': [ 'mattn/webapi-vim', 'tyru/open-browser.vim' ]
	\ }

" }}}
" Color-schemes {{{
" -------------
NeoBundleLazy 'chriskempson/base16-vim'
NeoBundleLazy 'romainl/Apprentice'
NeoBundleLazy 'chase/focuspoint-vim'
NeoBundleLazy 'gregsexton/Atom'
NeoBundleLazy 'jonathanfilip/vim-lucius'
NeoBundleLazy 'tomasr/molokai'
NeoBundleLazy 'vim-scripts/pyte'
NeoBundleLazy 'vim-scripts/rdark-terminal2.vim'
NeoBundleLazy 'vim-scripts/twilight256.vim'
NeoBundleLazy 'vim-scripts/wombat256.vim'

" }}}
" Language {{{
" --------
NeoBundleLazy 'othree/html5.vim', { 'filetypes': 'html' }
NeoBundleLazy 'mustache/vim-mustache-handlebars', { 'filetypes': 'html' }
NeoBundleLazy 'rcmdnk/vim-markdown', { 'filetypes': 'markdown' }
NeoBundleLazy 'chase/vim-ansible-yaml', { 'filetypes': 'yaml' }
NeoBundleLazy 'groenewege/vim-less', { 'filetypes': 'less' }
NeoBundleLazy 'hail2u/vim-css3-syntax', { 'filetypes': 'css' }
NeoBundleLazy 'chrisbra/csv.vim', { 'filetypes': 'csv' }
NeoBundleLazy 'hynek/vim-python-pep8-indent', { 'filetypes': 'python' }
NeoBundleLazy 'robbles/logstash.vim', { 'filetypes': 'logstash' }
NeoBundleLazy 'tmux-plugins/vim-tmux', { 'filetypes': 'tmux' }
NeoBundleLazy 'elzr/vim-json', { 'filetypes': 'json' }
NeoBundleLazy 'PotatoesMaster/i3-vim-syntax', { 'filetypes': 'i3' }
NeoBundleLazy 'jamestomasino/vim-writingsyntax', { 'filetypes': 'writing' }
NeoBundleLazy 'fatih/vim-go', {'filetypes': 'go', 'disabled': $SSH_CLIENT}
NeoBundleLazy 'davidhalter/jedi-vim', {
	\ 'disabled': $SSH_CLIENT,
	\ 'filetypes': 'python'
	\ }
NeoBundleLazy 'vim-ruby/vim-ruby', {
	\ 'mappings': '<Plug>',
	\ 'filetypes': 'ruby'
	\ }
NeoBundleLazy 'http://svn.macports.org/repository/macports/contrib/mpvim/', {
	\ 'disabled': $SSH_CLIENT,
	\ 'filetypes': 'portfile'
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
	\   'disabled': ! executable('npm') || $SSH_CLIENT,
	\   'filetypes': 'javascript'
	\ }

" }}}
" PHP {{{
" ---
NeoBundleLazy 'StanAngeloff/php.vim', { 'filetypes': 'php' }
NeoBundleLazy 'rayburgemeestre/phpfolding.vim', { 'filetypes': 'php' }
NeoBundleLazy 'shawncplus/phpcomplete.vim', {
	\ 'disabled': $SSH_CLIENT,
	\ 'insert': 1,
	\ 'filetypes': 'php'
	\ }
NeoBundleLazy 'tobyS/pdv', {
	\ 'disabled': $SSH_CLIENT,
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
	\ 'depends': [
	\   'Shougo/unite.vim',
	\   'Shougo/tabpagebuffer.vim',
	\   'itchyny/unite-preview',
	\   't9md/vim-choosewin'
	\ ],
	\ 'mappings': '<Plug>',
	\ 'explorer': 1,
	\ 'commands': [
	\    { 'name': [ 'VimFiler', 'Edit', 'Write'],
	\      'complete': 'customlist,vimfiler#complete' },
	\    'Read', 'Source'
	\ ]}
NeoBundleLazy 'Shougo/vinarise.vim', {
	\ 'commands': [
	\   { 'name': 'Vinarise', 'complete': 'file' }
	\ ]}
NeoBundleLazy 'scrooloose/syntastic', {
	\ 'disabled': $SSH_CLIENT,
	\ 'autoload': {
	\   'commands': [
	\     'SyntasticCheck', 'SyntasticStatuslineFlag',
	\     'SyntasticToggleMode', 'Errors', 'SyntasticInfo'
	\   ]
	\ }}
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
NeoBundleLazy 'haya14busa/incsearch.vim', {
	\ 'mappings': '<Plug>(incsearch-'
	\ }
NeoBundleLazy 'gorkunov/smartpairs.vim', {
	\ 'autoload': {
	\  'commands': [ 'SmartPairs', 'SmartPairsI', 'SmartPairsA' ],
	\  'mappings': [[ 'n', 'viv', 'vav' ], [ 'v', 'v' ]]
	\ }}
NeoBundleLazy 'farseer90718/vim-colorpicker', {
	\ 'disabled': ! has('python') || $SSH_CLIENT,
	\ 'commands': 'ColorPicker'
	\ }
NeoBundleLazy 't9md/vim-smalls', { 'mappings': '<Plug>' }
NeoBundleLazy 'shime/vim-livedown', {
	\ 'disabled': ! executable('npm') || $SSH_CLIENT,
	\ 'build': { 'others': 'npm install' },
	\ 'commands': [ 'LivedownPreview', 'LivedownKill' ],
	\ 'mappings': [[ 'n', '<Leader>P' ]]
	\ }
NeoBundleLazy 'tyru/open-browser.vim', {
	\ 'disabled': $SSH_CLIENT,
	\ 'mappings': '<Plug>',
	\ 'functions': 'openbrowser#open'
	\ }
NeoBundleLazy 'thinca/vim-prettyprint', { 'commands': 'PP' }
NeoBundleLazy 'thinca/vim-quickrun', { 'mappings': '<Plug>' }
NeoBundleLazy 'thinca/vim-ref', { 'unite_sources': 'ref' }
NeoBundleLazy 'itchyny/dictionary.vim', { 'commands': 'Dictionary' }
NeoBundleLazy 'dhruvasagar/vim-dotoo', {'mappings': [['n', 'gA', 'gC']]}
NeoBundleLazy 'vimwiki/vimwiki', {
	\ 'commands': [
	\   'VimwikiIndex', 'VimwikiTabIndex', 'VimwikiUISelect',
	\   'VimwikiMakeDiaryNote', 'VimwikiTabMakeDiaryNote',
	\   'VimwikiDiaryIndex'
	\ ]}
NeoBundleLazy 'mattn/calendar-vim', {
	\ 'commands': [ 'Calendar', 'CalendarH', 'CalendarT' ],
	\ 'mappings': [[ 'n', '<Leader>cal', '<Leader>caL' ]]
	\ }
NeoBundleLazy 'beloglazov/vim-online-thesaurus', {
	\ 'commands': [
	\   'OnlineThesaurusCurrentWord', 'Thesaurus'
	\ ]}
NeoBundleLazy 'itchyny/vim-closebuffer', {
	\ 'insert': 1,
	\ 'mappings': '<Plug>'
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
NeoBundleLazy 'Yggdroot/indentLine', { 'filetypes': 'all' }
NeoBundleLazy 'xolox/vim-session', {
	\ 'disabled': $SSH_CLIENT,
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
NeoBundleLazy 'kana/vim-smartchr', { 'insert': 1 }
NeoBundleLazy 'Shougo/neocomplete', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'disabled': ! has('lua') || $SSH_CLIENT,
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
NeoBundleLazy 'Kocha/vim-unite-tig'
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
	\ 'disabled': $SSH_CLIENT,
	\ 'depends': 'mattn/webapi-vim',
	\ 'unite_sources': [ 'pull_request', 'pull_request_file' ]
	\ }
NeoBundleLazy 'Shougo/junkfile.vim', {
	\ 'disabled': $SSH_CLIENT,
	\ 'unite_sources': 'junkfile'
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
	\ 'autoload': {
	\   'mappings': [[ 'ox', '<Plug>' ]]
	\ }}
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
