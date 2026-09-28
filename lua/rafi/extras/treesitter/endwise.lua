-- Wisely add "end" in Ruby, Lua, Vimscript and other languages
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/RRethy/nvim-treesitter-endwise' })
	local endwise = require('nvim-treesitter-endwise')
	-- Endwise autocmd only fires for buffers opened after this point, so
	-- attach any buffer that's already open.
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local ft = vim.bo[buf].filetype
			local lang = ft ~= '' and vim.treesitter.language.get_lang(ft) or nil
			if lang and endwise.is_supported(lang) then
				require('nvim-treesitter.endwise').attach(buf)
			end
		end
	end
end

pack.on_event('BufReadPre,BufNewFile', load)
pack.later(load)
