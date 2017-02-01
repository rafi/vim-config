
" MENUS
" -----

let s:menus = {}

let s:menus.dein = { 'description': 'Plugin management (rafi/vim-config)' }
let s:menus.dein.command_candidates = [
	\   ['  Project Tools        │ Key Mapping', ''],
	\   ['───────────────────────┼──────────────', ''],
	\   ['▶ Dein: Plugins update │', 'call dein#update()'],
	\   ['▶ Denite: Dein Log     │ ;n', 'Denite dein -no-quit'],
	\   ['▶ Dein: Update log     │', 'echo dein#get_updates_log()'],
	\   ['▶ Dein: Log            │', 'echo dein#get_log()'],
	\   ['───────────────────────┴──────────────', '']
	\ ]

let s:menus.project = { 'description': 'Project & structure (rafi/vim-config)' }
let s:menus.project.command_candidates = [
	\   ['  Project Tools │ Key Mapping', ''],
	\   ['────────────────┼──────────────', ''],
	\   ['▶ Explorer      │ ;e',          'VimFiler'],
	\   ['▶ Outline       │ <Leader>o',   'TagbarToggle'],
	\   ['▶ Git Status    │ <Leader>gs',  'Gita status'],
	\   ['▶ Bookmarks     │ ma',          'Bookmarks'],
	\   ['▶ Undo Tree     │ <Leader>un',  'UndotreeToggle'],
	\   ['────────────────┴──────────────', '']
	\ ]

let s:menus.files = { 'description': 'File tools (rafi/vim-config)' }
let s:menus.files.command_candidates = [
	\   ['  File Tools                │ Key Mapping', ''],
	\   ['────────────────────────────┼──────────────', ''],
	\   ['▶ Denite: Find in files…    │ ;g',  'Denite grep:.'],
	\   ['▶ Denite: Find files        │ ;f',  'Denite file_rec'],
	\   ['▶ Denite: Buffers           │ ;b',  'Denite buffer'],
	\   ['▶ Denite: MRU               │',  'Denite file_old'],
	\   ['▶ Denite: Line              │ ;/',  'Denite line'],
	\   ['────────────────────────────┴──────────────', '']
	\ ]

let s:menus.tools = { 'description': 'Tools (rafi/vim-config)' }
let s:menus.tools.command_candidates = [
	\   ['  Tools              │ Key Mapping', ''],
	\   ['─────────────────────┼──────────────', ''],
	\   ['▶ Git commands       │', 'Gita'],
	\   ['▶ Gists              │', 'Gista'],
	\   ['▶ Check Syntax       │', 'Noemake'],
	\   ['▶ Goyo               │', 'Goyo'],
	\   ['▶ List marks         │', 'Denite marks'],
	\   ['▶ Dictionary         │', 'Dictionary'],
	\   ['▶ Thesaurus          │', 'Thesaurus'],
	\   ['▶ Xterm color-table  │', 'XtermColorTable'],
	\   ['▶ Hex editor         │', 'Vinarise'],
	\   ['▶ Tag-bar            │', 'TagbarToggle'],
	\   ['▶ File explorer      │', 'VimFiler'],
	\   ['▶ Codi (python)      │', 'Codi python'],
	\   ['─────────────────────┴──────────────', '']
	\ ]

let s:menus.sessions = { 'description': 'Sessions (rafi/vim-config)' }
let s:menus.sessions.command_candidates = [
	\   ['  Tools           │ Key Mapping', ''],
	\   ['──────────────────┼──────────────', ''],
	\   ['▶ Restore session │ ;s', 'Denite session'],
	\   ['▶ Save session…   │', 'Denite session/new'],
	\   ['──────────────────┴──────────────', '']
	\ ]

let s:menus.settings = {'description': 'Configuration files (rafi/vim-config)'}
let s:menus.settings.file_candidates = [
	\   ['  Configuration Files                         │', ''],
	\   ['──────────────────────────────────────────────┤', ''],
	\   ['▶ General settings: config/general.vim        │', $VIMPATH.'/config/general.vim'],
	\   ['▶ Theme: config/theme.vim                     │', $VIMPATH.'/config/theme.vim'],
	\   ['▶ Installed plugins: config/plugins.yaml      │', $VIMPATH.'/config/plugins.yaml'],
	\   ['▶ Global Key mappings: config/mappings.vim    │', $VIMPATH.'/config/mappings.vim'],
	\   ['▶ Plugin key-mappings config/plugins/all.vim  │', $VIMPATH.'/config/plugins/all.vim'],
	\   ['──────────────────────────────────────────────┘', '']
	\ ]

