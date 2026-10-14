-- Soothing pastel theme (catppuccin)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/colorscheme.lua

-- Eager: only adds colors/ to runtimepath, for theme-loader to find.
vim.pack.add({
	{ src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
})

-- Configure right before the colorscheme is first applied. Integrations
-- list only plugins this config can add.
vim.api.nvim_create_autocmd('ColorSchemePre', {
	pattern = 'catppuccin*',
	once = true,
	callback = function()
		require('catppuccin').setup({
			lsp_styles = {
				underlines = {
					errors = { 'undercurl' },
					hints = { 'undercurl' },
					warnings = { 'undercurl' },
					information = { 'undercurl' },
				},
			},
			integrations = {
				alpha = true,
				blink_cmp = true,
				gitsigns = true,
				grug_far = true,
				illuminate = true,
				leap = true,
				lsp_trouble = true,
				mason = true,
				mini = true,
				neotree = true,
				snacks = true,
				telescope = true,
				treesitter_context = true,
				which_key = true,
			},
		})
	end,
})

-- Use catppuccin's bufferline colors while a catppuccin colorscheme is
-- active, and remove them when another one replaces it.
local themed = false

-- Set or clear catppuccin's highlights in bufferline's saved user config.
-- Returns whether bufferline's config was found.
local function sync_bufferline()
	local ok, config = pcall(require, 'bufferline.config')
	local cfg = ok and config.get()
	if not cfg then
		return false
	end
	if (vim.g.colors_name or ''):find('^catppuccin') then
		cfg.user.highlights = require('catppuccin.special.bufferline').get_theme()
		themed = true
	elseif themed then
		cfg.user.highlights = nil
		themed = false
	else
		return true
	end
	return true
end

vim.api.nvim_create_autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('rafi.catppuccin', {}),
	callback = function()
		if package.loaded['bufferline.config'] then
			sync_bufferline()
		end
	end,
})

-- If catppuccin was applied before bufferline loaded, rebuild its colors.
require('rafi.pack').later(function()
	vim.schedule(function()
		if
			package.loaded['bufferline.config']
			and (vim.g.colors_name or ''):find('^catppuccin')
			and sync_bufferline()
		then
			local config = require('bufferline.config')
			require('bufferline.highlights').set_all(config.update_highlights())
		end
	end)
end)
