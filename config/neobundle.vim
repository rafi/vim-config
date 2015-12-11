
" Plugins with NeoBundle
"---------------------------------------------------------

" Always loaded {{{
" -------------
NeoBundle 'Shougo/vimproc.vim', {'build' : 'make'}
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

" LAZY LOADING from here on!
" --------------------------------------------------------

" Fetch repositories, but don't add to runtimepath
NeoBundleFetch 'chriskempson/base16-shell'
NeoBundleFetch 'rafi/awesome-vim-colorschemes'

" }}}
" Language {{{
" --------
NeoBundleLazy 'othree/html5.vim', {'on_ft': 'html'}
NeoBundleLazy 'mustache/vim-mustache-handlebars', {'on_ft': 'html'}
NeoBundleLazy 'rcmdnk/vim-markdown', {'on_ft': 'markdown'}
NeoBundleLazy 'chase/vim-ansible-yaml', {'on_ft': ['yaml', 'ansible']}
NeoBundleLazy 'mitsuhiko/vim-jinja', {'on_ft': ['htmljinja', 'jinja']}
NeoBundleLazy 'groenewege/vim-less', {'on_ft': 'less'}
NeoBundleLazy 'hail2u/vim-css3-syntax', {'on_ft': 'css'}
NeoBundleLazy 'chrisbra/csv.vim', {'on_ft': 'csv'}
NeoBundleLazy 'hynek/vim-python-pep8-indent', {'on_ft': 'python'}
NeoBundleLazy 'robbles/logstash.vim', {'on_ft': 'logstash'}
NeoBundleLazy 'tmux-plugins/vim-tmux', {'on_ft': 'tmux'}
NeoBundleLazy 'elzr/vim-json', {'on_ft': 'json'}
NeoBundleLazy 'cespare/vim-toml', {'on_ft': 'toml'}
NeoBundleLazy 'PotatoesMaster/i3-vim-syntax', {'on_ft': 'i3'}
NeoBundleLazy 'ekalinin/Dockerfile.vim', {'on_ft': 'Dockerfile'}
NeoBundleLazy 'jstrater/mpvim', {'on_ft': 'portfile'}
NeoBundleLazy 'vim-ruby/vim-ruby', {'on_ft': 'ruby', 'on_map': '<Plug>'}
NeoBundleLazy 'jelera/vim-javascript-syntax', {'on_ft': 'javascript'}
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {'on_ft': 'javascript'}
NeoBundleLazy 'StanAngeloff/php.vim', {'on_ft': 'php'}
NeoBundleLazy 'rayburgemeestre/phpfolding.vim', {'on_ft': 'php'}
NeoBundleLazy 'rafi/vim-phpspec', {
	\ 'on_ft': 'php',
	\ 'on_cmd': ['PhpSpecRun', 'PhpSpecRunCurrent']
	\ }
NeoBundleLazy 'fatih/vim-go', {
	\ 'on_ft': 'go',
	\ 'on_cmd': ['GoInstallBinaries', 'GoUpdateBinaries']
	\ }

" }}}
" Commands {{{
" --------
NeoBundleLazy 'Shougo/vimfiler.vim', {
	\ 'depends': 'Shougo/unite.vim',
	\ 'on_map': '<Plug>',
	\ 'on_path': '.*',
	\ 'on_cmd': [
	\    {'name': ['VimFiler'], 'complete': 'customlist,vimfiler#complete'}
	\ ]}
NeoBundleLazy 'tyru/caw.vim', {'on_map': '<Plug>'}
NeoBundleLazy 'lambdalisue/vim-findent', {'on_path': '.*'}
NeoBundleLazy 'lambdalisue/vim-gita', {'on_cmd': 'Gita'}
NeoBundleLazy 't9md/vim-choosewin', {'on_map': '<Plug>(choosewin)'}
NeoBundleLazy 'haya14busa/vim-asterisk', {'on_map': '<Plug>(asterisk-'}
NeoBundleLazy 'haya14busa/incsearch.vim', {'on_map': '<Plug>(incsearch-'}
NeoBundleLazy 'mbbill/undotree', {'on_cmd': 'UndotreeToggle'}
NeoBundleLazy 'Shougo/vinarise.vim', {
	\ 'on_cmd': [{'name': 'Vinarise', 'complete': 'file'}]}
NeoBundleLazy 'terryma/vim-expand-region', {
	\ 'on_map': [['x', '<Plug>']]
	\ }
NeoBundleLazy 'rafi/vim-tinycomment', {
	\ 'augroup': 'tinycomment',
	\ 'on_cmd': ['TinyCommentLines', 'TinyCommentBlock'],
	\ 'on_map': [['n', '<leader>v'], ['v', '<leader>v'], ['v', '<leader>V']]}

if $VIM_MINIMAL ==? ''
	NeoBundleLazy 'lambdalisue/vim-gista', {
		\ 'on_cmd': 'Gista',
		\ 'on_map': '<Plug>',
		\ 'on_unite': 'gista',
		\ }
	NeoBundleLazy 'thinca/vim-guicolorscheme', {'on_cmd': 'GuiColorScheme'}
	NeoBundleLazy 'guns/xterm-color-table.vim', {'on_cmd': 'XtermColorTable'}
	NeoBundleLazy 'thinca/vim-quickrun', {'on_map': '<Plug>'}
	NeoBundleLazy 'itchyny/dictionary.vim', {'on_cmd': 'Dictionary'}
	NeoBundleLazy 'thinca/vim-prettyprint', {'on_cmd': 'PP', 'on_func': 'PP'}
	NeoBundleLazy 'beloglazov/vim-online-thesaurus', {
		\ 'on_cmd': ['OnlineThesaurusCurrentWord', 'Thesaurus']}
	NeoBundleLazy 'junegunn/goyo.vim', {
		\ 'depends': 'junegunn/limelight.vim',
		\ 'on_cmd': 'Goyo'
		\ }
	NeoBundleLazy 'vimwiki/vimwiki', {
		\ 'on_cmd': [
		\   'VimwikiIndex', 'VimwikiTabIndex', 'VimwikiUISelect',
		\   'VimwikiMakeDiaryNote', 'VimwikiTabMakeDiaryNote',
		\   'VimwikiDiaryIndex'
		\ ]}
