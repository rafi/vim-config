-- Native Copilot LSP inline completion (needs Neovim >= 0.12, `:LspCopilotSignIn`)
-- Suggestions are shown inline with vim.lsp.inline_completion, never in blink.cmp.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/copilot-native.lua
if vim.fn.has('nvim-0.12') == 0 then
	vim.notify(
		'You need Neovim >= 0.12 to use the `ai.copilot-native` extra.',
		vim.log.levels.ERROR
	)
	return
end
if require('rafi.config').enabled('ai.copilot') then
	vim.notify(
		'Please disable the `ai.copilot` extra to use `ai.copilot-native`',
		vim.log.levels.ERROR
	)
	return
end

-- Native inline completions don't work as regular completion items.
vim.g.ai_cmp = false

local blink = require('rafi.util.blink')

-- Register the `copilot` server and its suggestion cycling keys.
require('rafi.util.lang').add({
	servers = { copilot = true },
	keys = {
		copilot = {
			{
				'<M-]>',
				function()
					vim.lsp.inline_completion.select({ count = 1 })
				end,
				desc = 'Next Copilot Suggestion',
				mode = { 'i', 'n' },
			},
			{
				'<M-[>',
				function()
					vim.lsp.inline_completion.select({ count = -1 })
				end,
				desc = 'Prev Copilot Suggestion',
				mode = { 'i', 'n' },
			},
		},
	},
})

-- Server state per client id, from after/lsp/copilot.lua's status handler.
---@type table<integer, 'ok'|'error'|'pending'>
local states = {}
local augroup = vim.api.nvim_create_augroup('rafi_copilot_native', {})
vim.api.nvim_create_autocmd('User', {
	group = augroup,
	pattern = 'CopilotStatus',
	callback = function(ev)
		local status = ev.data.status
		states[ev.data.client_id] = status.kind ~= 'Normal' and 'error'
			or status.busy and 'pending'
			or 'ok'
	end,
})
vim.api.nvim_create_autocmd('LspDetach', {
	group = augroup,
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		-- Other buffers may still use the client.
		if not client or vim.tbl_count(client.attached_buffers) <= 1 then
			states[ev.data.client_id] = nil
		end
	end,
})

-- Statusline icon showing the copilot server's state.
require('rafi.util.lualine').add(
	'lualine_x',
	require('rafi.util.lualine').status(
		require('rafi.util.icons').kinds.Copilot,
		function()
			local client = vim.lsp.get_clients({ name = 'copilot', bufnr = 0 })[1]
			return client and states[client.id] or nil
		end
	),
	2
)

-- NOTE: Conflict: ai.copilot, ai.codeium and ai.supermaven set this action too.
-- Accept inline suggestions or next edits.
function blink.actions.ai_accept()
	return vim.lsp.inline_completion.get()
end

vim.schedule(function()
	vim.lsp.inline_completion.enable()
end)
