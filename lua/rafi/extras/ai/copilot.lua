-- GitHub Copilot via copilot.lua (run `:Copilot auth` once to sign in)
-- Inline suggestions when `vim.g.ai_cmp` is false, else a blink.cmp source.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/copilot.lua
local blink = require('rafi.util.blink')
local pack = require('rafi.pack')

-- copilot.lua runs its own server, so keep the native `copilot` LSP
-- server (ai.copilot-native) off.
require('rafi.util.lang').add({ servers = { copilot = false } })

if vim.g.ai_cmp then
	blink.add_source('copilot', {
		name = 'copilot',
		module = 'blink-copilot',
		score_offset = 100,
		async = true,
	})
end

-- Statusline icon: copilot.lua's state while its server is attached.
require('rafi.util.lualine').add(
	'lualine_x',
	require('rafi.util.lualine').status(
		require('rafi.util.icons').kinds.Copilot,
		function()
			if not package.loaded['copilot'] then
				return
			end
			local clients = vim.lsp.get_clients({ name = 'copilot', bufnr = 0 })
			if #clients == 0 then
				return
			end
			local status = require('copilot.status').data.status
			return (status == 'InProgress' and 'pending')
				or (status == 'Warning' and 'error')
				or 'ok'
		end
	),
	2
)

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- blink-copilot is only used as a completion source (vim.g.ai_cmp).
	vim.pack.add({
		'https://github.com/zbirenbaum/copilot.lua',
		'https://github.com/fang2hou/blink-copilot',
	})

	require('copilot').setup({
		suggestion = {
			enabled = not vim.g.ai_cmp,
			auto_trigger = true,
			hide_during_completion = vim.g.ai_cmp,
			keymap = {
				accept = false, -- handled by blink.cmp
				next = '<M-]>',
				prev = '<M-[>',
			},
		},
		panel = { enabled = false },
		filetypes = {
			markdown = true,
			help = true,
		},
	})
end

-- NOTE: Conflict: ai.codeium, ai.supermaven and ai.copilot-native set this
-- action too.
-- Accept the suggestion as its own undo step.
function blink.actions.ai_accept()
	if not package.loaded['copilot'] then
		return
	end
	if require('copilot.suggestion').is_visible() then
		if vim.api.nvim_get_mode().mode == 'i' then
			vim.api.nvim_input('<c-G>u')
		end
		require('copilot.suggestion').accept()
		return true
	end
end

pack.on_event('BufReadPost', load)
-- Empty buffers never fire BufReadPost, and the blink source needs the plugin.
pack.on_event('InsertEnter', load)
pack.command('Copilot', load, { nargs = '*', complete = true })
