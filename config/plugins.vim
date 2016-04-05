
" Plugins
" --------------------------------------------------------

" Loaded on startup {{{
" ---
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
call dein#add('christoomey/vim-tmux-navigator')
call dein#add('itchyny/vim-cursorword')
call dein#add('itchyny/vim-gitbranch')
call dein#add('itchyny/vim-parenmatch')
call dein#add('thinca/vim-localrc')
call dein#add('rafi/vim-tagabana')
call dein#add('bogado/file-line')
call dein#add('rafi/vim-blocks')

" LAZY LOADING
" --------------------------------------------------------

" Fetch repositories, but don't add them to runtimepath
call dein#add('chriskempson/base16-shell', {'rtp': ''})
call dein#add('rafi/awesome-vim-colorschemes', {'rtp': ''})
call dein#add('Shougo/neosnippet-snippets', {'rtp': ''})

" }}}
" Language {{{
" --------
call dein#add('othree/html5.vim', {'on_ft': 'html'})
call dein#add('mustache/vim-mustache-handlebars', {'on_ft': 'html'})
call dein#add('rcmdnk/vim-markdown', {'on_ft': 'markdown'})
call dein#add('chase/vim-ansible-yaml', {'on_ft': ['yaml', 'ansible']})
call dein#add('mitsuhiko/vim-jinja', {'on_ft': ['htmljinja', 'jinja']})
call dein#add('groenewege/vim-less', {'on_ft': 'less'})
call dein#add('hail2u/vim-css3-syntax', {'on_ft': 'css'})
call dein#add('othree/csscomplete.vim', {'on_ft': 'css'})
call dein#add('chrisbra/csv.vim', {'on_ft': 'csv'})
call dein#add('hynek/vim-python-pep8-indent', {'on_ft': 'python'})
call dein#add('tmux-plugins/vim-tmux', {'on_ft': 'tmux'})
call dein#add('cespare/vim-toml', {'on_ft': 'toml'})
call dein#add('PotatoesMaster/i3-vim-syntax', {'on_ft': 'i3'})
call dein#add('ekalinin/Dockerfile.vim', {'on_ft': 'Dockerfile'})
call dein#add('jstrater/mpvim', {'on_ft': 'portfile'})
call dein#add('fatih/vim-go', {'on_ft': 'go'})
call dein#add('elzr/vim-json', {'on_ft': 'json'})
call dein#add('StanAngeloff/php.vim', {'on_ft': 'php'})
call dein#add('osyo-manga/vim-monster', {'on_ft': 'ruby'})
call dein#add('othree/yajs.vim', {'on_ft': 'javascript'})
call dein#add('gavocanov/vim-js-indent', {'on_ft': 'javascript'})
call dein#add('othree/javascript-libraries-syntax.vim', {'on_ft': 'javascript'})
call dein#add('othree/jspc.vim', {'on_ft': 'javascript'})
call dein#add('heavenshell/vim-jsdoc', {'on_ft': 'javascript'})
call dein#add('moll/vim-node', {'on_ft': 'javascript'})

" }}}
" Commands {{{
" --------
call dein#add('Shougo/vimfiler.vim', {
	\ 'depends': 'unite.vim',
	\ 'on_map': [['n', '<Plug>']],
	\ 'on_path': '.*',
	\ })

call dein#add('tyru/caw.vim', {'on_map': [['nx', '<Plug>']]})
call dein#add('lambdalisue/vim-gita', {'on_cmd': 'Gita'})
call dein#add('t9md/vim-choosewin', {'on_map': [['n', '<Plug>']]})
call dein#add('haya14busa/vim-asterisk', {'on_map': [['n', '<Plug>']]})
call dein#add('haya14busa/incsearch.vim', {'on_map': [['n', '<Plug>']]})
call dein#add('mbbill/undotree', {'on_cmd': 'UndotreeToggle'})
call dein#add('Shougo/vinarise.vim', {'on_cmd': 'Vinarise'})

if $VIM_MINIMAL ==? ''
	call dein#add('guns/xterm-color-table.vim', {'on_cmd': 'XtermColorTable'})
	call dein#add('itchyny/dictionary.vim', {'on_cmd': 'Dictionary'})
	call dein#add('thinca/vim-prettyprint', {'on_cmd': 'PP', 'on_func': 'PP'})
	call dein#add('beloglazov/vim-online-thesaurus', {
		\ 'on_cmd': ['OnlineThesaurusCurrentWord', 'Thesaurus']})
	call dein#add('junegunn/limelight.vim', {'lazy': 1})
	call dein#add('junegunn/goyo.vim', {
		\ 'depends': 'limelight.vim',
		\ 'on_cmd': 'Goyo'
		\ })
	call dein#add('lambdalisue/vim-gista', {
		\ 'on_cmd': 'Gista',
		\ 'on_map': [['n', '<Plug>']],
		\ 'on_source': 'unite.vim'
		\ })
	call dein#add('vimwiki/vimwiki', {
		\ 'on_cmd': [
		\   'VimwikiIndex', 'VimwikiTabIndex', 'VimwikiUISelect',
		\   'VimwikiMakeDiaryNote', 'VimwikiTabMakeDiaryNote',
		\   'VimwikiDiaryIndex'
		\ ]})
endif

