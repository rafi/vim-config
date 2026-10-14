-- Awesome picker for FZF (fzf-lua), alternative to the snacks picker
-- Generic picks (files, grep, oldfiles) open fzf-lua. Needs the `fzf` binary.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/fzf.lua
local pack = require('rafi.pack')
local pick = require('rafi.util.pick')

-- fzf-lua handles vim.ui.select, so the snacks picker doesn't.
if Snacks and Snacks.config and Snacks.config.picker then
	Snacks.config.picker.ui_select = false
end

-- Images are previewed with the first available external tool.
local function image_previewer()
	for _, v in ipairs({
		{ cmd = 'ueberzug', args = {} },
		{ cmd = 'chafa', args = { '{file}', '--format=symbols' } },
		{ cmd = 'viu', args = { '-b' } },
	}) do
		if vim.fn.executable(v.cmd) == 1 then
			return vim.list_extend({ v.cmd }, v.args)
		end
	end
end

-- Builds fzf-lua's setup options and tweaks its default keymaps and actions.
local function fzf_opts()
	local fzf = require('fzf-lua')
	local config = fzf.config
	local actions = fzf.actions

	-- Quickfix
	config.defaults.keymap.fzf['ctrl-q'] = 'select-all+accept'
	config.defaults.keymap.fzf['ctrl-u'] = 'half-page-up'
	config.defaults.keymap.fzf['ctrl-d'] = 'half-page-down'
	config.defaults.keymap.fzf['ctrl-x'] = 'jump'
	config.defaults.keymap.fzf['ctrl-f'] = 'preview-page-down'
	config.defaults.keymap.fzf['ctrl-b'] = 'preview-page-up'
	config.defaults.keymap.builtin['<c-f>'] = 'preview-page-down'
	config.defaults.keymap.builtin['<c-b>'] = 'preview-page-up'

	-- <C-t> sends results to Trouble. Its fzf source needs Trouble loaded.
	if
		require('rafi.config').enabled('editor.trouble')
		and pack.has('trouble.nvim')
	then
		vim.cmd.packadd('trouble.nvim')
		config.defaults.actions.files['ctrl-t'] =
			require('trouble.sources.fzf').actions.open
	end

	-- Toggle root dir / cwd
	config.defaults.actions.files['ctrl-r'] = function(_, ctx)
		local o = vim.deepcopy(ctx.__call_opts)
		o.root = o.root == false
		o.cwd = nil
		o.buf = ctx.__CTX.bufnr
		pick.open(ctx.__INFO.cmd, o)
	end
	config.defaults.actions.files['alt-c'] =
		config.defaults.actions.files['ctrl-r']
	config.set_action_helpstr(
		config.defaults.actions.files['ctrl-r'],
		'toggle-root-dir'
	)

	local img_previewer = image_previewer()

	return {
		'default-title',
		fzf_colors = true,
		fzf_opts = {
			['--no-scrollbar'] = true,
		},
		defaults = {
			-- formatter = 'path.filename_first',
			formatter = 'path.dirname_first',
		},
		previewers = {
			builtin = {
				extensions = {
					['png'] = img_previewer,
					['jpg'] = img_previewer,
					['jpeg'] = img_previewer,
					['gif'] = img_previewer,
					['webp'] = img_previewer,
				},
				ueberzug_scaler = 'fit_contain',
			},
		},
		winopts = {
			width = 0.8,
			height = 0.8,
			row = 0.5,
			col = 0.5,
			preview = {
				scrollchars = { '┃', '' },
			},
		},
		files = {
			cwd_prompt = false,
			actions = {
				['alt-i'] = { actions.toggle_ignore },
				['alt-h'] = { actions.toggle_hidden },
			},
		},
		grep = {
			actions = {
				['alt-i'] = { actions.toggle_ignore },
				['alt-h'] = { actions.toggle_hidden },
			},
		},
		lsp = {
			symbols = {
				symbol_hl = function(s)
					return 'TroubleIcon' .. s
				end,
				symbol_fmt = function(s)
					return s:lower() .. '\t'
				end,
				child_prefix = false,
			},
			code_actions = {
				previewer = vim.fn.executable('delta') == 1 and 'codeaction_native'
					or nil,
			},
		},
	}
end

