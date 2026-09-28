-- Util: Lualine components
-- https://github.com/rafi/vim-config
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/lualine.lua

---@class rafi.util.lualine
local M = {}

local plugin_icons = {
	DiffviewFiles = { ' ' },
	fugitive = { ' ' },
	fugitiveblame = { '󰊢', 'Blame' },
	lazy = { '󰒲 ', 'Lazy.nvim' },
	loclist = { '󰂖', 'Location List' },
	mason = { '󰈏 ', 'Mason' },
	NeogitStatus = { '󰉺' },

	['neo-tree'] = { ' ', '%{%v:lua.neotree_get_path()%}' },
	-- .. "%{%v:lua.require'neo-tree.ui.selector'.get()%}%#StatusLine#" },
	['neo-tree-popup'] = { '󰋱', '%{%v:lua.neotree_get_path()%}' },
	Outline = { ' ' },
	quickfix = { ' ', 'Quickfix List' }, -- 󰎟 
	['grug-far'] = { '󰥩 ', 'Grug FAR' },
	spectre_panel = { '󰥩 ', 'Spectre' },
	TelescopePrompt = { '󰋱', 'Telescope' },
	terminal = { ' ' },
	toggleterm = { ' ', 'Terminal' },
	trouble = { '' }, --  
	undotree = { '󰃢' },
}

local cache_keys = {
	'statusline_cache_trails',
}

