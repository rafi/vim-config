-- General-purpose motion plugin for fast cursor movement
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/leap.lua
vim.pack.add({ 'https://codeberg.org/andyg/leap.nvim' })

-- Jump
vim.keymap.set({ 'n', 'x', 'o' }, 'ss', '<Plug>(leap)')
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

-- Visit (jump - operate - jump back)
-- vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-visit)')
-- vim.keymap.set({ 'n', 'x', 'o' }, 'gS', '<Plug>(leap-visit-linewise)')
-- vim.keymap.set({ 'x', 'o' },      'ar', '<Plug>(leap-visit-text-object)')
-- vim.keymap.set({ 'x', 'o' },      'ir', '<Plug>(leap-visit-inner-text-object)')
-- vim.keymap.set({ 'o' },           'rr', '<Plug>(leap-visit-line)')
-- local leap = require("leap")
-- for k, v in pairs(opts) do
-- 	leap.opts[k] = v
-- end
-- leap.add_default_mappings(true)
-- vim.keymap.del({ "x", "o" }, "x")
-- vim.keymap.del({ "x", "o" }, "X")
do
	local function ft(kwargs)
		require('leap').leap(vim.tbl_deep_extend('keep', kwargs, {
			inputlen = 1,
			inclusive = true,
			opts = {
				-- Force autojump.
				labels = '',
				-- Match the modes where you don't need labels (`:h mode()`).
				safe_labels = vim.fn.mode(1):match('no?') and '' or nil,
			},
		}))
	end

	-- A helper function making it easier to set "clever-f" behavior
	-- (using f/F or t/T instead of ;/, - see the plugin clever-f.vim).
	-- Memoized on first use, so leap's modules aren't required at startup.
	local clever = {}
	local function traversal(fwd, bwd)
		if not clever[fwd] then
			clever[fwd] = require('leap.user').with_traversal_keys(fwd, bwd)
		end
		return clever[fwd]
	end

	vim.keymap.set({ 'n', 'x', 'o' }, 'f', function()
		ft({ opts = traversal('f', 'F') })
	end)
	vim.keymap.set({ 'n', 'x', 'o' }, 'F', function()
		ft({ backward = true, opts = traversal('f', 'F') })
	end)
	vim.keymap.set({ 'n', 'x', 'o' }, 't', function()
		ft({ offset = -1, opts = traversal('t', 'T') })
	end)
	vim.keymap.set({ 'n', 'x', 'o' }, 'T', function()
		ft({ backward = true, offset = 1, opts = traversal('t', 'T') })
	end)
end
