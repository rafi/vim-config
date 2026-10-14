-- Rust: rustaceanvim (rust-analyzer), crates.nvim for Cargo.toml
-- rustaceanvim loads itself on rust buffers, so it is not lazy-loaded.
-- Set `vim.g.rust_diagnostics = 'bacon-ls'` to get diagnostics from bacon-ls.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/rust.lua
local pack = require('rafi.pack')

local diagnostics = vim.g.rust_diagnostics or 'rust-analyzer'

-- rustaceanvim starts rust-analyzer itself, so lspconfig must not.
require('rafi.util.lang').add({
	servers = {
		rust_analyzer = false,
		bacon_ls = diagnostics == 'bacon-ls',
	},
	tools = diagnostics == 'bacon-ls' and { 'bacon' } or {},
})

vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, {
	server = {
		on_attach = function(_, bufnr)
			-- NOTE: Conflict: lang.rust wins over core '<leader>cR' in rust
			-- buffers when enabled.
			vim.keymap.set('n', '<leader>cR', function()
				vim.cmd.RustLsp('codeAction')
			end, { desc = 'Code Action', buffer = bufnr })
		end,
		default_settings = {
			['rust-analyzer'] = {
				cargo = {
					allFeatures = true,
					loadOutDirsFromCheck = true,
					buildScripts = { enable = true },
				},
				-- Add clippy lints for Rust if using rust-analyzer
				checkOnSave = diagnostics == 'rust-analyzer',
				-- Enable diagnostics if using rust-analyzer
				diagnostics = { enable = diagnostics == 'rust-analyzer' },
				procMacro = { enable = true },
				files = {
					exclude = {
						'.direnv',
						'.git',
						'.jj',
						'.github',
						'.gitlab',
						'bin',
						'node_modules',
						'target',
						'venv',
						'.venv',
					},
					-- Avoid Roots Scanned hanging, see
					-- https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
					watcher = 'client',
				},
			},
		},
	},
})

-- Warn once, when the first rust buffer opens, if rust-analyzer is missing.
pack.on_filetype('rust', function()
	if vim.fn.executable('rust-analyzer') == 0 then
		vim.notify(
			'**rust-analyzer** not found in PATH, please install it.\n'
				.. 'https://rust-analyzer.github.io/',
			vim.log.levels.ERROR,
			{ title = 'rustaceanvim' }
		)
	end
end)

vim.pack.add({ 'https://github.com/mrcjkb/rustaceanvim' })

local crates_loaded = false

-- Load crates.nvim and run it for the Cargo.toml buffer that triggered it.
local function load_crates()
	if crates_loaded then
		return
	end
	crates_loaded = true
	vim.pack.add({ 'https://github.com/Saecki/crates.nvim' })
	require('crates').setup({
		completion = { crates = { enabled = true } },
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
	})
end

pack.on_event('BufRead~Cargo.toml', load_crates)
