-- plugin: lsp_signature.nvim
-- see: https://github.com/ray-x/lsp_signature.nvim
-- rafi settings

require 'lsp_signature'.on_attach({
	bind = true,
	hint_enable = false,
	-- hint_prefix = '🐼 ',
	-- hint_scheme = 'String',
	handler_opts = { border = 'single' },
	-- decorator = {"**", "**"},
})
