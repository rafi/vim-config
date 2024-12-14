-- Edit utilities
-- https://github.com/rafi/vim-config

---@class rafi.util.edit
local M = {}

-- Get visually selected lines.
-- Source: https://github.com/ibhagwan/fzf-lua/blob/main/lua/fzf-lua/utils.lua
---@return string
function M.get_visual_selection()
	-- this will exit visual mode
	-- use 'gv' to reselect the text
	local _, csrow, cscol, cerow, cecol
	local mode = vim.fn.mode()
	local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, mode)
	if is_visual then
		-- if we are in visual mode use the live position
		_, csrow, cscol, _ = unpack(vim.fn.getpos('.') or { 0, 0, 0, 0 })
		_, cerow, cecol, _ = unpack(vim.fn.getpos('v') or { 0, 0, 0, 0 })
		if mode == 'V' then
			-- visual line doesn't provide columns
			cscol, cecol = 0, 999
		end
		-- exit visual mode
		vim.api.nvim_feedkeys(
			vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
			'n',
			true
		)
	else
		-- otherwise, use the last known visual position
		_, csrow, cscol, _ = unpack(vim.fn.getpos("'<") or { 0, 0, 0, 0 })
		_, cerow, cecol, _ = unpack(vim.fn.getpos("'>") or { 0, 0, 0, 0 })
	end
	-- swap vars if needed
	if cerow < csrow then
		csrow, cerow = cerow, csrow
	end
	if cecol < cscol then
		cscol, cecol = cecol, cscol
	end
	local lines = vim.fn.getline(csrow, cerow)
	-- local n = cerow-csrow+1
	local n = #lines
	if n <= 0 or type(lines) ~= 'table' then
		return ''
	end
	lines[n] = string.sub(lines[n], 1, cecol)
	lines[1] = string.sub(lines[1], cscol)
	return table.concat(lines, '\n')
end

-- Append modeline at end of file.
function M.append_modeline()
	local modeline = string.format(
		'vim: set ts=%d sw=%d tw=%d %set :',
		vim.bo.tabstop,
		vim.bo.shiftwidth,
		vim.bo.textwidth,
		vim.bo.expandtab and '' or 'no'
	)
	local cs = require('ts_context_commentstring.internal').calculate_commentstring()
		or vim.bo.commentstring
	if not cs then
		LazyVim.warn('No commentstring found')
		return
	end
	modeline = string.gsub(cs, '%%s', modeline)
	vim.api.nvim_buf_set_lines(0, -1, -1, false, { modeline })
end

-- Go to newer/older buffer through jumplist.
---@param direction 1 | -1
function M.jump_buffer(direction)
	local jumplist, curjump = unpack(vim.fn.getjumplist() or { 0, 0 })
	if #jumplist == 0 then
		return
	end
	local cur_buf = vim.api.nvim_get_current_buf()
	local jumpcmd = direction > 0 and '<C-i>' or '<C-o>'
	local searchrange = {}
	curjump = curjump + 1
	if direction > 0 then
		searchrange = vim.fn.range(curjump + 1, #jumplist)
	else
		searchrange = vim.fn.range(curjump - 1, 1, -1)
	end

	for _, i in ipairs(searchrange) do
		local nr = jumplist[i]['bufnr']
		if nr ~= cur_buf and vim.fn.bufname(nr):find('^%w+://') == nil then
			local n = tostring(math.abs(i - curjump))
			vim.notify('Executing ' .. jumpcmd .. ' ' .. n .. ' times')
			jumpcmd = vim.api.nvim_replace_termcodes(jumpcmd, true, true, true)
			vim.cmd.normal({ n .. jumpcmd, bang = true })
			break
		end
	end
end

-- Jump to next/previous whitespace error.
---@param direction 1 | -1
function M.whitespace_jump(direction)
	local opts = 'wz'
	if direction < 1 then
		opts = opts .. 'b'
	end

	-- Whitespace pattern: Trailing whitespace or mixed tabs/spaces.
	local pat = '\\s\\+$\\| \\+\\ze\\t'
	vim.fn.search(pat, opts)
end

-- Toggle list window
---@param name "quickfix" | "loclist"
function M.toggle_list(name)
	for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_is_valid(win) and vim.fn.win_gettype(win) == name then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	if name == 'loclist' then
		vim.cmd([[ botright lopen ]])
	else
		vim.cmd([[ botright copen ]])
	end
end

-- Display a list of formatters and apply the selected one.
function M.formatter_select()
	local buf = vim.api.nvim_get_current_buf()
	local is_visual = vim.tbl_contains({ 'v', 'V', '\22' }, vim.fn.mode())
	local cur_start, cur_end
	if is_visual then
		cur_start = vim.fn.getpos('.')
		cur_end = vim.fn.getpos('v')
	end

	-- Collect various sources of formatters.
	---@class rafi.Formatter
	---@field kind string
	---@field name string
	---@field client LazyFormatter|{active:boolean,resolved:string[]}

	---@type rafi.Formatter[]
	local sources = {}
	local fmts = LazyVim.format.resolve(buf)
	for _, fmt in ipairs(fmts) do
		vim.tbl_map(function(resolved)
			table.insert(sources, {
				kind = fmt.name,
				name = resolved,
				client = fmt,
			})
		end, fmt.resolved)
	end

	local total_sources = #sources

	-- Apply formatter source on buffer.
	---@param bufnr number
	---@param source rafi.Formatter
	local apply_source = function(bufnr, source)
		if source == nil then
			return
		end
		LazyVim.try(function()
			return source.client.format(bufnr)
		end, { msg = 'Formatter `' .. source.name .. '` failed' })
	end

	if total_sources == 1 then
		apply_source(buf, sources[1])
	elseif total_sources > 1 then
		-- Display a list of sources to choose from
		vim.ui.select(sources, {
			prompt = 'Select a formatter',
			format_item = function(item)
				return item.name .. ' (' .. item.kind .. ')'
			end,
		}, function(selected)
			if is_visual then
				-- Restore visual selection
				vim.fn.setpos('.', cur_start)
				vim.cmd([[normal! v]])
				vim.fn.setpos('.', cur_end)
			end
			apply_source(buf, selected)
		end)
	else
		vim.notify(
			'No configured formatters for this filetype.',
			vim.log.levels.WARN
		)
	end
end

return M
