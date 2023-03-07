-- List utilities
-- https://github.com/rafi/vim-config

local M = {}

local lists = {
	quickfix = {
		cmd_open = 'botright copen',
		cmd_close = 'cclose',
	},
	loclist = {
		cmd_open = 'botright lopen',
		cmd_close = 'lclose',
	},
}

-- QFLT_QUICKFIX Quickfix list - global list
----

function M.open_qflist()
	vim.api.nvim_command(lists.quickfix.cmd_open)
end

function M.close_qflist()
	vim.api.nvim_command(lists.quickfix.cmd_close)
end

function M.toggle_qflist()
	M.toggle('quickfix')
end

-- QFLT_LOCATION Location list - per window list
----

function M.open_loclist()
	vim.api.nvim_command(lists.loclist.cmd_open)
end

function M.close_loclist()
	vim.api.nvim_command(lists.loclist.cmd_close)
end

function M.toggle_loclist()
	M.toggle('loclist')
end

-- Private
----

-- Toggle list window
---@private
---@param name "quickfix" | "loclist"
M.toggle = function(name)
	local win_bufs = M._get_tabpage_win_bufs(0)
	for win, buf in pairs(win_bufs) do
		if vim.api.nvim_buf_get_option(buf, 'filetype') == 'qf'
			and vim.fn.win_gettype(win) == name
		then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	vim.cmd(lists[name].cmd_open)
end

-- Return a table with all window buffers from a tabpage.
---@private
---@param tabpage integer
M._get_tabpage_win_bufs = function(tabpage)
	local bufs = {}
	for _, win in pairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
		if win ~= nil and vim.api.nvim_win_is_valid(win) then
			local buf = vim.api.nvim_win_get_buf(win)
			if buf ~= nil and vim.api.nvim_buf_is_valid(buf) then
				bufs[win] = buf
			end
		end
	end
	return bufs
end

return M
