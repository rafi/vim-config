-- Stylus syntax, indent and completion

-- Its plugin/ is heavy, add on first stylus buffer (Neovim detects the ft).
require('rafi.pack').on_filetype('stylus', function()
	vim.pack.add({ 'https://github.com/iloginow/vim-stylus' })
	-- Re-apply the filetype to source its syntax/indent/ftplugin (scheduled,
	-- FileType doesn't nest).
	local buf = vim.api.nvim_get_current_buf()
	vim.schedule(function()
		if vim.api.nvim_buf_is_valid(buf) then
			vim.bo[buf].filetype = 'stylus'
		end
	end)
end)
