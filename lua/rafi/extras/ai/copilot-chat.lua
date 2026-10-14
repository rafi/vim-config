-- Chat with GitHub Copilot (CopilotChat.nvim)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/copilot-chat.lua
local pack = require('rafi.pack')

require('rafi.util.mini').on_which_key(function()
	require('which-key').add({
		{ '<leader>a', group = 'ai', mode = { 'n', 'x' } },
	})
end)

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/nvim-lua/plenary.nvim',
		{
			src = 'https://github.com/CopilotC-Nvim/CopilotChat.nvim',
			version = 'main',
		},
	})

	local user = vim.env.USER or 'User'
	user = user:sub(1, 1):upper() .. user:sub(2)

	vim.api.nvim_create_autocmd('BufEnter', {
		group = vim.api.nvim_create_augroup('rafi_copilot_chat', {}),
		pattern = 'copilot-chat',
		callback = function()
			vim.opt_local.relativenumber = false
			vim.opt_local.number = false
		end,
	})

	require('CopilotChat').setup({
		auto_insert_mode = true,
		headers = {
			user = '  ' .. user .. ' ',
			assistant = '  Copilot ',
			tool = '󰊳  Tool ',
		},
		window = {
			width = 0.4,
		},
	})
end

-- Load the plugin on first use of its commands.
pack.command({
	'CopilotChat',
	'CopilotChatPrompts',
	'CopilotChatModels',
	'CopilotChatOpen',
	'CopilotChatClose',
	'CopilotChatToggle',
	'CopilotChatStop',
	'CopilotChatReset',
	'CopilotChatSave',
	'CopilotChatLoad',
}, load, { complete = true })

local augroup = vim.api.nvim_create_augroup('rafi_copilot_chat_keys', {})

-- Blink's path source triggers on "/", which clashes with chat commands.
require('rafi.util.blink').disable_source('path', { 'copilot-chat' })

vim.api.nvim_create_autocmd('FileType', {
	group = augroup,
	pattern = 'copilot-chat',
	callback = function(ev)
		vim.keymap.set('n', '<C-s>', '<CR>', {
			buffer = ev.buf,
			remap = true,
			desc = 'Submit Prompt',
		})
	end,
})

-- NOTE: Conflict: ai.avante, ai.claudecode and ai.sidekick map <leader>aa,
-- ai.avante and ai.sidekick <leader>ap.
local function map(lhs, fn, desc)
	vim.keymap.set({ 'n', 'x' }, lhs, function()
		load()
		fn(require('CopilotChat'))
	end, { desc = desc })
end

map('<leader>aa', function(chat)
	chat.toggle()
end, 'Toggle (CopilotChat)')

map('<leader>ax', function(chat)
	chat.reset()
end, 'Clear (CopilotChat)')

map('<leader>aq', function(chat)
	vim.ui.input({ prompt = 'Quick Chat: ' }, function(input)
		if input and input ~= '' then
			chat.ask(input)
		end
	end)
end, 'Quick Chat (CopilotChat)')

map('<leader>ap', function(chat)
	chat.select_prompt()
end, 'Prompt Actions (CopilotChat)')
