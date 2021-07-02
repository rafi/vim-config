-- rafi user functions
-- https://github.com/rafi/vim-config

local lists = {
	qf = {
		qf_isLoc = 0,
		cmd_open = 'botright copen',
		cmd_close = 'cclose',
	},
	location = {
		qf_isLoc = 1,
		cmd_open = 'botright lopen',
		cmd_close = 'lclose',
	},
}

local user = { diagnostic = {}, qflist = {}, loclist = {} }

-- QFLT_QUICKFIX Quickfix list - global list
----

-- Open quickfix list window
user.qflist.open = function()
	vim.api.nvim_command(lists.qf.cmd_open)
end

-- Toggle quickfix list window
user.qflist.toggle = function()
	user._toggle_list('qf')
end

-- QFLT_LOCATION Location list - per window list
----

-- Open location list window
user.loclist.open = function()
	vim.api.nvim_command(lists.location.cmd_open)
end

-- Toggle location list window
user.loclist.toggle = function()
	user._toggle_list('location')
end

-- Diagnostics
----

-- Set locations with diagnostics and open the list.
user.diagnostic.publish_loclist = function(toggle)
	if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'qf' then
		vim.lsp.diagnostic.set_loclist({ open_loclist = false })
	end
	-- TODO: find other buffers' opened loclists and close all first.
	-- if toggle then
	-- 	user.loclist.toggle()
	-- else
		user.loclist.open()
	-- end
end

-- Set location items, open the list and jump to first item.
user.diagnostic.set_qflist = function(items)
	if not items then return end
	vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(items))
	user.qflist.open()
	vim.api.nvim_command('.cc')
end

-- Private
----

-- Toggle list window
user._toggle_list = function(key)
	for _, buf in pairs(user._get_tabpage_win_bufs(0)) do
		if vim.api.nvim_buf_get_option(buf, 'filetype') == 'qf' then
			local qf_isLoc = vim.api.nvim_buf_get_var(buf, 'qf_isLoc')
			if qf_isLoc == lists[key].qf_isLoc then
				vim.api.nvim_command(lists[key].cmd_close)
				return
			end
		end
	end

	vim.api.nvim_command(lists[key].cmd_open)
end

-- Return a table with all window buffers from a tabpage.
user._get_tabpage_win_bufs = function(tabpage)
	local bufs = {}
	for _, win in pairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
		if win ~= nil and vim.api.nvim_win_is_valid(win) then
			local buf = vim.api.nvim_win_get_buf(win)
			if buf ~= nil and vim.api.nvim_buf_is_valid(buf) then
				table.insert(bufs, buf)
			end
		end
	end
	return bufs
end

return user

-- vim: set ts=2 sw=2 tw=80 noet :