-- Clear cached values that relate to buffer filename.
vim.api.nvim_create_autocmd(
	{ 'BufReadPost', 'BufFilePost', 'BufNewFile', 'BufWritePost' },
	{
		group = vim.api.nvim_create_augroup('rafi.statusline', {}),
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

---@return function
function M.plugin_title()
	return function()
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname:len() < 1 and vim.bo.buftype:len() < 1 then
			return 'N/A'
		end

		local msg = ''
		local ft = vim.bo.filetype
		local plugin_type = ft == 'qf' and vim.fn.win_gettype() or ft
		if plugin_icons[plugin_type] ~= nil then
			for _, part in ipairs(plugin_icons[plugin_type]) do
				msg = msg .. ' ' .. part
			end
		end
		if #(plugin_icons[plugin_type] or {}) < 2 then
			msg = msg .. bufname:gsub('%%', '%%%%')
		end
		return msg
	end
end

---@param opts? {separator: string}
---@return function
function M.filemedia(opts)
	opts = vim.tbl_extend('force', {
		separator = '  ',
	}, opts or {})
	return function()
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
		return table.concat(parts, opts.separator)
	end
end

-- Detect trailing whitespace, cached per buffer
---@param opts? {icon: string}
---@return function
function M.trails(opts)
	opts = vim.tbl_extend('force', {
		icon = '␣',
	}, opts or {})
	return function()
		local cache_key = 'statusline_cache_trails'
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
				msg = msg .. opts.icon .. trailing
			end
		end
		vim.api.nvim_buf_set_var(0, cache_key, msg)
		return msg
	end
end

---@return string
local function cwd()
	return require('rafi.util.root').realpath(vim.uv.cwd()) or ''
end

---@param hl string
---@return {fg: string?}
local function fg(hl)
	return { fg = require('rafi.util.color').get(hl) }
end

-- Wrap text in a lualine highlight derived from hl_group's fg/bold/italic.
---@param component any
---@param text string
---@param hl_group? string
---@return string
function M.format(component, text, hl_group)
	text = text:gsub('%%', '%%%%')
	if not hl_group or hl_group == '' then
		return text
	end
	---@type table<string, string>
	component.hl_cache = component.hl_cache or {}
	local lualine_hl_group = component.hl_cache[hl_group]
	if not lualine_hl_group then
		local utils = require('lualine.utils.utils')
		---@type string[]
		local gui = vim.tbl_filter(function(x)
			return x
		end, {
			utils.extract_highlight_colors(hl_group, 'bold') and 'bold',
			utils.extract_highlight_colors(hl_group, 'italic') and 'italic',
		})

		lualine_hl_group = component:create_hl({
			fg = utils.extract_highlight_colors(hl_group, 'fg'),
			gui = #gui > 0 and table.concat(gui, ',') or nil,
		}, 'LV_' .. hl_group) --[[@as string]]
		component.hl_cache[hl_group] = lualine_hl_group
	end
	return component:format_hl(lualine_hl_group)
		.. text
		.. component:get_default_hl()
end

---@param opts? {relative: "cwd"|"root", modified_hl: string?, directory_hl: string?, filename_hl: string?, modified_sign: string?, readonly_icon: string?, length: number?}
---@return function
function M.pretty_path(opts)
	opts = vim.tbl_extend('force', {
		relative = 'cwd',
		modified_hl = 'MatchParen',
		directory_hl = '',
		filename_hl = 'Bold',
		modified_sign = '',
		readonly_icon = ' 󰌾 ',
		length = 3,
	}, opts or {})

	return function(self)
		local path = vim.fn.expand('%:p') --[[@as string]]

		if path == '' then
			return ''
		end

		path = vim.fs.normalize(path)
		local root = require('rafi.util.root').get({ normalize = true })
		local cur = cwd()

		-- Original path is preserved to provide user with expected result of
		-- pretty_path, not a normalized one, which might be confusing.
		local norm_path = path

		if vim.fn.has('win32') == 1 then
			-- Additional normalization step for windows mixed case paths.
			norm_path = norm_path:lower()
			root = root:lower()
			cur = cur:lower()
		end

		if opts.relative == 'cwd' and norm_path:find(cur, 1, true) == 1 then
			path = path:sub(#cur + 2)
		elseif norm_path:find(root, 1, true) == 1 then
			path = path:sub(#root + 2)
		end

		local sep = package.config:sub(1, 1)
		local parts = vim.split(path, '[\\/]')

		if opts.length > 0 and #parts > opts.length then
			parts =
				{ parts[1], '…', unpack(parts, #parts - opts.length + 2, #parts) }
		end

		if opts.modified_hl and vim.bo.modified then
			parts[#parts] = parts[#parts] .. opts.modified_sign
			parts[#parts] = M.format(self, parts[#parts], opts.modified_hl)
		else
			parts[#parts] = M.format(self, parts[#parts], opts.filename_hl)
		end

		local dir = ''
		if #parts > 1 then
			dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
			dir = M.format(self, dir .. sep, opts.directory_hl)
		end

		local readonly = ''
		if vim.bo.readonly then
			readonly = M.format(self, opts.readonly_icon, opts.modified_hl)
		end
		return dir .. parts[#parts] .. readonly
	end
end

-- Project root name, shown depending on its relation to cwd.
---@param opts? {cwd:false, subdirectory: true, parent: true, other: true, icon?:string}
---@return table
function M.root_dir(opts)
	opts = vim.tbl_extend('force', {
		cwd = false,
		subdirectory = true,
		parent = true,
		other = true,
		icon = '󱉭 ',
		color = function()
			return fg('Special')
		end,
	}, opts or {})

	local function get()
		local cur = cwd()
		local root = require('rafi.util.root').get({ normalize = true })
		local name = vim.fs.basename(root)

		if root == cur then
			-- Root is cwd.
			return opts.cwd and name
		elseif root:find(cur, 1, true) == 1 then
			-- Root is subdirectory of cwd.
			return opts.subdirectory and name
		elseif cur:find(root, 1, true) == 1 then
			-- Root is parent directory of cwd.
			return opts.parent and name
		else
			-- Root and cwd are not related.
			return opts.other and name
		end
	end

	return {
		function()
			return (opts.icon and opts.icon .. ' ') .. get()
		end,
		cond = function()
			return type(get()) == 'string'
		end,
		color = opts.color,
	}
end

_G.neotree_get_path = function(winid)
	winid = winid or vim.api.nvim_get_current_win()
	local state =
		require('neo-tree.sources.manager').get_state('filesystem', nil, winid)
	if not state.path then
		local bufnr = vim.api.nvim_win_get_buf(winid)
		if vim.bo[bufnr].filetype == 'neo-tree' then
			state = require('neo-tree.sources.manager').get_state('filesystem')
		end
	end
	return state.path and vim.fn.fnamemodify(state.path, ':~') or ''
end

return M
