-- rafi user functions
-- https://github.com/rafi/vim-config

if vim.fn.has('nvim-0.7') == 0 then
	return
end

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

local user = {}

-- QFLT_QUICKFIX Quickfix list - global list
----

user.qflist = {}

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

user.loclist = {}

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

user.diagnostic = {}

-- Set locations with diagnostics and open the list.
user.diagnostic.publish_loclist = function(toggle)
	if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'qf' then
		vim.diagnostic.setloclist({ open = not toggle })
	end
	if toggle then
		user.loclist.toggle()
	end
end

user.diagnostic.disable = function(bufnr)
	vim.diagnostic.disable(bufnr)
	vim.defer_fn(function()
		vim.diagnostic.reset(nil, bufnr)
	end, 1000)
end

-- Git
----

user.githunk = {}

user.githunk.publish_loclist = function(toggle)
	if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'qf' then
		require('gitsigns').setloclist()
	end
	if toggle then
		user.loclist.toggle()
	else
		user.loclist.open()
	end
end

-- Private
----

-- Toggle list window
user._toggle_list = function(key)
	local win_bufs = user._get_tabpage_win_bufs(0)
	local was_opened = false
	for win, buf in pairs(win_bufs) do
		if vim.api.nvim_buf_get_option(buf, 'filetype') == 'qf' then
			local qf_isLoc = vim.api.nvim_buf_get_var(buf, 'qf_isLoc')
			if qf_isLoc == lists[key].qf_isLoc then
				was_opened = true
				vim.api.nvim_win_close(win, false)
				-- vim.api.nvim_buf_call(buf, function()
				-- 	vim.api.nvim_command(lists[key].cmd_close)
				-- end)
			end
		end
	end

	if not was_opened then
		vim.api.nvim_command(lists[key].cmd_open)
	end
end

-- Return a table with all window buffers from a tabpage.
user._get_tabpage_win_bufs = function(tabpage)
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

return user

-- vim: set ts=2 sw=2 tw=80 noet :
