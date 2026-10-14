-- Claude Code integration (claudecode.nvim)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/claudecode.lua
local pack = require('rafi.pack')

require('rafi.util.mini').on_which_key(function()
	require('which-key').add({
		{ '<leader>a', group = 'ai', mode = { 'n', 'v' } },
	})
end)

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/coder/claudecode.nvim' })
	require('claudecode').setup({})
end

-- setup() defines these, and starts the local server Claude connects to.
pack.command({
	'ClaudeCode',
	'ClaudeCodeFocus',
	'ClaudeCodeOpen',
	'ClaudeCodeClose',
	'ClaudeCodeStart',
	'ClaudeCodeStop',
	'ClaudeCodeStatus',
	'ClaudeCodeAdd',
	'ClaudeCodeSend',
	'ClaudeCodeSendText',
	'ClaudeCodeTreeAdd',
	'ClaudeCodeSelectModel',
	'ClaudeCodeDiffAccept',
	'ClaudeCodeDiffDeny',
	'ClaudeCodeCloseAllDiffs',
}, load, { complete = true })

---@param mode string|string[]
---@param lhs string
---@param cmd string
---@param desc string
---@param opts? vim.keymap.set.Opts
local function map(mode, lhs, cmd, desc, opts)
	vim.keymap.set(mode, lhs, function()
		vim.cmd(cmd)
	end, vim.tbl_extend('force', { desc = desc }, opts or {}))
end

-- NOTE: Conflict: ai.avante maps <leader>ac, <leader>ar and <leader>af, and
-- ai.sidekick <leader>af.
map('n', '<leader>ac', 'ClaudeCode', 'Toggle Claude')
map('n', '<leader>af', 'ClaudeCodeFocus', 'Focus Claude')
map('n', '<leader>ar', 'ClaudeCode --resume', 'Resume Claude')
map('n', '<leader>aC', 'ClaudeCode --continue', 'Continue Claude')
map('n', '<leader>ab', 'ClaudeCodeAdd %', 'Add current buffer')
-- NOTE: Conflict: ai.avante and ai.sidekick map <leader>as in normal mode.
-- This one is visual mode only, so they rarely clash.
map('v', '<leader>as', 'ClaudeCodeSend', 'Send to Claude')
-- Diff management
-- NOTE: Conflict: ai.copilot-chat, ai.avante and ai.sidekick map <leader>aa,
-- and ai.sidekick <leader>ad.
map('n', '<leader>aa', 'ClaudeCodeDiffAccept', 'Accept diff')
map('n', '<leader>ad', 'ClaudeCodeDiffDeny', 'Deny diff')

-- Add the file under the cursor from a file explorer.
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi_claudecode_keys', {}),
	pattern = { 'NvimTree', 'neo-tree', 'oil', 'snacks_picker_list' },
	callback = function(ev)
		map('n', '<leader>as', 'ClaudeCodeTreeAdd', 'Add file', {
			buffer = ev.buf,
		})
	end,
})
