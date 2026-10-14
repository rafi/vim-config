-- Animates scrolling, cursor movement and window resizing (mini.animate)
-- Skipped in Neovide, which animates natively.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ui/mini-animate.lua
if vim.g.neovide then
	return
end
local pack = require('rafi.pack')

-- NOTE: Conflict: mini.animate wins over core's <leader>ua when enabled.
-- Re-applied after core keymaps. lua/config/keymaps.lua can still override.
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = function()
		Snacks.toggle({
			name = 'Mini Animate',
			get = function()
				return not vim.g.minianimate_disable
			end,
			set = function(state)
				vim.g.minianimate_disable = not state
			end,
		}):map('<leader>ua')
	end,
})

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/nvim-mini/mini.animate' })

	-- Don't animate scrolling with the mouse.
	local mouse_scrolled = false
	for _, scroll in ipairs({ 'Up', 'Down' }) do
		local key = '<ScrollWheel' .. scroll .. '>'
		vim.keymap.set({ '', 'i' }, key, function()
			mouse_scrolled = true
			return key
		end, { expr = true })
	end

	vim.api.nvim_create_autocmd('FileType', {
		group = vim.api.nvim_create_augroup('rafi.mini-animate', {}),
		pattern = 'grug-far',
		callback = function()
			vim.b.minianimate_disable = true
		end,
	})

	local animate = require('mini.animate')
	require('mini.animate').setup({
		-- ui.smear-cursor animates the cursor when enabled.
		cursor = {
			enable = not require('rafi.config').enabled('ui.smear-cursor'),
		},
		resize = {
			timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),
		},
		scroll = {
			timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
			subscroll = animate.gen_subscroll.equal({
				predicate = function(total_scroll)
					if mouse_scrolled then
						mouse_scrolled = false
						return false
					end
					return total_scroll > 1
				end,
			}),
		},
	})
end

pack.later(load)
