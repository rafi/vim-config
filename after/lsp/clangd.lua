-- C/C++ language server
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/clangd.lua
---@type vim.lsp.Config
return {
	root_markers = {
		'compile_commands.json',
		'compile_flags.txt',
		'configure.ac', -- AutoTools
		'Makefile',
		'configure.in',
		'config.h.in',
		'meson.build',
		'meson_options.txt',
		'build.ninja',
		'.git',
	},
	capabilities = {
		offsetEncoding = { 'utf-16' },
	},
	cmd = {
		'clangd',
		'--background-index',
		'--clang-tidy',
		'--header-insertion=iwyu',
		'--completion-style=detailed',
		'--function-arg-placeholders',
		'--fallback-style=llvm',
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
		clangdFileStatus = true,
	},
}
