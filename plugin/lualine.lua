-- Blazing fast and easy to configure statusline
if require('rafi.config').disabled('lualine') then
	return
end

-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua

if vim.g.started_by_firenvim then
	return
end

local pack = require('rafi.pack')

vim.g.lualine_laststatus = vim.o.laststatus
if vim.fn.argc(-1) > 0 then
	-- Set an empty statusline till lualine loads.
	vim.o.statusline = ' '
else
	-- Hide the statusline on the starter page.
	vim.o.laststatus = 0
end

---@return table
local function build_opts()
	local color = require('rafi.util.color').get
	local icons = require('rafi.util.icons')
	local util = require('rafi.util.lualine')

	local function is_plugin_window()
		return vim.bo.buftype ~= ''
	end

	local function is_file_window()
		return vim.bo.buftype == ''
	end

	local function is_not_prompt()
		return vim.bo.buftype ~= 'prompt'
	end

	local function is_min_width(min)
		if vim.o.laststatus > 2 then
			return vim.o.columns > min
		end
		return vim.fn.winwidth(0) > min
	end

	local active = {
		bg = color('StatusLine', 'bg'),
		fg = color('StatusLine'),
	}
	local inactive = {
		bg = color('StatusLineNC', 'bg'),
		fg = color('StatusLineNC'),
	}

	local ColorUtil = require('rafi.util.color')
	local theme = {
		normal = {
			a = active,
			b = active,
			c = active,
			x = {
				fg = ColorUtil.brightness_modifier(active.bg, -80),
				bg = active.bg,
			},
			y = {
				fg = active.fg,
				bg = ColorUtil.brightness_modifier(active.bg, -20),
			},
			z = {
				fg = active.fg,
				bg = ColorUtil.brightness_modifier(active.bg, 63),
			},
		},
		inactive = {
			a = inactive,
			b = inactive,
			c = inactive,
			x = inactive,
			y = inactive,
			z = inactive,
		},
	}

	vim.o.laststatus = vim.g.lualine_laststatus

	local opts = {
		options = {
			theme = theme,
			globalstatus = vim.o.laststatus == 3,
			disabled_filetypes = {
				statusline = {
					'dashboard',
					'alpha',
					'ministarter',
					'snacks_dashboard',
				},
			},
		},
		extensions = { 'lazy', 'fzf', 'man' },
		sections = {
			lualine_a = {
				-- Left edge block.
				{
					function()
						return '▊'
					end,
					padding = 0,
					separator = '',
					color = function()
						local hl = is_file_window() and 'Statement' or 'Function'
						return { fg = color(hl) }
					end,
				},
				-- Readonly/zoomed/hash symbol.
				{
					padding = { left = 1, right = 0 },
					separator = '',
					cond = is_file_window,
					function()
						if vim.bo.buftype == '' and vim.bo.readonly then
							return icons.status.filename.readonly
						elseif vim.t['zoomed'] then
							return icons.status.filename.zoomed
						end
						return ''
					end,
				},
				-- stylua: ignore
				{
					'branch',
					cond = is_file_window,
					icon = '', --  
					padding = 1,
					on_click = function() vim.cmd([[Telescope git_branches]]) end,
				},
				util.root_dir(),
				{
					util.plugin_title(),
					padding = { left = 0, right = 1 },
					cond = is_plugin_window,
				},
				{
					'filetype',
					icon_only = true,
					padding = { left = 1, right = 0 },
					separator = { right = '' },
					cond = is_file_window,
				},
			},
			lualine_b = {
				-- File-path, toggle navic structure when clicked.
				{
					util.pretty_path({ length = 5 }),
					color = { fg = '#D7D7BC' },
					separator = '',
					cond = is_file_window,
					on_click = function()
						vim.g.trouble_lualine = not vim.g.trouble_lualine
						require('lualine').refresh()
					end,
				},
				-- Show buffer number in terminal
				{
					separator = '',
					padding = { left = 1, right = 1 },
					function()
						local s = vim.b.term_title or ''
						local n = vim.b.toggle_number or ''
						if vim.b.snacks_terminal then
							n = vim.b.snacks_terminal.id
						end
						return s .. (n and ' #' .. n or '')
					end,
					cond = function()
						return vim.bo.buftype == 'snacks_terminal'
							or vim.bo.buftype == 'terminal'
					end,
				},
				-- Quickfix/location list title
				-- stylua: ignore
				{
					separator = '',
					function()
						if vim.fn.win_gettype() == 'loclist' then
							return vim.fn.getloclist(0, { title = 0 }).title
						end
						return vim.fn.getqflist({ title = 0 }).title
					end,
					cond = function() return vim.bo.filetype == 'qf' end,
					padding = { left = 1, right = 0 },
				},

				-- Whitespace trails
				-- stylua: ignore
				{
					util.trails(),
					cond = is_file_window,
					padding = { left = 1, right = 0 },
					color = function() return { fg = color('Identifier') } end,
				},

				{
					'diagnostics',
					symbols = {
						error = icons.status.diagnostics.error,
						warn = icons.status.diagnostics.warn,
						info = icons.status.diagnostics.info,
						hint = icons.status.diagnostics.hint,
					},
				},

				-- Search count
				{
					function()
						if vim.v.hlsearch == 0 then
							return ''
						end

						local ok, result =
							pcall(vim.fn.searchcount, { maxcount = 999, timeout = 10 })
						if not ok or next(result) == nil or result.current == 0 then
							return ''
						end

						local denominator = math.min(result.total, result.maxcount)
						return string.format(
							'/%s [%d/%d]',
							vim.fn.getreg('/'),
							result.current,
							denominator
						)
					end,
					separator = '',
					padding = { left = 1, right = 0 },
				},
			},
			lualine_c = {},
			lualine_x = {
				-- LSP status
				-- stylua: ignore
				{
					'lsp_status',
					icon = '', -- f013
					symbols = {
						spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
						done = '✓',
						separator = ' ',
					},
					-- List of LSP names to ignore (e.g., `null-ls`):
					ignore_lsp = {},
					-- Accent from the colorscheme (morrow defines LuaLineLspStatus),
					-- Function elsewhere.
					color = function()
						return { fg = color({ 'LuaLineLspStatus', 'Function' }) }
					end,
				},
				-- Diff (git)
				{
					'diff',
					symbols = {
						added = icons.status.git.added,
						modified = icons.status.git.modified,
						removed = icons.status.git.removed,
					},
					padding = 1,
					cond = function()
						return is_file_window() and is_min_width(70)
					end,
					source = function()
						local gitsigns = vim.b.gitsigns_status_dict
						if gitsigns then
							return {
								added = gitsigns.added,
								modified = gitsigns.changed,
								removed = gitsigns.removed,
							}
						end
					end,
					on_click = function()
						vim.cmd([[DiffviewFileHistory %]])
					end,
				},

				-- showcmd: pending keys, e.g. `2d` or `"a` (needs showcmd+showcmdloc)
				-- stylua: ignore
				-- {
				-- 	function() return '%S' end,
				-- 	cond = function()
				-- 		return vim.api.nvim_eval_statusline('%S', {}).str ~= ''
				-- 	end,
				-- 	color = function() return { fg = color('Statement') } end,
				-- },

				-- macro recording
				-- stylua: ignore
				{
					function() return 'recording @' .. vim.fn.reg_recording() end,
					cond = function() return vim.fn.reg_recording() ~= '' end,
					color = function() return { fg = color('Constant') } end,
				},
				-- dap status
				-- stylua: ignore
				{
					function() return '  ' .. require('dap').status() end,
					cond = function () return package.loaded['dap'] and require('dap').status() ~= '' end,
					color = function() return { fg = color('Debug') } end,
				},
			},
			lualine_y = {
				{
					util.filemedia(),
					padding = 1,
					cond = function()
						return is_min_width(70)
					end,
					on_click = function()
						vim.cmd([[Telescope filetypes]])
					end,
				},
			},
			lualine_z = {
				{
					function()
						if is_file_window() then
							return '%l/%2c%4p%%'
						end
						return '%l/%L'
					end,
					cond = is_not_prompt,
					padding = 1,
				},
			},
		},
		inactive_sections = {
			lualine_a = {
				{
					'filetype',
					icon_only = true,
					colored = false,
					separator = '',
					padding = { left = 1, right = 0 },
				},
				{
					util.pretty_path({ length = 3 }),
					padding = { left = 1, right = 0 },
				},
			},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {
				{
					function()
						return vim.bo.filetype
					end,
					cond = is_file_window,
				},
			},
		},
	}

	if _G.Snacks then
		table.insert(opts.sections.lualine_x, 1, Snacks.profiler.status())
	end

	-- Plugins with pending vim.pack updates (packcount.nvim, unless
	-- ui.packcount is disabled). Click opens packman.nvim's picker.
	local has_packcount, packcount = pcall(require, 'packcount')
	if has_packcount then
		table.insert(opts.sections.lualine_x, {
			packcount.updates,
			cond = packcount.has_updates,
			color = function()
				return { fg = color('Comment') }
			end,
			on_click = function()
				if vim.fn.exists(':Packman') == 2 then
					vim.cmd('Packman')
				end
			end,
		})
	end

	-- Show code structure in statusline.
	-- Allow it to be overriden for some buffer types (see autocmds).
	if
		vim.g.trouble_lualine
		and pack.has('trouble.nvim')
		-- No-op if the editor.trouble extra already added it.
		and pcall(vim.pack.add, { 'https://github.com/folke/trouble.nvim' })
	then
		local trouble = require('trouble')
		local symbols = trouble.statusline({
			mode = 'symbols',
			groups = {},
			title = false,
			filter = { range = true },
			format = '{kind_icon}{symbol.name:Normal}',
			hl_group = 'lualine_c_normal',
		})
		table.insert(opts.sections.lualine_c, {
			symbols and symbols.get,
			cond = function()
				return vim.b.trouble_lualine ~= false and symbols.has()
			end,
		})
	end

	require('rafi.util.lualine').apply(opts)
	return opts
end

pack.later(function()
	vim.pack.add({ 'https://github.com/nvim-lualine/lualine.nvim' })
	-- PERF: we don't need this lualine require madness.
	require('lualine_require').require = require
	require('lualine').setup(build_opts())

	-- Lualine doesn't refresh when recording starts or stops. Stopping fires
	-- before reg_recording() is cleared, so redraw on the next tick.
	vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
		group = vim.api.nvim_create_augroup('rafi_lualine_recording', {}),
		callback = function()
			vim.schedule(function()
				require('lualine').refresh()
			end)
		end,
	})
end)
