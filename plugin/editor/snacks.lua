-- Collection of QoL plugins: picker, explorer, notifier, terminal, toggles
if require('rafi.config').disabled('editor.snacks') then
	return
end
-- Required: rafi.config.keymaps, rafi.util.* and many plugin files call the
-- `Snacks` global, so rafi.config ignores 'editor.snacks' in rafi.json
-- `disabled` (see M.required). To use another picker or explorer, turn off
-- that snacks feature in its opts instead, like the editor.telescope and
-- editor.neo-tree extras do.
local pick = require('rafi.util.pick')
local root = require('rafi.util.root')

-- The editor.neo-tree extra replaces the Snacks explorer (netrw hijack and
-- explorer keys).
local neo_tree = require('rafi.config').enabled('editor.neo-tree')

-- The ui.illuminate extra replaces Snacks.words (LSP document highlight of
-- the word under the cursor), so both don't highlight at once.
local illuminate = require('rafi.config').enabled('ui.illuminate')

-- Eager: bigfile/quickfile/explorer (netrw) hook the first buffer read, and
-- LazyVim's keymaps, rafi.util.* and other plugin files use `Snacks` global.
vim.pack.add({ 'https://github.com/folke/snacks.nvim' })

-- Terminal window navigation, unless floating.
---@param dir string
local function term_nav(dir)
	---@param self snacks.terminal
	return function(self)
		return self:is_floating() and '<c-' .. dir .. '>'
			or vim.schedule(function()
				vim.cmd.wincmd(dir)
			end)
	end
end

-- Directory of an explorer item, or of its parent when it's a file or a
-- closed directory.
---@param item snacks.picker.Item
local function item_dir(item)
	if not item.dir or not item.open then
		item = item.parent
	end
	return item.file
end