-- Options for vim.ui.select: a centered window sized to its content.
-- Code actions get a vertical layout with a diff preview.
---@param fzf_o table
---@param items any[]
local function select_opts(fzf_o, items)
	local title = vim.trim((fzf_o.prompt or 'Select'):gsub('%s*:%s*$', ''))
	return vim.tbl_deep_extend('force', fzf_o, {
		prompt = ' ',
		winopts = {
			title = ' ' .. title .. ' ',
			title_pos = 'center',
		},
	}, fzf_o.kind == 'codeaction' and {
		winopts = {
			layout = 'vertical',
			-- Fit the items plus 15 lines of preview, at most 80% of the screen.
			height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5)
				+ 16,
			width = 0.5,
			preview = not vim.tbl_isempty(
				vim.lsp.get_clients({ bufnr = 0, name = 'vtsls' })
			) and {
				layout = 'vertical',
				vertical = 'down:15,border-top',
				hidden = 'hidden',
			} or {
				layout = 'vertical',
				vertical = 'down:15,border-top',
			},
		},
	} or {
		winopts = {
			width = 0.5,
			-- Height is number of items, with a max of 80% screen height.
			height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
		},
	})
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' })

	local opts = fzf_opts()
	if opts[1] == 'default-title' then
		-- Same prompt for all pickers based on the `default-title` profile.
		local function fix(t)
			t.prompt = t.prompt ~= nil and ' ' or nil
			for _, v in pairs(t) do
				if type(v) == 'table' then
					fix(v)
				end
			end
			return t
		end
		opts = vim.tbl_deep_extend(
			'force',
			fix(require('fzf-lua.profiles.default-title')),
			opts
		)
		opts[1] = nil
	end
	require('fzf-lua').setup(opts)
end

-- Generic pick names mapped to fzf-lua functions.
pick.register({
	name = 'fzf',
	commands = {
		files = 'files',
	},
	---@param command string
	---@param opts? table
	open = function(command, opts)
		load()
		opts = opts or {}
		if opts.cmd == nil and command == 'git_files' and opts.show_untracked then
			opts.cmd = 'git ls-files --exclude-standard --cached --others'
		end
		return require('fzf-lua')[command](opts)
	end,
})

pack.command('FzfLua', load, { desc = 'FzfLua', complete = true })

-- Loads fzf-lua on the first vim.ui.select call.
pack.later(function()
	vim.ui.select = function(...)
		load()
		require('fzf-lua').register_ui_select(select_opts)
		return vim.ui.select(...)
	end
end)

-- Keep <C-j>/<C-k> inside the fzf window instead of moving between windows.
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'fzf',
	group = vim.api.nvim_create_augroup('rafi.fzf', {}),
	callback = function(args)
		for _, lhs in ipairs({ '<c-j>', '<c-k>' }) do
			vim.keymap.set('t', lhs, lhs, { buffer = args.buf, nowait = true })
		end
	end,
})

-- Keeps only the symbol kinds allowed for the buffer's filetype.
local function symbols_filter(entry, ctx)
	if ctx.symbols_filter == nil then
		ctx.symbols_filter = require('rafi.util.icons').get_kind_filter(ctx.bufnr)
			or false
	end
	if ctx.symbols_filter == false then
		return true
	end
	return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

-- LSP keys, replacing the snacks picker ones.
-- stylua: ignore
require('rafi.util.lang').add({
	keys = {
		['*'] = {
			{ 'gd', '<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>', desc = 'Goto Definition', has = 'definition' },
			{ 'gr', '<cmd>FzfLua lsp_references      jump1=true ignore_current_line=true<cr>', desc = 'References', nowait = true },
			{ 'gI', '<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>', desc = 'Goto Implementation' },
			{ 'gy', '<cmd>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<cr>', desc = 'Goto T[y]pe Definition' },
			{ '<leader>ss', function() load() require('fzf-lua').lsp_document_symbols({ regex_filter = symbols_filter }) end, desc = 'Goto Symbol', has = 'documentSymbol' },
			{ '<leader>sS', function() load() require('fzf-lua').lsp_live_workspace_symbols({ regex_filter = symbols_filter }) end, desc = 'Goto Symbol (Workspace)', has = 'workspace/symbols' },
		},
	},
})

local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

