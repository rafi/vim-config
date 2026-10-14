-- Next edit suggestions with the Copilot LSP server, and AI CLI sessions
-- (sidekick.nvim)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/sidekick.lua
local blink = require('rafi.util.blink')
local pack = require('rafi.pack')

require('rafi.util.mini').on_which_key(function()
	require('which-key').add({
		{ '<leader>a', group = 'ai', mode = { 'n', 'v' } },
	})
end)

-- Next edit suggestions need the Copilot language server. It is shared
-- with ai.copilot-native.
require('rafi.util.lang').add({
	servers = { copilot = true },
})

-- Statusline: Copilot status and the number of attached CLI sessions.
local lualine = require('rafi.util.lualine')
local icons = {
	Error = { ' ', 'DiagnosticError' },
	Inactive = { ' ', 'MsgArea' },
	Warning = { ' ', 'DiagnosticWarn' },
	Normal = { require('rafi.util.icons').kinds.Copilot, 'Special' },
}

-- Sidekick's status, or nil until the plugin is loaded.
local function sidekick_status()
	if package.loaded['sidekick'] then
		return require('sidekick.status').get()
	end
end

lualine.add('lualine_x', {
	function()
		local status = sidekick_status()
		return status and vim.tbl_get(icons, status.kind, 1)
	end,
	cond = function()
		return sidekick_status() ~= nil
	end,
	color = function()
		local status = sidekick_status()
		local hl = status
			and (
				status.busy and 'DiagnosticWarn' or vim.tbl_get(icons, status.kind, 2)
			)
		return { fg = Snacks.util.color(hl) }
	end,
}, 2)

lualine.add('lualine_x', {
	function()
		local status = require('sidekick.status').cli()
		return ' ' .. (#status > 1 and #status or '')
	end,
	cond = function()
		return package.loaded['sidekick'] ~= nil
			and #require('sidekick.status').cli() > 0
	end,
	color = function()
		return { fg = Snacks.util.color('Special') }
	end,
}, 2)

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/folke/sidekick.nvim' })
	require('sidekick').setup({})

	-- Accept inline suggestions or next edits
	blink.actions.ai_nes = function()
		local Nes = require('sidekick.nes')
		if Nes.have() and (Nes.jump() or Nes.apply()) then
			return true
		end
	end

	Snacks.toggle({
		name = 'Sidekick NES',
		get = function()
			return require('sidekick.nes').enabled
		end,
		set = function(state)
			require('sidekick.nes').enable(state)
		end,
	}):map('<leader>uN')

	-- Send picker selections to the CLI with <a-a>.
	Snacks.config.picker = Snacks.config.merge(Snacks.config.picker or {}, {
		actions = {
			sidekick_send = function(...)
				return require('sidekick.cli.picker.snacks').send(...)
			end,
		},
		win = {
			input = {
				keys = {
					['<a-a>'] = { 'sidekick_send', mode = { 'n', 'i' } },
				},
			},
		},
	})
end

-- Load after startup so suggestions and status work before any key.
pack.later(load)

-- Normal mode <Tab>: jump to or apply the next edit suggestion.
vim.keymap.set('n', '<Tab>', function()
	load()
	local done = blink.map({ 'ai_nes' })()
	return done and '' or '<Tab>'
end, { expr = true, desc = 'Goto/Apply Next Edit Suggestion' })

---@param mode string|string[]
---@param lhs string
---@param fn fun(cli: table)
---@param desc string
local function map(mode, lhs, fn, desc)
	vim.keymap.set(mode, lhs, function()
		load()
		fn(require('sidekick.cli'))
	end, { desc = desc })
end

-- stylua: ignore start
-- NOTE: Conflict: coding.sibling-swap maps <C-.> too.
map({ 'n', 't', 'i', 'x' }, '<C-.>', function(cli) cli.focus() end, 'Sidekick Focus')

-- NOTE: Conflict: ai.copilot-chat, ai.avante and ai.claudecode map <leader>aa
-- too.
map('n', '<leader>aa', function(cli) cli.toggle() end, 'Sidekick Toggle CLI')

-- NOTE: Conflict: ai.avante maps <leader>as too.
map('n', '<leader>as', function(cli) cli.select() end, 'Select CLI')

-- NOTE: Conflict: ai.claudecode maps <leader>ad too.
map('n', '<leader>ad', function(cli) cli.close() end, 'Detach a CLI Session')

-- NOTE: Conflict: ai.avante maps <leader>at too.
map({ 'x', 'n' }, '<leader>at', function(cli) cli.send({ msg = '{this}' }) end, 'Send This')

-- NOTE: Conflict: ai.avante and ai.claudecode map <leader>af too.
map('n', '<leader>af', function(cli) cli.send({ msg = '{file}' }) end, 'Send File')

map('x', '<leader>av', function(cli) cli.send({ msg = '{selection}' }) end, 'Send Visual Selection')

-- NOTE: Conflict: ai.copilot-chat and ai.avante map <leader>ap too.
map({ 'n', 'x' }, '<leader>ap', function(cli) cli.prompt() end, 'Sidekick Select Prompt')
-- stylua: ignore end
