-- gopls
--

local config = {
	settings = {
		gopls = {
			staticcheck = true,
			gofumpt = true,
			linksInHover = false,
			analyses = {
				fillreturns = true,
				nonewvars = true,
				undeclaredname = true,
				unusedparams = false,
				ST1000 = false,
				ST1005 = false,
			},
		},
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
	},
}

function goimports(timeout_ms)
	local context = { only = { "source.organizeImports" } }
	vim.validate { context = { context, "t", true } }

	local params = vim.lsp.util.make_range_params()
	params.context = context

	-- See the implementation of the textDocument/codeAction callback
	-- (lua/vim/lsp/handler.lua) for how to do this properly.
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
	if not result or next(result) == nil then return end
	local actions = result[1].result
	if not actions then return end
	local action = actions[1]

	-- textDocument/codeAction can return either Command[] or CodeAction[]. If it
	-- is a CodeAction, it can have either an edit, a command or both. Edits
	-- should be executed first.
	if action.edit or type(action.command) == "table" then
		if action.edit then
			vim.lsp.util.apply_workspace_edit(action.edit)
		end
		if type(action.command) == "table" then
			vim.lsp.buf.execute_command(action.command)
		end
	else
		vim.lsp.buf.execute_command(action)
	end
end

return {
	config = function(_) return config end,
}
