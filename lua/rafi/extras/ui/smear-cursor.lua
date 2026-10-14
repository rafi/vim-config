-- Animates cursor movement with a smear effect (smear-cursor.nvim)
-- Skipped in Neovide, which animates the cursor natively.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ui/smear-cursor.lua
if vim.g.neovide then
	return
end

require('rafi.pack').later(function()
	vim.pack.add({ 'https://github.com/sphamba/smear-cursor.nvim' })
	require('smear_cursor').setup({
		hide_target_hack = true,
		cursor_color = 'none',
	})
end)
