-- Supermaven AI completion (run `:SupermavenUseFree` or `:SupermavenUsePro`)
-- Inline suggestions when `vim.g.ai_cmp` is false, else a blink.cmp source.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/supermaven.lua
local blink = require('rafi.util.blink')

-- Make a blink.cmp transform that shows items with a custom kind `name`.
---@param name string
---@return fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
local function custom_kind(name)
	local idx ---@type integer?
	return function(_, items)
		if not idx then
			local kinds = require('blink.cmp.types').CompletionItemKind
			idx = #kinds + 1
			kinds[idx] = name
		end
		for _, item in ipairs(items) do
			item.kind = idx
			item.kind_name = name
		end
		return items
	end
end

-- Statusline icon, shown while the Supermaven agent runs.
require('rafi.util.lualine').add(
	'lualine_x',
	require('rafi.util.lualine').status(
		require('rafi.util.icons').kinds.Supermaven,
		function()
			if not package.loaded['supermaven-nvim.api'] then
				return
			end
			return require('supermaven-nvim.api').is_running() and 'ok' or 'error'
		end
	),
	2
)

local pack = require('rafi.pack')

if vim.g.ai_cmp then
	-- supermaven-nvim exposes an nvim-cmp source, blink.compat adapts it.
	blink.add_source('supermaven', {
		name = 'supermaven',
		module = 'blink.compat.source',
		transform_items = custom_kind('Supermaven'),
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
	-- blink.compat is only used as a completion source (vim.g.ai_cmp).
	vim.pack.add({
		'https://github.com/supermaven-inc/supermaven-nvim',
		'https://github.com/saghen/blink.compat',
	})

	require('supermaven-nvim').setup({
		keymaps = {
			accept_suggestion = nil, -- handled by blink.cmp
		},
		disable_inline_completion = vim.g.ai_cmp,
		ignore_filetypes = { 'bigfile', 'snacks_input', 'snacks_notif' },
	})
	require('supermaven-nvim.completion_preview').suggestion_group =
		'SupermavenSuggestion'
end

-- NOTE: Conflict: ai.copilot, ai.codeium and ai.copilot-native set this action
-- too.
-- Accept the suggestion as its own undo step.
function blink.actions.ai_accept()
	if not package.loaded['supermaven-nvim'] then
		return
	end
	local suggestion = require('supermaven-nvim.completion_preview')
	if suggestion.has_suggestion() then
		if vim.api.nvim_get_mode().mode == 'i' then
			vim.api.nvim_input('<c-G>u')
		end
		vim.schedule(function()
			suggestion.on_accept_suggestion()
		end)
		return true
	end
end

pack.on_event('InsertEnter', load)
pack.command({ 'SupermavenUseFree', 'SupermavenUsePro' }, load, { nargs = '*' })
