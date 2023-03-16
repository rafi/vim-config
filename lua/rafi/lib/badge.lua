-- Badge utilities
-- https://github.com/rafi/vim-config

local plugin_icons = {
	qf = { '', 'List' },
	['neo-tree'] = { '', 'neo-tree' },
	['neo-tree-popup'] = { '', 'neo-tree' },
	TelescopePrompt = { '', 'Telescope' },
	Trouble = { '' },
	DiffviewFiles = { '' },
	Outline = { '' },
	mason = { '', 'Mason' },
	spectre_panel = { '', 'Spectre' },
	undotree = { '' },
	NeogitStatus = { '' },
	fugitive = { '' },
	fugitiveblame = { '', 'Blame' },
}

local root_patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn' }

local cache_keys = {
	'badge_cache_filepath',
	'badge_cache_filepath_tab',
	'badge_cache_icon',
}

local augroup = vim.api.nvim_create_augroup('rafi_badge', {})

-- Clear cached values that relate to buffer filename.
vim.api.nvim_create_autocmd(
	{'BufReadPost', 'BufFilePost', 'BufNewFile', 'BufWritePost'},
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
	{'BufWritePre', 'FileChangedShellPost', 'TextChanged', 'InsertLeave'},
	{
		group = augroup,
		callback = function()
			pcall(vim.api.nvim_buf_del_var, 0, 'badge_cache_trails')
		end,
	}
)

local M = {}

-- Find the root directory by searching for the version-control dir
function M.root()
	local cwd = vim.loop.cwd()
	if cwd == '' or cwd == nil then
		return ''
	end
	local ok, cache = pcall(vim.api.nvim_buf_get_var, 0, 'project_dir')
	if ok and cache then
		local _, last_cwd = pcall(vim.api.nvim_buf_get_var, 0, 'project_dir_last_cwd')
		if cwd == last_cwd then
			return cache
		end
	end

	local root = vim.fs.find(root_patterns, { path = cwd, upward = true })[1]
	root = root and vim.fs.dirname(root) or vim.loop.cwd()
	vim.api.nvim_buf_set_var(0, 'project_dir', root)
	vim.api.nvim_buf_set_var(0, 'project_dir_last_cwd', cwd)
	return root
end

-- Try to guess the project's name
function M.project()
	return vim.fn.fnamemodify(M.root(), ':t')
end

-- Provides relative path with limited characters in each directory name, and
-- limits number of total directories. Caches the result for current buffer.
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
	local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
	local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')

	-- Normalize bufname
	if bufname:len() < 1 and buftype:len() < 1 then
		return 'N/A'
	end
	bufname = vim.fn.fnamemodify(bufname, ':~:.')

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
	if plugin_icons[filetype] ~= nil and #plugin_icons[filetype] > 1 then
		msg = msg .. plugin_icons[filetype][2]
	else
		msg = msg .. bufname
	end

	vim.api.nvim_buf_set_var(bufnr, cache_key, msg)
	return msg
end

function M.filemode(normal_symbol, readonly_symbol, zoom_symbol)
	local msg = ''
	if not (vim.bo.readonly or vim.t['zoomed']) then
		msg = msg .. normal_symbol
	end
	if vim.bo.buftype == '' and vim.bo.readonly then
		msg = msg .. readonly_symbol
	end
	if vim.t.zoomed then
		msg = msg .. zoom_symbol
	end
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
	local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
	local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
	local bufname = vim.api.nvim_buf_get_name(bufnr)

	if buftype ~= '' and plugin_icons[ft] ~= nil then
		icon = plugin_icons[ft][1]
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
function M.trails(symbol)
	local cache_key = 'badge_cache_trails'
	local cache_ok, cache = pcall(vim.api.nvim_buf_get_var, 0, cache_key)
	if cache_ok then
		return cache
	end

	local msg = ''
	if
		not vim.bo.readonly
		and vim.bo.modifiable
		and vim.fn.line('$') < 9000
	then
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