let s:menus.wiki = { 'description': 'Wiki (rafi/vim-config)' }
let s:menus.wiki.command_candidates = [
	\   ['  Vimwiki Tools              │ Key Mapping', ''],
	\   ['─────────────────────────────┼─────────────────────────────', ''],
	\   ['▶ Page: Index                │ <Leader>ww', 'VimwikiIndex'],
	\   ['▶ Page: Index (Tab)          │ <Leader>wt', 'VimwikiTabIndex'],
	\   ['▶ Page: Delete current page  │ <Leader>wd', 'VimwikiDeleteLink'],
	\   ['▶ Page: Rename current page  │ <Leader>wr', 'VimwikiRenameLink'],
	\   ['▶ Diary Index                │ <Leader>wi', 'VimwikiDiaryIndex'],
	\   ['▶ Diary Note                 │ <Leader>w<Leader>w', 'VimwikiMakeDiaryNote'],
	\   ['▶ Diary Note (Tab)           │ <Leader>w<Leader>t', 'VimwikiTabMakeDiaryNote'],
	\   ['▶ Diary Note: Yesterday      │ <Leader>w<Leader>y', 'VimwikiMakeYesterdayDiaryNote'],
	\   ['▶ Open previous day''s diary  │ <C-Up>', '<Plug>VimwikiDiaryPrevDay'],
	\   ['▶ Open next day''s diary      │ <C-Down>', '<Plug>VimwikiDiaryNextDay'],
	\   ['▶ Select Wiki…               │ <Leader>ws', 'VimwikiUISelect'],
	\   ['─────────────────────────────┼─────────────────────────────', ''],
	\   ['▶ Convert to HTML            │ <Leader>wh', 'Vimwiki2HTML'],
	\   ['▶ Convert to HTML & Open     │ <Leader>whh', 'Vimwiki2HTMLBrowse'],
	\   ['─────────────────────────────┼─────────────────────────────', ''],
	\   ['▶ Diary: Update index links  │ <Leader>w<Leader>i', 'VimwikiDiaryGenerateLinks'],
	\   ['▶ Follow/create link         │ <CR>', 'VimwikiFollowLink'],
	\   ['▶ Split & follow link        │ <S-CR>', 'VimwikiSplitLink'],
	\   ['▶ Vert-Split & follow link   │ <C-CR>', 'VimwikiVSplitLink'],
	\   ['▶ New Tab and follow link    │ <C-S-CR>', 'VimwikiTabnewLink'],
	\   ['▶ Go back                    │ <Backspace>', 'VimwikiGoBackLink'],
	\   ['▶ Go to next link            │ <Tab>', 'VimwikiNextLink'],
	\   ['▶ Go to previous link        │ <S-Tab>', 'VimwikiPrevLink'],
	\   ['─────────────────────────────┼─────────────────────────────', ''],
	\   ['▶ Add header level           │ =', '<Plug>VimwikiAddHeaderLevel'],
	\   ['▶ Remove header level        │ -', '<Plug>VimwikiRemoveHeaderLevel'],
	\   ['▶ Create & decorate links    │ +', '<Plug>VimwikiNormalizeLink'],
	\   ['▶ Toggle List Item           │ <C-Space>', 'VimwikiToggleListItem'],
	\   ['▶ Remove checkbox item       │ gl<Space>', '<Plug>VimwikiRemoveSingleCB'],
	\   ['▶ Increase list item level   │ gll', '<Plug>VimwikiIncreaseLvlSingleItem'],
	\   ['▶ Decrease list item level   │ glh', '<Plug>VimwikiDecreaseLvlSingleItem'],
	\   ['▶ Renumber list items        │ glr', '<Plug>VimwikiRenumberList'],
	\   ['─────────────────────────────┼─────────────────────────────', ''],
	\   ['▶ Format table               │ gqq', ''],
	\   ['▶ Move column to the left    │ <A-Left>', '<Plug>VimwikiTableMoveColumnLeft'],
	\   ['▶ Move column to the right   │ <A-Left>', '<Plug>VimwikiTableMoveColumnRight'],
	\   ['─────────────────────────────┴─────────────────────────────', '']
	\ ]

call denite#custom#var('menu', 'menus', s:menus)

" vim: set ts=2 sw=2 tw=80 noet :
