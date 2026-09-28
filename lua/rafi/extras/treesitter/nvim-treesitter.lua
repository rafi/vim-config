-- Tree-sitter parsers, highlight, indent and folds (nvim-treesitter main)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua
local pack = require('rafi.pack')
local ts = require('rafi.util.treesitter')

local opts = {
	-- Own directory, so parsers never mix with arborist's in site/parser.
	install_dir = vim.fn.stdpath('data') .. '/nvim-treesitter',
	indent = { enable = true },
	-- Skip files over 1 MB.
	highlight = { enable = true, max_filesize = 1024 * 1024 },
	folds = { enable = true },
	-- Lang extras' rafi.util.lang `parsers` are installed too.
	ensure_installed = {
		'bash',
		'c',
		'comment',
		'css',
		'csv',
		'cue',
		'diff',
		'dockerfile',
		'dtd',
		'editorconfig',
		'fish',
		'git_config',
		'git_rebase',
		'gitattributes',
		'gitcommit',
		'gitignore',
		'go',
		'graphql',
		'html',
		'http',
		'javascript',
		'jinja',
		'jsdoc',
		'json',
		'json5',
		'just',
		'lua',
		'luadoc',
		'luap',
		'make',
		'markdown',
		'markdown_inline',
		'mermaid',
		'printf',
		'proto',
		'python',
		'query',
		'readline',
		'regex',
		'scss',
		'sql',
		'ssh_config',
		'svelte',
		'toml',
		'tsx',
		'typescript',
		'typst',
		'vhs',
		'vim',
		'vimdoc',
		'xml',
		'yaml',
		'zig',
		'zsh',
	},
}

-- Parsers from lang extras (rafi.util.lang `parsers`, e.g. lang.bruno),
-- added to nvim-treesitter's registry whenever it reloads it.
vim.api.nvim_create_autocmd('User', {
	pattern = 'TSUpdate',
	group = vim.api.nvim_create_augroup('rafi.treesitter_parsers', {}),
	callback = function()
		local parsers = require('nvim-treesitter.parsers')
		for lang, p in pairs(require('rafi.util.lang').parsers) do
			parsers[lang] = parsers[lang]
				or {
					install_info = {
						url = p.url,
						location = p.location,
						queries = 'queries',
					},
					tier = 3,
				}
		end
	end,
})

-- Rebuild installed parsers after `vim.pack.update()` moves the plugin.
vim.api.nvim_create_autocmd('PackChanged', {
	group = vim.api.nvim_create_augroup('rafi.treesitter_build', {}),
	callback = function(ev)
		local data = ev.data
		if data.spec.name ~= 'nvim-treesitter' or data.kind ~= 'update' then
			return
		end
		if not data.active then
			vim.cmd.packadd('nvim-treesitter')
		end
		vim.schedule(function()
			ts.build(function()
				require('nvim-treesitter').update(nil, { summary = true })
			end)
		end)
	end,
})

---@param buf integer
---@return boolean
local function too_big(buf)
	local max = opts.highlight.max_filesize
	local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
	return ok and stat ~= nil and stat.size > max
end

-- Starts highlighting and sets indentexpr/foldexpr for a buffer whose
-- filetype has an installed parser with the matching query.
---@param ev vim.api.keyset.create_autocmd.callback_args
local function attach(ev)
	local ft = ev.match
	if not ts.have(ft) then
		return
	end
	---@param feat 'highlight'|'indent'|'folds'
	---@param query string
	local function enabled(feat, query)
		return opts[feat].enable ~= false and ts.have(ft, query)
	end
	if enabled('highlight', 'highlights') and not too_big(ev.buf) then
		pcall(vim.treesitter.start, ev.buf)
	end
	if enabled('indent', 'indents') then
		ts.set_default(
			'indentexpr',
			"v:lua.require'rafi.util.treesitter'.indentexpr()"
		)
	end
	if enabled('folds', 'folds') and ts.set_default('foldmethod', 'expr') then
		ts.set_default('foldexpr', "v:lua.require'rafi.util.treesitter'.foldexpr()")
	end
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		{
			src = 'https://github.com/nvim-treesitter/nvim-treesitter',
			version = 'main',
		},
	})
	local TS = require('nvim-treesitter')
	TS.setup({ install_dir = opts.install_dir })
	ts.get_installed(true)

	local wanted = vim.list_extend(
		vim.deepcopy(opts.ensure_installed),
		vim.tbl_keys(require('rafi.util.lang').parsers)
	)
	local install = vim.tbl_filter(function(lang)
		return not ts.get_installed()[lang]
	end, wanted)
	if #install > 0 then
		ts.build(function()
			TS.install(install, { summary = true }):await(function()
				ts.get_installed(true)
				-- Buffers opened while installing attach now.
				pack.refire_filetype('rafi.treesitter')
			end)
		end)
	end

	vim.api.nvim_create_autocmd('FileType', {
		group = vim.api.nvim_create_augroup('rafi.treesitter', {}),
		callback = attach,
	})
	pack.refire_filetype('rafi.treesitter')
end

pack.on_event('BufReadPre,BufNewFile', load)
pack.later(load)
