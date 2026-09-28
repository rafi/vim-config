-- Go: gopls (after/lsp/gopls.lua), tools, golangci-lint and formatters
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/go.lua
require('rafi.util.lang').add({
	servers = { gopls = true },
	tools = {
		'goimports',
		'gofumpt',
		'golangci-lint',
		'goimports-reviser',
		'gomodifytags',
		'impl',
		'json-to-struct',
	},
	linters_by_ft = { go = { 'golangcilint' } },
	formatters_by_ft = { go = { 'goimports', 'gofumpt' } },
})

-- Convert a JSON selection to a Go struct, named after the file.
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi.lang.go', {}),
	pattern = 'go',
	callback = function(ev)
		vim.api.nvim_buf_create_user_command(
			ev.buf,
			'JsonToStruct',
			---@param args vim.api.keyset.create_user_command.command_args
			function(args)
				local range = args.line1 .. ',' .. args.line2
				local fname = vim.api.nvim_buf_get_name(0)
				local cmd = { '!json-to-struct' }
				table.insert(cmd, '-name ' .. vim.fn.fnamemodify(fname, ':t:r'))
				table.insert(cmd, '-pkg ' .. vim.fn.fnamemodify(fname, ':h:t:r'))
				vim.cmd(range .. ' ' .. table.concat(cmd, ' '))
			end,
			{ bar = true, nargs = 0, range = true }
		)
	end,
})