endif

" }}}
" Interface {{{
" ---------
NeoBundleLazy 'matchit.zip', {'on_map': [['nxo', '%', 'g%']]}
NeoBundleLazy 'kana/vim-niceblock', {'on_map': '<Plug>'}
NeoBundleLazy 'rhysd/accelerated-jk', {'on_map': '<Plug>'}
NeoBundleLazy 'rhysd/clever-f.vim', {'on_map': [['n', 'f', 'F', 't', 'T']]}
NeoBundleLazy 'Konfekt/FastFold', {'on_path': '.*'}

" }}}
" Completion {{{
" ----------
NeoBundleLazy 'Shougo/deoplete.nvim', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'disabled': ! has('nvim'),
	\ 'on_i': 1
	\ }
NeoBundleLazy 'Shougo/neocomplete', {
	\ 'depends': 'Shougo/context_filetype.vim',
	\ 'disabled': ! has('lua') || has('nvim'),
	\ 'vim_version': '7.3.885',
	\ 'on_i': 1
	\ }
NeoBundleLazy 'Shougo/neosnippet.vim', {
	\ 'depends': ['Shougo/neosnippet-snippets', 'Shougo/context_filetype.vim'],
	\ 'on_i': 1,
	\ 'on_ft': 'snippet',
	\ 'on_unite': ['neosnippet', 'neosnippet/user', 'neosnippet/runtime']}
NeoBundleLazy 'Raimondi/delimitMate', {'on_i': 1}
NeoBundleLazy 'Shougo/echodoc.vim', {'on_i': 1}
NeoBundleLazy 'Shougo/neco-vim', {'on_ft': 'vim', 'on_i': 1}
NeoBundleLazy 'Shougo/neco-syntax', {'on_i': 1}
NeoBundleLazy 'Shougo/neopairs.vim', {'on_i': 1}
NeoBundleLazy 'Shougo/neoinclude.vim', {'on_ft': 'all'}

if $VIM_MINIMAL ==? ''
	NeoBundleLazy 'benekastah/neomake', {'on_cmd': ['Neomake']}
	NeoBundleLazy 'davidhalter/jedi-vim', {'on_ft': 'python'}
	NeoBundleLazy 'shawncplus/phpcomplete.vim', {'on_i': 1, 'on_ft': 'php'}
	NeoBundleLazy 'ternjs/tern_for_vim', {
		\ 'build': {'others': 'npm install'},
		\ 'disabled': ! executable('npm'),
		\ 'on_i': 1,
		\ 'on_ft': 'javascript'
		\ }
endif

" }}}
" Unite {{{
" -----
NeoBundleLazy 'Shougo/unite.vim', {
	\ 'depends': 'Shougo/tabpagebuffer.vim',
	\ 'on_cmd': [
	\   {'name': 'Unite', 'complete': 'customlist,unite#complete_source'}
	\ ]}

" Unite sources {{{
" -------------
NeoBundleLazy 'ujihisa/unite-colorscheme'
NeoBundleLazy 'osyo-manga/unite-filetype'
NeoBundleLazy 'thinca/vim-unite-history'
NeoBundleLazy 'Shougo/unite-build'
NeoBundleLazy 'Shougo/unite-outline'
NeoBundleLazy 'tacroe/unite-mark'
NeoBundleLazy 'Shougo/junkfile.vim', {'on_unite': 'junkfile'}
NeoBundleLazy 'Shougo/neossh.vim', {'on_ft': 'vimfiler', 'sources': 'ssh'}
NeoBundleLazy 'tsukkee/unite-tag', {
	\ 'on_unite': ['tag', 'tag/file', 'tag/include']
	\ }
NeoBundleLazy 'osyo-manga/unite-quickfix', {
	\ 'on_unite': ['quickfix', 'location_list']
	\ }

if $VIM_MINIMAL ==? ''
	NeoBundleLazy 'rafi/vim-unite-issue', {'depends': 'mattn/webapi-vim'}
	NeoBundleLazy 'joker1007/unite-pull-request', {
		\ 'depends': 'mattn/webapi-vim',
		\ 'on_unite': ['pull_request', 'pull_request_file']
		\ }
endif
" }}}

" }}}
" Operators {{{
" ---------
NeoBundleLazy 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-operator-replace', {
	\ 'depends': 'vim-operator-user',
	\ 'on_map': [['nx', '<Plug>']]
	\ }
NeoBundleLazy 'rhysd/vim-operator-surround', {
	\ 'depends': 'vim-operator-user',
	\ 'on_map': '<Plug>'
	\ }

" }}}
" Text objects {{{
" ------------
NeoBundleLazy 'kana/vim-textobj-user'
NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', {
	\ 'depends': 'vim-textobj-user',
	\ 'on_map': [['ox', '<Plug>']]
	\ }
NeoBundleLazy 'AndrewRadev/sideways.vim', {'on_map': [['ox', '<Plug>']]}
NeoBundleLazy 'bkad/CamelCaseMotion', {
	\ 'on_map': ['<Plug>CamelCaseMotion_w', '<Plug>CamelCaseMotion_b']
	\ }
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
