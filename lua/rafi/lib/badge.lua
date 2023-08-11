-- Badge utilities
-- https://github.com/rafi/vim-config

local plugin_icons = {
	DiffviewFiles = { '' },
	fugitive = { ' ' },
	fugitiveblame = { '󰊢', 'Blame' },
	lazy = { '󰒲 ', 'Lazy.nvim' },
	loclist = { '󰂖', 'Location List' },
	mason = { '󰈏 ', 'Mason' },
	NeogitStatus = { '󰉺' },
	['neo-tree'] = { ' ', 'Neo-tree' },
	['neo-tree-popup'] = { '󰋱', 'Neo-tree' },
	Outline = { ' ' },
	quickfix = { ' ', 'Quickfix List' }, -- 󰎟 
	spectre_panel = { '󰥩 ', 'Spectre' },
	TelescopePrompt = { '󰋱', 'Telescope' },
	terminal = { ' ' },
	toggleterm = { ' ', 'Terminal' },
	Trouble = { '' }, --  
	undotree = { '󰃢' },
}

local cache_keys = {
	'badge_cache_filepath',
	'badge_cache_filepath_tab',
	'badge_cache_icon',
}

local augroup = vim.api.nvim_create_augroup('rafi_badge', {})

-- Clear cached values that relate to buffer filename.
vim.api.nvim_create_autocmd(
	{ 'BufReadPost', 'BufFilePost', 'BufNewFile', 'BufWritePost' },
	{
		group = augroup,
		callback = function()
			if vim.bo.buftype ~= '' then
				return
			end
			for _, cache_key in ipairs(cache_keys) do
				pcall(vim.api.nvim_buf_del_var, 0, cache_key)
			end
		end,
	}
)
-- Clear cached values that relate to buffer content.
vim.api.nvim_create_autocmd(
	{ 'BufWritePre', 'FileChangedShellPost', 'TextChanged', 'InsertLeave' },
	{
		group = augroup,
		callback = function()
			pcall(vim.api.nvim_buf_del_var, 0, 'badge_cache_trails')
		end,
	}
)

local M = {}

-- Try to guess the project's name
---@return string
function M.project()
	return vim.fn.fnamemodify(require('rafi.lib.utils').get_root(), ':t') or ''
end

-- Provides relative path with limited characters in each directory name, and
-- limits number of total directories. Caches the result for current buffer.
---@param bufnr integer buffer number
---@param max_dirs integer max dirs to show
---@param dir_max_chars integer max chars in dir
---@param cache_suffix string? cache suffix
---@return string
function M.filepath(bufnr, max_dirs, dir_max_chars, cache_suffix)
	local msg = ''
	local cache_key = 'badge_cache_filepath' -- _'..ft
	if cache_suffix then
		cache_key = cache_key .. cache_suffix
	end
	local cache_ok, cache = pcall(vim.api.nvim_buf_get_var, bufnr, cache_key)
	if cache_ok then
		return cache
	end

	local bufname = vim.api.nvim_buf_get_name(bufnr)
	local buftype = vim.bo[bufnr].buftype
	local filetype = vim.bo[bufnr].filetype

	-- Normalize bufname
	if bufname:len() < 1 and buftype:len() < 1 then
		return 'N/A'
	end
	bufname = vim.fn.fnamemodify(bufname, ':~:.') or ''

	-- Reduce directory count according to 'max_dirs' setting.
	local formatter = string.format('([^%s]+)', M.path_sep)
	local parts = {}
	for str in string.gmatch(bufname, formatter) do
		table.insert(parts, str)
	end

	local short_parts = {}
	for i = #parts, 1, -1 do
		if #short_parts <= max_dirs then
			table.insert(short_parts, 1, parts[i])
		end
	end
	bufname = table.concat(short_parts, M.path_sep)

	-- Reduce each directory character count according to setting.
	bufname = vim.fn.pathshorten(bufname, dir_max_chars + 1)

	-- Override with plugin names.
	local plugin_type = filetype == 'qf' and vim.fn.win_gettype() or filetype
	if plugin_icons[plugin_type] ~= nil and #plugin_icons[plugin_type] > 1 then
		msg = msg .. plugin_icons[plugin_type][2]
	else
		msg = msg .. bufname
	end

	vim.api.nvim_buf_set_var(bufnr, cache_key, msg)
	return msg
end

function M.filemedia(separator)
	local parts = {}
	if vim.bo.fileformat ~= '' and vim.bo.fileformat ~= 'unix' then
		table.insert(parts, vim.bo.fileformat)
	end
	if vim.bo.fileencoding ~= '' and vim.bo.fileencoding ~= 'utf-8' then
		table.insert(parts, vim.bo.fileencoding)
	end
	if vim.bo.filetype ~= '' then
		table.insert(parts, vim.bo.filetype)
	end
	return table.concat(parts, separator)
end

function M.icon(bufnr)
	bufnr = bufnr or 0
	local cache_key = 'badge_cache_icon'
	local cache_ok, cache = pcall(vim.api.nvim_buf_get_var, bufnr, cache_key)
	if cache_ok then
		return cache
	end

	local icon = ''
	local ft = vim.bo[bufnr].filetype
	local buftype = vim.bo[bufnr].buftype
	local bufname = vim.api.nvim_buf_get_name(bufnr)

	local plugin_type = ft == 'qf' and vim.fn.win_gettype() or ft
	if buftype ~= '' and plugin_icons[plugin_type] ~= nil then
		icon = plugin_icons[plugin_type][1]
	else
		-- Try nvim-tree/nvim-web-devicons
		local ok, devicons = pcall(require, 'nvim-web-devicons')
		if ok then
			if buftype == '' and bufname == '' then
				return devicons.get_default_icon().icon
			end
			local f_name = vim.fn.fnamemodify(bufname, ':t')
			local f_extension = vim.fn.fnamemodify(bufname, ':e')
			icon, _ = devicons.get_icon(f_name, f_extension)
			if icon == '' or icon == nil then
				icon = devicons.get_default_icon().icon
			end
		end
	end
	vim.api.nvim_buf_set_var(bufnr, cache_key, icon)
	return icon
end

-- Detect trailing whitespace and cache result per buffer
---@param symbol string
---@return string
function M.trails(symbol)
	local cache_key = 'badge_cache_trails'
	local cache_ok, cache = pcall(vim.api.nvim_buf_get_var, 0, cache_key)
	if cache_ok then
		return cache
	end

	local msg = ''
	if not vim.bo.readonly and vim.bo.modifiable and vim.fn.line('$') < 9000 then
		local trailing = vim.fn.search('\\s$', 'nw')
		if trailing > 0 then
			local label = symbol or 'WS:'
			msg = msg .. label .. trailing
		end
	end
	vim.api.nvim_buf_set_var(0, cache_key, msg)

	return msg
end

-- Variable holds OS directory separator.
M.path_sep = (function()
	if jit then
		local os = string.lower(jit.os)
		if os ~= 'windows' then
			return '/'
		else
			return '\\'
		end
	else
		return package.config:sub(1, 1)
	end
end)()

return M
