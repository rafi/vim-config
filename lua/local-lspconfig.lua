local util = require 'plugins/lspconfig'
if vim.fn.has('vim_starting') then
	local lspconfig = require'lspconfig'
	local config = {
		cmd = { "ocamllsp" },
		filetypes = { 'ocaml' }
	}
	require'lspconfig'.ocamllsp.setup(config)

	local configs = require'lspconfig/configs'
	if not lspconfig.reason then
	  configs.reason = {
	    default_config = {
	      cmd = {'reason-language-server'};
	      filetypes = {'reason'};
	      root_dir = lspconfig.util.root_pattern(".git");
	      settings = {};
				on_attach = function(client, bufnr)
					require('lsp_signature').on_attach({
						bind = true,
						hint_enable = false,
						hint_prefix = ' ',  --  
						handler_opts = { border = 'rounded' },
						zindex = 50,
					}, bufnr)
				end
	    };
	  }
	end
	lspconfig.reason.setup(util.make_config("reason"))
end

-- return {
-- 	config = function(_) return config end,
-- }
