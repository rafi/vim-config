-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')
local badge = require('badge')

-- Color table for highlights
local colors = {
	-- yellow = '#ECBE7B',
	-- cyan = '#008080',
	-- darkblue = '#081633',
	-- green = '#98be65',
	-- orange = '#FF8800',
	-- violet = '#a9a1e1',
	-- magenta = '#c678dd',

	active = {
		fg = '#a8a897', -- '#bbc2cf',
		bg = '#30302c', -- '#202328',
		boundary = '#51afef',
		paste = '#98be65',
		filepath = '#D7D7BC',
		progress = '#4e4e43',
	},
	inactive = {
		fg = '#666656',
		bg = '#30302c', -- '#202328',
	},
	filemode = {
		modified = '#ec5f67',
		readonly = '#ec5f67',
	},
	diagnostics = {
		error = '#ec5f67',
		warn = '#ECBE7B',
		info = '#008080',

	},
	git = {
		added = '#516C31',
		modified = '#974505',
		deleted = '#B73944',
	},
}

-- Reference
-- Explorer:                         
-- Misc: ﬘ ⌯ ☱ ♯ 
-- Analysis: ✖ ✘ ✗ ⬪ ▪ ▫
-- Quickfix:               
-- Location:            
-- Lock: ⚠  ⚿  � � � �
-- Version: 
-- Zoom: � �
-- Unknown: ⯑

-- Section conditions
local conditions = {
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand('%:p:h')
		local gitdir = vim.fn.finddir('.git', filepath .. ';')
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end
}

-- Detect quickfix vs. location list
local function is_loclist()
	return vim.fn.getloclist(0, {filewinid = 1}).filewinid ~= 0
end

-- Extension: Quickfix
local extension_quickfix = {
	sections = {
		lualine_a = {
			{
				function()
					local q = '  '
					local l = '  '
					return is_loclist() and l..'Location List' or q..'Quickfix List'
				end,
				right_padding = 0,
			},
			{
				function()
					if is_loclist() then
						return vim.fn.getloclist(0, {title = 0}).title
					end
					return vim.fn.getqflist({title = 0}).title
				end
			},
		},
		lualine_z = { function() return '%l/%L' end },
	},
	filetypes = {'qf'},
}

-- Extension: File-explorer
local extension_file_explorer = {
	sections = {
		lualine_a = {
			{
				function() return '▊' end,
				color = { fg = colors.active.boundary },
				padding = 0,
			},
			{ function() return '' end, padding = 1 },
			{ function() return '%<' end, right_padding = 0 },
			{
				function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':~') end,
				left_padding = 0,
			}
		},
		lualine_z = { function() return '%l/%L' end },
	},
	inactive_sections = {
		lualine_a = {
			{ function() return '' end, padding = 1 },
			{ function() return '%<' end, right_padding = 0 },
			{
				function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':~') end,
				left_padding = 0,
			}
		},
		lualine_z = { function() return '%l/%L' end },
	},
	filetypes = {'fern'},
}

-- Extension: Only name and line-count
local extension_line_count = {
	sections = {
		lualine_a = {
			{
				function() return '▊' end,
				color = { fg = colors.active.boundary },
				left_padding = 0,
			},
			{ badge.utility_title(), padding = 0 },
		},
		lualine_z = { function() return '%l/%L' end },
	},
	-- Wait for https://github.com/hoob3rt/lualine.nvim/issues/301
	inactive_sections = {
		lualine_a = { badge.utility_title() },
		lualine_z = { function() return '%l/%L' end },
	},
	filetypes = {'Trouble', 'DiffviewFiles', 'NeogitStatus', 'Outline'},
}

-- Global Config
local config = {
	options = {
		component_separators = '',
		section_separators = '',
		theme = {
			normal = {
				a = { fg = colors.active.fg, bg = colors.active.bg },
				b = { fg = colors.active.fg, bg = colors.active.bg },
				c = { fg = colors.active.fg, bg = colors.active.bg },
				y = { fg = colors.active.fg, bg = colors.active.bg },
				z = { fg = colors.active.fg, bg = colors.active.progress },
			},
			inactive = {
				a = { fg = colors.inactive.fg, bg = colors.inactive.bg },
				b = { fg = colors.inactive.fg, bg = colors.inactive.bg },
				c = { fg = colors.inactive.fg, bg = colors.inactive.bg },
				y = { fg = colors.inactive.fg, bg = colors.inactive.bg },
				z = { fg = colors.inactive.fg, bg = colors.inactive.bg },
			}
		},
	},

	extensions = {
		extension_quickfix,
		extension_file_explorer,
		extension_line_count,
	},

	-- ACTIVE STATE --
	sections = {
		lualine_a = {
			-- Box boundary
			{
				function() return '▊' end,
				color = { fg = colors.active.boundary },
				left_padding = 0,
			},

			-- Paste mode
			{
				function() return vim.go.paste and '=' or '' end,
				padding = 0,
				color = { fg = colors.active.paste }
			},

			-- Readonly or zoomed
			{
				badge.filemode('%*#', '🔒', '🔎'),
				padding = 0,
				color = { fg = colors.filemode.readonly },
			},

			-- Buffer number
			{ function() return '%n' end, padding = 0 },

			-- Modified
			{
				badge.modified('+'),
				padding = 0,
				color = { fg = colors.filemode.modified }
			},

			-- File icon
			{ badge.icon() },

			-- File path
			{
				badge.filepath(3, 5),
				condition = conditions.buffer_not_empty,
				color = { fg = colors.active.filepath },
			},

			-- Diagnostics
			{
				'diagnostics',
				sources = { 'nvim_lsp' },
				symbols = { error = ' ', warn = ' ', info = ' ' },
				color_error = { fg = colors.diagnostics.error },
				color_warn = { fg = colors.diagnostics.warn },
				color_info = { fg = colors.diagnostics.info },
				padding = 0,
			},

			-- Start truncating here
			{ function() return '%<' end, right_padding = 0 },

			-- Whitespace trails
			{ badge.trails('␣'), padding = 0 },

			-- Git branch
			{ 'branch', icon = '', condition = conditions.check_git_workspace },

			-- Git status
			{
				'diff',
				symbols = { added = '₊', modified = '∗', removed = '₋' },
				color_added = { fg = colors.git.added },
				color_modified = { fg = colors.git.modified },
				color_removed = { fg = colors.git.deleted },
				condition = conditions.hide_in_width,
				padding = 0,
			},
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = { function() return '%=' end },
		lualine_y = {
			-- File format, encoding and type.
			{
				badge.filemedia('  '),
				condition = conditions.hide_in_width,
				left_padding = 0,
			},
		},
		lualine_z = {
			-- Border
			{
				function () return '' end,
				padding = 0,
				color = { fg = colors.active.progress, bg = colors.active.bg }
			},

			{ badge.progress() },

			-- Box boundary
			-- {
			-- 	function() return '▊' end,
			-- 	color = { fg = colors.active.boundary },
			-- 	padding = 0
			-- },
		}
	},

	-- INACTIVE STATE --
	inactive_sections = {
		lualine_a = {
			{ badge.icon() },
			{ badge.filepath(3, 5), right_padding = 0 },
			{ badge.modified('+'), color = { fg = colors.filemode.modified }},
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {
			{ function() return vim.bo.filetype end },
		}
	}
}

vim.g.qf_disable_statusline = true

-- Initialize lualine
lualine.setup(config)

-- vim: set ts=2 sw=2 tw=80 noet :
