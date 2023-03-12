-- Rafi's tabline
-- https://github.com/rafi/vim-config

local api = vim.api

if not vim.F.if_nil(vim.g.tabline_plugin_enable, true) then
	return
end

---@param number integer
---@param charset table
local function numtr(number, charset)
	local result = ''
	for _, char in ipairs(vim.fn.split(tostring(number), '\zs')) do
		result = result .. charset[tonumber(char) + 1]
	end
	return result
end

local numeric_charset = vim.g['badge_numeric_charset'] or
	{'⁰','¹','²','³','⁴','⁵','⁶','⁷','⁸','⁹'}
	-- {'₀','₁','₂','₃','₄','₅','₆','₇','₈','₉'})

-- Limit display of directories in path
local max_dirs = vim.g['badge_tab_filename_max_dirs'] or 1

-- Limit display of characters in each directory in path
local directory_max_chars = vim.g['badge_tab_dir_max_chars'] or 5

-- Custom
vim.api.nvim_create_autocmd('ColorScheme', {
	callback = function()
		vim.api.nvim_set_hl(0, 'TabLineSelEdge', {
			fg = vim.api.nvim_get_hl_by_name('TabLineFill', true).background,
			bg = vim.api.nvim_get_hl_by_name('TabLineSel', true).background,
			ctermfg = vim.api.nvim_get_hl_by_name('TabLineFill', false).background,
			ctermbg = vim.api.nvim_get_hl_by_name('TabLineSel', false).background,
		})
		vim.cmd [[
			highlight TabLineAlt      ctermfg=252 ctermbg=238 guifg=#D0D0D0 guibg=#444444
			highlight TabLineAltShade ctermfg=238 ctermbg=236 guifg=#444444 guibg=#303030
		]]
	end
})

function _G.rafi_tabline()
	if vim.fn.exists('g:SessionLoad') == 1 then
		-- Skip tabline render during session loading
		return ''
	end

	local badge = require('rafi.lib.badge')

	-- Active project name
	local line = '%#TabLineAlt# '..badge.project()..' %#TabLineAltShade#'

	-- Iterate through all tabs and collect labels
	local current_tabpage = api.nvim_get_current_tabpage()
	for _, tabnr in ipairs(api.nvim_list_tabpages()) do
		-- Left-side of single tab
		if tabnr == current_tabpage then
			line = line .. '%#TabLineSelEdge#%#TabLineSel# '
		else
			line = line .. '%#TabLine#  '
		end

		-- Get file-name with custom cutoff settings
		local winbuf = api.nvim_win_get_buf(api.nvim_tabpage_get_win(tabnr))
		local fpath = badge.filepath(winbuf, max_dirs, directory_max_chars, '_tab')
		line = line .. '%' .. tabnr .. 'T' ..
			badge.icon(winbuf) ..
			(vim.g.global_symbol_padding or ' ') ..
			fpath:gsub('%%', '%%%%')

		-- Count windows and look for modified buffers
		local modified = false
		local win_count = 0
		local tab_windows = api.nvim_tabpage_list_wins(tabnr)
		for _, winnr in ipairs(tab_windows) do
			local bufnr = api.nvim_win_get_buf(winnr)
			if api.nvim_buf_get_option(bufnr, 'buftype') == '' then
				win_count = win_count + 1
				if not modified and api.nvim_buf_get_option(bufnr, 'modified') then
					modified = true
				end
			end
		end

		if win_count > 1 then
			line = line .. numtr(win_count, numeric_charset)
		end

		-- Add '+' if one of the buffers in the tab page is modified
		if modified then
			if tabnr == current_tabpage then
				line = line .. '%#Number#+%*'
			else
				line = line .. '%6*+%*'
			end
		end

		-- Right-side of single tab
		if tabnr == current_tabpage then
			line = line .. '%#TabLineSel# %#TabLineSelEdge#'
		else
			line = line .. '%#TabLine#  '
		end
	end

	line = line .. '%#TabLineFill#%T%='

	-- Empty elastic space and session indicator
	if vim.v['this_session'] ~= '' then
		local session_name = vim.fn.tr(vim.v['this_session'], '%', '/')
		line = line ..
			'%#TabLine#' .. vim.fn.fnamemodify(session_name, ':t:r') .. '  '
	end

	return line
end

vim.o.tabline='%!v:lua.rafi_tabline()'
