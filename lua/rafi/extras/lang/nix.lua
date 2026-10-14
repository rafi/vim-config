-- Nix: nil language server, nixfmt formatter and statix linter
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/nix.lua
require('rafi.util.lang').add({
	servers = { nil_ls = true },
	tools = { 'nixfmt', 'statix' },
	linters_by_ft = { nix = { 'statix' } },
	formatters_by_ft = { nix = { 'nixfmt' } },
})
