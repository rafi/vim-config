-- Codeium via windsurf.nvim (run `:Codeium Auth` once to sign in)
-- Inline suggestions when `vim.g.ai_cmp` is false, else a blink.cmp source.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/codeium.lua
local blink = require('rafi.util.blink')

-- Statusline icon, shown once codeium's virtual text is running.
require('rafi.util.lualine').add(
	'lualine_x',
	require('rafi.util.lualine').status(
		require('rafi.util.icons').kinds.Codeium,
		function()
			if not package.loaded['codeium.virtual_text'] then
				return
			end
			local ok, status = pcall(require('codeium.virtual_text').status)
			if not ok then
				return
			end
			return status.state == 'waiting' and 'pending' or 'ok'
		end
	),
	2
)

local pack = require('rafi.pack')

if vim.g.ai_cmp then
	-- windsurf.nvim ships a native blink.cmp source.
	blink.add_source('codeium', {
		name = 'Codeium',
		module = 'codeium.blink',
		score_offset = 100,
		async = true,
	})
end

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/Exafunction/windsurf.nvim',
		-- Its io module requires plenary.
		'https://github.com/nvim-lua/plenary.nvim',
	})

	require('codeium').setup({
		enable_cmp_source = false, -- blink.cmp uses the native source
		virtual_text = {
			enabled = not vim.g.ai_cmp,
			key_bindings = {
				accept = false, -- handled by blink.cmp
				next = '<M-]>',
				prev = '<M-[>',
			},
		},
	})
end

-- NOTE: Conflict: ai.copilot, ai.supermaven and ai.copilot-native set this
-- action too.
-- Accept the completion as its own undo step.
function blink.actions.ai_accept()
	if not package.loaded['codeium'] then
		return
	end
	if require('codeium.virtual_text').get_current_completion_item() then
		if vim.api.nvim_get_mode().mode == 'i' then
			vim.api.nvim_input('<c-G>u')
		end
		vim.api.nvim_input(require('codeium.virtual_text').accept())
		return true
	end
end

pack.on_event('InsertEnter', load)
pack.command('Codeium', load, { nargs = '*', complete = true })