-- NOTE: Conflict: editor.fzf wins over the snacks picker keys.
-- editor.telescope and editor.fff map some too.
-- stylua: ignore start
map('n', '<leader>,', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', 'Switch Buffer')
map('n', '<leader>/', pick('live_grep'), 'Grep (Root Dir)')
map('n', '<leader>:', '<cmd>FzfLua command_history<cr>', 'Command History')
-- NOTE: Conflict: rafi.config.keymaps' <leader><space> (Visual Mode) wins.
-- map('n', '<leader><space>', pick('files'), 'Find Files (Root Dir)')

-- Find
map('n', '<leader>fb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', 'Buffers')
map('n', '<leader>fB', '<cmd>FzfLua buffers<cr>', 'Buffers (all)')
map('n', '<leader>fc', pick.config_files(), 'Find Config File')
map('n', '<leader>ff', pick('files'), 'Find Files (Root Dir)')
map('n', '<leader>fF', pick('files', { root = false }), 'Find Files (cwd)')
map('n', '<leader>fg', '<cmd>FzfLua git_files<cr>', 'Find Files (git-files)')
map('n', '<leader>fr', '<cmd>FzfLua oldfiles<cr>', 'Recent')
map('n', '<leader>fR', pick('oldfiles', { cwd = vim.uv.cwd() }), 'Recent (cwd)')

-- Git
map('n', '<leader>gc', '<cmd>FzfLua git_commits<CR>', 'Commits')
-- NOTE: Conflict: editor.fzf wins over snacks' <leader>gd. git.fugitive maps it
-- too.
map('n', '<leader>gd', '<cmd>FzfLua git_diff<cr>', 'Git Diff (files)')
-- NOTE: Conflict: rafi.config.keymaps' <leader>gl (Git Log) wins.
-- map('n', '<leader>gl', '<cmd>FzfLua git_commits<CR>', 'Commits')
map('n', '<leader>gs', '<cmd>FzfLua git_status<CR>', 'Status')
map('n', '<leader>gS', '<cmd>FzfLua git_stash<cr>', 'Git Stash')

-- Search
map('n', '<leader>s"', '<cmd>FzfLua registers<cr>', 'Registers')
map('n', '<leader>s/', '<cmd>FzfLua search_history<cr>', 'Search History')
map('n', '<leader>sa', '<cmd>FzfLua autocmds<cr>', 'Auto Commands')
map('n', '<leader>sb', '<cmd>FzfLua lines<cr>', 'Buffer Lines')
map('n', '<leader>sc', '<cmd>FzfLua command_history<cr>', 'Command History')
map('n', '<leader>sC', '<cmd>FzfLua commands<cr>', 'Commands')
map('n', '<leader>sd', '<cmd>FzfLua diagnostics_workspace<cr>', 'Diagnostics')
map('n', '<leader>sD', '<cmd>FzfLua diagnostics_document<cr>', 'Buffer Diagnostics')
map('n', '<leader>sg', pick('live_grep'), 'Grep (Root Dir)')
map('n', '<leader>sG', pick('live_grep', { root = false }), 'Grep (cwd)')
map('n', '<leader>sh', '<cmd>FzfLua help_tags<cr>', 'Help Pages')
map('n', '<leader>sH', '<cmd>FzfLua highlights<cr>', 'Search Highlight Groups')
map('n', '<leader>sj', '<cmd>FzfLua jumps<cr>', 'Jumplist')
map('n', '<leader>sk', '<cmd>FzfLua keymaps<cr>', 'Key Maps')
map('n', '<leader>sl', '<cmd>FzfLua loclist<cr>', 'Location List')
map('n', '<leader>sM', '<cmd>FzfLua man_pages<cr>', 'Man Pages')
map('n', '<leader>sm', '<cmd>FzfLua marks<cr>', 'Jump to Mark')
map('n', '<leader>sR', '<cmd>FzfLua resume<cr>', 'Resume')
map('n', '<leader>sq', '<cmd>FzfLua quickfix<cr>', 'Quickfix List')
map('n', '<leader>sw', pick('grep_cword'), 'Word (Root Dir)')
map('n', '<leader>sW', pick('grep_cword', { root = false }), 'Word (cwd)')
map('x', '<leader>sw', pick('grep_visual'), 'Selection (Root Dir)')
map('x', '<leader>sW', pick('grep_visual', { root = false }), 'Selection (cwd)')

-- UI
map('n', '<leader>uC', pick('colorschemes'), 'Colorscheme with Preview')
-- stylua: ignore end

-- NOTE: Conflict: editor.todo-comments also maps <leader>st and <leader>sT.
if require('rafi.config').enabled('editor.todo-comments') then
	local function todo(opts)
		return function()
			vim.pack.add({
				'https://github.com/nvim-lua/plenary.nvim',
				'https://github.com/folke/todo-comments.nvim',
			})
			if vim.tbl_isempty(require('todo-comments.config').options) then
				require('todo-comments').setup({ signs = false })
			end
			require('todo-comments.fzf').todo(opts)
		end
	end
	map('n', '<leader>st', todo(), 'Todo')
	map(
		'n',
		'<leader>sT',
		todo({ keywords = { 'TODO', 'FIX', 'FIXME' } }),
		'Todo/Fix/Fixme'
	)
end
