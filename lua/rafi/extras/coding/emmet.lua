-- Expand abbreviations alá emmet
local pack = require('rafi.pack')

-- emmet-vim reads these globals from its own plugin/ftplugin autoload code,
-- so they must exist before the plugin is added. `install_global = 0`
-- disables its automatic `:EmmetInstall` on every filetype, since we call it
-- explicitly below for a smaller filetype list.
vim.g.user_emmet_mode = 'i'
vim.g.user_emmet_install_global = 0
vim.g.user_emmet_install_command = 0
vim.g.user_emmet_complete_tag = 0

local filetypes = 'css,html,javascript,javascriptreact,svelte,vue'

pack.on_filetype(filetypes, function()
	vim.pack.add({ 'https://github.com/mattn/emmet-vim' })

	vim.api.nvim_create_autocmd('FileType', {
		group = vim.api.nvim_create_augroup('rafi.emmet', {}),
		pattern = {
			'css',
			'html',
			'javascript',
			'javascriptreact',
			'svelte',
			'vue',
		},
		callback = function()
			vim.cmd([[
				EmmetInstall
				imap <silent><buffer> <C-y> <Plug>(emmet-expand-abbr)
			]])
		end,
	})
	-- The FileType event that triggered this `on_filetype` already fired
	-- before the autocmd above existed, so re-fire it for that buffer.
	pack.refire_filetype('rafi.emmet')
end)
