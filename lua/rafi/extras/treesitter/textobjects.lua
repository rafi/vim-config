-- Tree-sitter textobject motions
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua
local pack = require('rafi.pack')

-- Buffer-local moves, attached where the textobjects query exists.
-- Select and swap are handled by mini.ai and sibling-swap.
local moves = {
	{ ']f', 'goto_next_start', '@function.outer', 'Next Function Start' },
	{ ']c', 'goto_next_start', '@class.outer', 'Next Class Start' },
	{ '],', 'goto_next_start', '@parameter.inner', 'Next Parameter Start' },
	{ ']F', 'goto_next_end', '@function.outer', 'Next Function End' },
	{ ']C', 'goto_next_end', '@class.outer', 'Next Class End' },
	{ ']K', 'goto_next_end', '@parameter.inner', 'Next Parameter End' },
	{ '[f', 'goto_previous_start', '@function.outer', 'Prev Function Start' },
	{ '[c', 'goto_previous_start', '@class.outer', 'Prev Class Start' },
	{ '[,', 'goto_previous_start', '@parameter.inner', 'Prev Parameter Start' },
	{ '[F', 'goto_previous_end', '@function.outer', 'Prev Function End' },
	{ '[C', 'goto_previous_end', '@class.outer', 'Prev Class End' },
	{ '[K', 'goto_previous_end', '@parameter.inner', 'Prev Parameter End' },
}

---@param buf integer
local function attach(buf)
	local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
	if
		not lang
		or not vim.treesitter.language.add(lang)
		or not vim.treesitter.query.get(lang, 'textobjects')
	then
		return
	end
	for _, m in ipairs(moves) do
		local key, method, query = m[1], m[2], m[3]
		vim.keymap.set({ 'n', 'x', 'o' }, key, function()
			if vim.wo.diff and key:find('[cC]') then
				return vim.cmd('normal! ' .. key)
			end
			require('nvim-treesitter-textobjects.move')[method](query, 'textobjects')
		end, { buffer = buf, desc = m[4], silent = true })
	end
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		{
			src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
			version = 'main',
		},
	})
	require('nvim-treesitter-textobjects').setup({
		select = { lookahead = true },
		move = { set_jumps = true },
	})
	vim.api.nvim_create_autocmd('FileType', {
		group = vim.api.nvim_create_augroup('rafi.textobjects', {}),
		callback = function(ev)
			attach(ev.buf)
		end,
	})
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			attach(buf)
		end
	end
end

pack.on_event('BufReadPost,BufNewFile', load)
pack.later(load)
