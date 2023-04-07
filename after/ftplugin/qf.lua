-- Quickfix utilities
--

---@param bang boolean
---@return fun():string
local function get_cfilter_expr(bang)
	local bang_text = bang and '!' or ''
	return function()
		local cmd = (vim.fn.win_gettype(0) == 'loclist' and 'L' or 'C') .. 'filter'
		return ':' .. cmd .. bang_text .. '<Space>//<Left>'
	end
end

local function setup_cfilter()
	local opts = { buffer = 0, expr = true }
	vim.keymap.set('n', 'i', get_cfilter_expr(false), opts)
	vim.keymap.set('n', 'r', get_cfilter_expr(true), opts)

	vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '')
		.. (vim.b.undo_ftplugin ~= nil and ' | ' or '')
		.. 'sil! nunmap <buffer> i'
		.. ' | sil! nunmap <buffer> r'
end

if vim.fn.exists(':Lfilter') == 0 then
	vim.cmd.packadd('cfilter')
end

if vim.fn.exists(':Lfilter') > 0 then
	setup_cfilter()
end
