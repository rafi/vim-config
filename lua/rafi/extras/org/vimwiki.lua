-- Personal wiki with markdown syntax in ~/notebook (vimwiki)

vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_use_calendar = 1
vim.g.vimwiki_hl_headers = 1
vim.g.vimwiki_hl_cb_checked = 1
vim.g.vimwiki_autowriteall = 0
vim.g.vimwiki_listsym_rejected = '✗'
vim.g.vimwiki_listsyms = '✗○◐●✓'
vim.g.vimwiki_key_mappings = {
	all_maps = 1,
	global = 1,
	headers = 1,
	text_objs = 1,
	table_format = 1,
	table_mappings = 1,
	lists = 1,
	links = 1,
	html = 1,
	mouse = 0,
}
vim.g.vimwiki_list = {
	{
		diary_header = 'Notebook',
		diary_link_fmt = '%Y-%m/%d',
		auto_toc = 1,
		path = '~/notebook/',
		syntax = 'markdown',
		ext = '.md',
	},
}

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	for _, name in ipairs({ 'VimwikiIndex', 'VimwikiUISelect' }) do
		vim.api.nvim_del_user_command(name)
	end
	vim.pack.add({ 'https://github.com/vimwiki/vimwiki' })
end

-- Stubs until the plugin's plugin/vimwiki.vim defines the real commands.
require('rafi.pack').command({ 'VimwikiIndex', 'VimwikiUISelect' }, load)

-- NOTE: Conflict: org.telekasten and org.zk also map `<leader>zo`.
vim.keymap.set('n', '<leader>zo', function()
	load()
	vim.cmd('VimwikiIndex')
end, { desc = 'Wiki index' })
