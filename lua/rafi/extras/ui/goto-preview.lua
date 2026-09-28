-- Preview definitions, implementations and references in floats
-- (goto-preview)

local loaded = false
local function load()
	if not loaded then
		loaded = true
		vim.pack.add({ 'https://github.com/rmagatti/goto-preview' })
		require('goto-preview').setup({
			width = 78,
			height = 15,
			default_mappings = false,
			opacity = 10,
			post_open_hook = function(buf, win)
				vim.api.nvim_win_set_config(win, {
					border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
				})
				local scope = { scope = 'local', win = win }
				vim.api.nvim_set_option_value('spell', false, scope)
				vim.api.nvim_set_option_value('signcolumn', 'no', scope)
				-- <Esc> closes the preview. It's mapped on the real file buffer,
				-- so it is removed when the preview closes.
				vim.keymap.set('n', '<Esc>', '<cmd>quit<CR>', { buffer = buf })
				vim.api.nvim_create_autocmd('WinClosed', {
					pattern = tostring(win),
					once = true,
					callback = function()
						pcall(vim.keymap.del, 'n', '<Esc>', { buffer = buf })
					end,
				})
			end,
		})
	end
	return require('goto-preview')
end

-- stylua: ignore start
vim.keymap.set('n', 'gpd', function() load().goto_preview_definition({}) end, { desc = 'Preview definition' })
vim.keymap.set('n', 'gpi', function() load().goto_preview_implementation({}) end, { desc = 'Preview implementation' })
vim.keymap.set('n', 'gpc', function() load().close_all_win() end, { desc = 'Close previews' })
vim.keymap.set('n', 'gpr', function() load().goto_preview_references({}) end, { desc = 'Preview references' })
-- stylua: ignore end
