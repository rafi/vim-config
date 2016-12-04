
" MENUS
" -----

let s:menus = {}

let s:menus.dein = { 'description': 'Plugin management (rafi/vim-config)' }
let s:menus.dein.command_candidates = [
	\   ['Dein: Plugins update', 'call dein#update()'],
	\   ['Dein: Update log', 'echo dein#get_updates_log()'],
	\   ['Dein: Log', 'echo dein#get_log()'],
	\ ]
let s:menus.files = { 'description': 'File tools (rafi/vim-config)' }
let s:menus.files.command_candidates = [
	\   ['Denite: Find in files…', 'Denite grep:.'],
	\   ['Denite: Find files', 'Denite file_rec'],
	\   ['Denite: Buffers', 'Denite buffer'],
	\   ['Denite: MRU', 'Denite file_mru'],
	\   ['Denite: Line', 'Denite line'],
	\   ['Unite: Bookmarks', 'Unite bookmark'],
	\   ['Unite: Tags', 'Unite tag -start-insert'],
	\   ['Unite: Outline', 'Unite outline'],
	\ ]
let s:menus.settings = {'description': 'Configuration files (rafi/vim-config)'}
let s:menus.settings.file_candidates = [
	\   ['General settings: config/general.vim', $VIMPATH.'/config/general.vim'],
	\   ['Theme: config/theme.vim', $VIMPATH.'/config/theme.vim'],
	\   ['Installed plugins: config/plugins.yaml', $VIMPATH.'/config/plugins.yaml'],
	\   ['Global Key mappings: config/mappings.vim', $VIMPATH.'/config/mappings.vim'],
	\   ['Plugin key-mappings config/plugins/all.vim', $VIMPATH.'/config/plugins/all.vim'],
	\ ]

let s:menus.sessions = { 'description': 'Sessions (rafi/vim-config)' }
let s:menus.sessions.command_candidates = [
	\   ['Restore session', 'Unite session'],
	\   ['Save session…', 'Unite session/new']
	\ ]

call denite#custom#var('menu', 'menus', s:menus)

" vim: set ts=2 sw=2 tw=80 noet :