" }}}
" Interface {{{
" ---------
call dein#add('airblade/vim-gitgutter', {'on_path': '.*'})
call dein#add('kshenoy/vim-signature', {'on_path': '.*'})
call dein#add('nathanaelkane/vim-indent-guides', {'on_path': '.*'})
call dein#add('kana/vim-niceblock', {'on_map': [['x', '<Plug>']]})
call dein#add('rhysd/accelerated-jk', {'on_map': [['n', '<Plug>']]})
call dein#add('rhysd/clever-f.vim', {'on_map': [['n', 'f', 'F', 't', 'T']]})
call dein#add('Konfekt/FastFold', {'on_path': '.*'})
call dein#add('Shougo/tabpagebuffer.vim', {'on_ft': 'all'})
call dein#add('rhysd/committia.vim', {'on_path': 'COMMIT_EDITMSG'})

" }}}
" Completion {{{
" ----------
call dein#add('Shougo/deoplete.nvim', {
	\ 'depends': 'context_filetype.vim',
	\ 'if': 'has("nvim")',
	\ 'on_i': 1
	\ })
call dein#add('Shougo/neocomplete', {
	\ 'depends': 'context_filetype.vim',
	\ 'if': '! has("nvim") && has("lua")',
	\ 'on_i': 1
	\ })
call dein#add('Shougo/neosnippet.vim', {
	\ 'depends': ['neosnippet-snippets', 'context_filetype.vim'],
	\ 'on_i': 1,
	\ 'on_ft': 'snippet',
	\ 'on_source': 'unite.vim'
	\ })
call dein#add('Shougo/echodoc.vim', {'on_i': 1})
call dein#add('Shougo/neopairs.vim', {'on_i': 1})
call dein#add('Shougo/context_filetype.vim', {'lazy': 1})
call dein#add('Raimondi/delimitMate', {'on_i': 1})

if $VIM_MINIMAL ==? ''
	call dein#add('Shougo/neco-vim', {'on_ft': 'vim', 'on_i': 1})
	call dein#add('Shougo/neco-syntax', {'on_i': 1})
	call dein#add('Shougo/neoinclude.vim', {'on_ft': 'all'})
	call dein#add('davidhalter/jedi-vim', {'on_ft': 'python'})
	if has('nvim')
		call dein#add('benekastah/neomake', {'on_cmd': 'Neomake'})
		call dein#add('zchee/deoplete-go', {'on_ft': 'go', 'on_i': 1})
		call dein#add('zchee/deoplete-jedi', {'on_ft': 'python', 'on_i': 1})
		call dein#add('carlitux/deoplete-ternjs', {
			\ 'if': 'executable("tern")',
			\ 'on_ft': 'javascript',
			\ 'on_i': 1
			\ })
	else
		call dein#add('shawncplus/phpcomplete.vim', {'on_i': 1, 'on_ft': 'php'})
		call dein#add('ternjs/tern_for_vim', {
			\ 'build': {'others': 'npm install'},
			\ 'if': 'executable("npm")',
			\ 'on_i': 1,
			\ 'on_ft': 'javascript'
			\ })
	endif
endif

" }}}
" Unite {{{
" -----
call dein#add('Shougo/unite.vim', {'depends': 'neomru.vim', 'lazy': 1})
call dein#add('Shougo/neomru.vim', {'lazy': 1})

" Unite sources {{{
" -------------
call dein#add('Shougo/neossh.vim', {'on_ft': 'vimfiler', 'sources': 'ssh'})
call dein#add('Shougo/unite-build', {'on_source': 'unite.vim'})
call dein#add('Shougo/unite-outline', {'on_source': 'unite.vim'})
call dein#add('Shougo/junkfile.vim', {'on_source': 'unite.vim'})
call dein#add('ujihisa/unite-colorscheme', {'on_source': 'unite.vim'})
call dein#add('osyo-manga/unite-filetype', {'on_source': 'unite.vim'})
call dein#add('tacroe/unite-mark', {'on_source': 'unite.vim'})
call dein#add('tsukkee/unite-tag', {'on_source': 'unite.vim'})
call dein#add('thinca/vim-unite-history', {'on_source': 'unite.vim'})
call dein#add('osyo-manga/unite-quickfix', {'on_source': 'unite.vim'})
call dein#add('rafi/vim-unite-issue', {
	\ 'depends': 'webapi-vim',
	\ 'on_source': 'unite.vim'
	\ })
call dein#add('joker1007/unite-pull-request', {
	\ 'depends': 'webapi-vim',
	\ 'on_source': 'unite.vim'
	\ })
call dein#add('mattn/webapi-vim', {'lazy': 1})
" }}}

" }}}
" Operators {{{
" ---------
call dein#add('kana/vim-operator-user', {'lazy': 1})
call dein#add('kana/vim-operator-replace', {
	\ 'depends': 'vim-operator-user',
	\ 'on_map': [['nx', '<Plug>']]
	\ })
call dein#add('rhysd/vim-operator-surround', {
	\ 'depends': 'vim-operator-user',
	\ 'on_map': [['n', '<Plug>']]
	\ })
call dein#add('haya14busa/vim-operator-flashy', {
	\ 'depends': 'vim-operator-user',
	\ 'on_map': [['nx', '<Plug>']]
	\ })

" }}}
" Text objects {{{
" ------------
call dein#add('kana/vim-textobj-user', {'lazy': 1})
call dein#add('osyo-manga/vim-textobj-multiblock', {
	\ 'depends': 'vim-textobj-user',
	\ 'on_map': [['ox', '<Plug>']]
	\ })
call dein#add('AndrewRadev/sideways.vim', {'on_map': [['ox', '<Plug>']]})
call dein#add('bkad/CamelCaseMotion', {
	\ 'on_map': [['n', '<Plug>CamelCaseMotion']]
	\ })
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
