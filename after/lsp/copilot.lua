-- GitHub Copilot language server (extras ai.copilot-native, ai.sidekick)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/copilot-native.lua
---@type vim.lsp.Config
return {
	handlers = {
		-- Ask the user to sign in when the server reports an error status, and
		-- pass the status on as `User CopilotStatus` (ai.copilot-native's
		-- statusline icon uses it).
		didChangeStatus = function(err, res, ctx)
			if err then
				return
			end
			if res.status == 'Error' then
				vim.notify(
					'Please use `:LspCopilotSignIn` to sign in to Copilot',
					vim.log.levels.ERROR
				)
			end
			vim.api.nvim_exec_autocmds('User', {
				pattern = 'CopilotStatus',
				modeline = false,
				data = { client_id = ctx.client_id, status = res },
			})
		end,
	},
}