-- Dashboard, scroll and statuscolumn are left disabled (snacks' default).
require('snacks').setup({
	bigfile = { enabled = true },
	explorer = { enabled = not neo_tree },
	image = {},
	indent = { enabled = true },
	input = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scope = { enabled = true },
	words = { enabled = not illuminate },
	toggle = {
		map = function(mode, lhs, rhs, opts)
			opts = opts or {}
			opts.silent = opts.silent ~= false
			Snacks.keymap.set(mode, lhs, rhs, opts)
		end,
	},
	terminal = {
		win = {
			style = 'terminal',
			wo = { winbar = '' },
			-- stylua: ignore
			keys = {
				nav_h = { '<C-h>', term_nav('h'), desc = 'Go to Left Window', expr = true, mode = 't' },
				nav_j = { '<C-j>', term_nav('j'), desc = 'Go to Lower Window', expr = true, mode = 't' },
				nav_k = { '<C-k>', term_nav('k'), desc = 'Go to Upper Window', expr = true, mode = 't' },
				nav_l = { '<C-l>', term_nav('l'), desc = 'Go to Right Window', expr = true, mode = 't' },
				hide_slash = { '<C-/>', 'hide', desc = 'Hide Terminal', mode = 't' },
				hide_underscore = { '<c-_>', 'hide', desc = 'which_key_ignore', mode = 't' },
			},
		},
	},
	zen = {
		toggles = { git_signs = true },
		zoom = {
			show = { tabline = false },
			win = { backdrop = true },
		},
	},
	picker = {
		actions = {
			---@param p snacks.Picker
			toggle_cwd = function(p)
				local buf = p.input.filter.current_buf
				local root_dir = root({ buf = buf, normalize = true })
				local cwd = vim.fs.normalize(vim.uv.cwd() or '.')
				p:set_cwd(p:cwd() == root_dir and cwd or root_dir)
				p:find()
			end,
			trouble_open = function(...)
				if not require('rafi.pack').has('trouble.nvim') then
					vim.notify('trouble.nvim is not installed')
					return false
				end
				vim.cmd.packadd('trouble.nvim')
				local src = require('trouble.sources.snacks')
				return src.actions.trouble_open.action(...)
			end,
		},
		sources = {
			files = { hidden = true, ignored = true },
			grep = { hidden = true, ignored = true },
			explorer = {
				replace_netrw = true,
				hidden = true,
				ignored = true,
				-- Disables auto-focusing/scoping to the current active file
				follow_file = false,
				layout = {
					cycle = false,
					auto_hide = { 'input' },
				},
				jump = { close = true },
				actions = {
					-- Find in path.
					find_in_path = function(_, item)
						pick('files', { cwd = item_dir(item) })()
					end,
					-- Grep in path.
					grep_in_path = function(_, item)
						pick('live_grep', { cwd = item_dir(item) })()
					end,
					-- Search and replace in path.
					search_replace_in_path = function(_, item)
						require('grug-far').open({
							prefills = { paths = vim.fn.fnameescape(item_dir(item)) },
						})
					end,
					-- Cycle explorer width: normal → large → small.
					toggle_width = function()
						local normal = 30
						local large = normal * 1.9
						local small = math.floor(normal / 1.6)
						local cur_width = vim.fn.winwidth(0)
						local new_width = normal
						if cur_width > normal then
							new_width = small
						elseif cur_width == normal then
							new_width = large
						end
						vim.cmd(new_width .. ' wincmd |')
					end,
				},
				win = {
					list = {
						keys = {
							['K'] = 'toggle_preview',
							['<esc>'] = false,
							['<c-h>'] = false,
							['<c-l>'] = false,
							['sv'] = 'edit_split',
							['sg'] = 'edit_vsplit',
							['st'] = 'edit_tab',
							['gf'] = 'find_in_path',
							['gr'] = 'grep_in_path',
							['gz'] = 'search_replace_in_path',
							['w'] = 'toggle_width',
						},
					},
				},
			},
		},
		win = {
			input = {
				keys = {
					['<a-c>'] = { 'toggle_cwd', mode = { 'n', 'i' } },
					['<a-t>'] = { 'trouble_open', mode = { 'n', 'i' } },
					['jj'] = { '<esc>', expr = true, mode = 'i' },
					['s'] = false,
					['ss'] = 'flash',
					['sv'] = 'edit_split',
					['sg'] = 'edit_vsplit',
					['st'] = 'edit_tab',
					['.'] = 'toggle_hidden',
					[','] = 'toggle_ignored',
					['e'] = 'qflist',
					['E'] = 'loclist',
					['K'] = 'select_and_prev',
					['J'] = 'select_and_next',
					['*'] = 'select_all',
					['<c-l>'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
					['<c-h>'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
				},
			},
			list = {
				keys = {
					['<c-l>'] = 'preview_scroll_right',
					['<c-h>'] = 'preview_scroll_left',
				},
			},
			preview = {
				keys = {
					['<c-h>'] = 'focus_input',
					['<c-l>'] = 'cycle_win',
				},
			},
		},
	},
})

-- Toggle focus of an open explorer, or open one with `cb`.
---@param cb fun()
local function explorer(cb)
	return function()
		local pickers = Snacks.picker.get({ source = 'explorer' })
		for _, p in pairs(pickers) do
			if p:is_focused() then
				p:close()
			else
				p:focus()
			end
		end
		if #pickers == 0 then
			cb()
		end
	end
end

local function zoxide()
	Snacks.picker.zoxide({
		confirm = function(picker)
			picker:close()
			local item = picker:current()
			if item and item.file then
				vim.cmd.tcd(item.file)
			end
		end,
	})
end

-- Lists vim.pack plugins with a preview of each spec; selecting one runs
-- :tcd into the plugin directory. Inactive plugins (installed but not added
-- this session) are dimmed.
local function plugins()
	local items = {} ---@type snacks.picker.finder.Item[]
	for _, plugin in ipairs(require('rafi.pack').list()) do
		items[#items + 1] = {
			text = plugin.spec.name,
			file = plugin.path,
			dir = true,
			active = plugin.active,
			preview = { text = vim.inspect(plugin), ft = 'lua' },
		}
	end
	Snacks.picker.pick({
		title = 'Plugins',
		items = items,
		preview = 'preview',
		format = function(item)
			local hl = item.active and 'SnacksPickerFile' or 'SnacksPickerComment'
			return { { item.text, hl } }
		end,
		confirm = function(picker, item)
			picker:close()
			if item then
				vim.cmd.tcd(vim.fn.fnameescape(item.file))
				vim.notify('Tab directory: ' .. item.file)
			end
		end,
	})
end

local function news()
	---@diagnostic disable-next-line: missing-fields
	Snacks.win({
		file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
		border = vim.o.winborder,
		width = 0.6,
		height = 0.6,
		wo = {
			spell = false,
			wrap = false,
			statuscolumn = ' ',
			conceallevel = 3,
		},
	})
end

local function map(mode, lhs, rhs, desc, opts)
	opts = vim.tbl_extend('force', { desc = desc }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

local remap = { remap = true }

-- stylua: ignore start

-- Utils
map('n', '<leader>.', function() Snacks.scratch() end, 'Toggle Scratch Buffer')
map('n', '<leader>S', function() Snacks.scratch.select() end, 'Select Scratch Buffer')
map('n', '<leader>dps', function() Snacks.profiler.scratch() end, 'Profiler Scratch Buffer')
map('n', '<leader>n', function() Snacks.picker.notifications() end, 'Notification History')
map('n', '<leader>un', function() Snacks.notifier.hide() end, 'Dismiss All Notifications')
map('n', '<leader>N', news, 'Neovim News')

-- Explorer
if not neo_tree then
	map('n', '<leader>fe', function() Snacks.explorer({ cwd = root() }) end, 'Explorer Snacks (root dir)')
	map('n', '<leader>fE', function() Snacks.explorer() end, 'Explorer Snacks (cwd)')
	map('n', '<leader>e', '<leader>fe', 'Explorer Snacks (root dir)', remap)
	map('n', '<leader>E', '<leader>fE', 'Explorer Snacks (cwd)', remap)
	map('n', '<localleader>e', '<leader>fe', 'Explorer Tree', remap)
	map('n', '<localleader>E', '<leader>fE', 'Explorer Tree (cwd)', remap)
	map('n', '<localleader>a', explorer(function() Snacks.explorer.reveal({ cwd = root() }) end), 'Reveal in Explorer')
	map('n', '<localleader>A', explorer(function() Snacks.explorer.reveal() end), 'Reveal in Explorer (cwd)')
end

-- Picker
map({ 'n', 'x' }, '<leader><localleader>', function() Snacks.picker() end, 'Pickers')
map('n', '<localleader>r', '<leader>sR', 'Resume Last', remap)
map({ 'n', 'x' }, '<localleader>u', function() Snacks.picker.spelling() end, 'Spellcheck')
map({ 'n', 'x' }, '<localleader>z', zoxide, 'Zoxide')
map('n', '<leader>,', function() Snacks.picker.buffers() end, 'Buffers')
map('n', '<leader>/', pick('grep'), 'Grep (Root Dir)')
map('n', '<leader>:', function() Snacks.picker.command_history() end, 'Command History')
map('n', '<leader><space>', pick('files'), 'Find Files (Root Dir)')

-- Find
map('n', '<leader>fb', function() Snacks.picker.buffers() end, 'Buffers')
map('n', '<leader>fB', function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, 'Buffers (all)')
map('n', '<leader>fc', pick.config_files(), 'Find Config File')
map('n', '<leader>ff', pick('files'), 'Find Files (Root Dir)')
map('n', '<leader>fF', pick('files', { root = false }), 'Find Files (cwd)')
map('n', '<leader>fg', function() Snacks.picker.git_files() end, 'Find Files (git-files)')
map('n', '<leader>fr', pick('oldfiles'), 'Recent')
map('n', '<leader>fR', function() Snacks.picker.recent({ filter = { cwd = true } }) end, 'Recent (cwd)')
map('n', '<leader>fp', function() Snacks.picker.projects() end, 'Projects')

-- Git
map('n', '<leader>gd', function() Snacks.picker.git_diff() end, 'Git Diff (hunks)')
-- TODO: Conflict: diffview's <leader>gD (plugin/git/diffview.lua) wins.
-- map('n', '<leader>gD', function() Snacks.picker.git_diff({ base = 'origin', group = true }) end, 'Git Diff (origin)')
map('n', '<leader>gs', function() Snacks.picker.git_status() end, 'Git Status')
map('n', '<leader>gS', function() Snacks.picker.git_stash() end, 'Git Stash')
map('n', '<leader>gi', function() Snacks.picker.gh_issue() end, 'GitHub Issues (open)')
map('n', '<leader>gI', function() Snacks.picker.gh_issue({ state = 'all' }) end, 'GitHub Issues (all)')
map('n', '<leader>gp', function() Snacks.picker.gh_pr() end, 'GitHub Pull Requests (open)')
map('n', '<leader>gP', function() Snacks.picker.gh_pr({ state = 'all' }) end, 'GitHub Pull Requests (all)')
map('n', '<leader>gF', function() Snacks.picker.files({ pattern = vim.fn.expand('<cword>') }) end, 'Find File')

-- Grep
map('n', '<leader>sb', function() Snacks.picker.lines() end, 'Buffer Lines')
map('n', '<leader>sB', function() Snacks.picker.grep_buffers() end, 'Grep Open Buffers')
map('n', '<leader>sg', pick('live_grep'), 'Grep (Root Dir)')
map('n', '<leader>sG', pick('live_grep', { root = false }), 'Grep (cwd)')
map('n', '<leader>sp', plugins, 'Plugins')
map({ 'n', 'x' }, '<leader>sw', pick('grep_word'), 'Visual selection or word (Root Dir)')
map({ 'n', 'x' }, '<leader>sW', pick('grep_word', { root = false }), 'Visual selection or word (cwd)')

-- Search
map('n', '<leader>s"', function() Snacks.picker.registers() end, 'Registers')
map('n', '<leader>s/', function() Snacks.picker.search_history() end, 'Search History')
map('n', '<leader>sa', function() Snacks.picker.autocmds() end, 'Autocmds')
map('n', '<leader>sc', function() Snacks.picker.command_history() end, 'Command History')
map('n', '<leader>sC', function() Snacks.picker.commands() end, 'Commands')
map('n', '<leader>sd', function() Snacks.picker.diagnostics() end, 'Diagnostics')
map('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, 'Buffer Diagnostics')
map('n', '<leader>sh', function() Snacks.picker.help() end, 'Help Pages')
map('n', '<leader>sH', function() Snacks.picker.highlights() end, 'Highlights')
map('n', '<leader>si', function() Snacks.picker.icons() end, 'Icons')
map('n', '<leader>sj', function() Snacks.picker.jumps() end, 'Jumps')
map('n', '<leader>sk', function() Snacks.picker.keymaps() end, 'Keymaps')
map('n', '<leader>sl', function() Snacks.picker.loclist() end, 'Location List')
map('n', '<leader>sM', function() Snacks.picker.man() end, 'Man Pages')
map('n', '<leader>sm', function() Snacks.picker.marks() end, 'Marks')
map('n', '<leader>sR', function() Snacks.picker.resume() end, 'Resume')
map('n', '<leader>sq', function() Snacks.picker.qflist() end, 'Quickfix List')
map('n', '<leader>su', function() Snacks.picker.undo() end, 'Undotree')

-- UI
map('n', '<leader>uC', function() Snacks.picker.colorschemes() end, 'Colorschemes')

-- stylua: ignore end
