-- Fast and fully programmable greeter dashboard (alpha-nvim)

-- Eager: setup registers the VimEnter autocmd that opens the dashboard.
-- It runs after auto-session's, so a restored session skips it.
vim.pack.add({ 'https://github.com/goolord/alpha-nvim' })

local dashboard = require('alpha.themes.dashboard')
local pick = require('rafi.util.pick')
local theta = require('alpha.themes.theta')
local cdir = vim.fn.getcwd()

-- dashboard.button() with a Lua function action: its on_press feeds the
-- action as keys, which only works for strings.
local function button(sc, txt, action)
	local el = dashboard.button(sc, txt, action)
	if type(action) == 'function' then
		el.on_press = action
	end
	return el
end

-- stylua: ignore
dashboard.section.buttons.val = {
	{
		type = 'group',
		val = {
			{
				type = 'text',
				val = 'Recent files',
				opts = {
					hl = 'SpecialComment',
					shrink_margin = false,
					position = 'center',
				},
			},
			{ type = 'padding', val = 1 },
			{
				type = 'group',
				val = function()
					return { theta.mru(0, cdir, 5) }
				end,
				opts = { shrink_margin = false },
			},
		},
	},
	{ type = 'padding', val = 2 },

	{ type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
	{ type = 'padding', val = 1 },
	button('f', ' ' .. ' Find file',       pick()),
	button('n', ' ' .. ' New file',        [[<cmd> ene <BAR> startinsert <CR>]]),
	button('r', ' ' .. ' Recent files',    pick('oldfiles')),
	button('g', ' ' .. ' Find text',       pick('live_grep')),
	{ type = 'text', val = '-------', opts = { hl = 'Comment', position = 'center' } },
	button('c', ' ' .. ' Config',          pick.config_files()),
	button('s', ' ' .. ' Restore Session', '<cmd> AutoSession restore <CR>'),
	button('u', ' ' .. ' Update plugins',  '<cmd> lua vim.pack.update() <CR>'),
	button('x', ' ' .. ' Rafi Extras',     '<cmd> RafiExtras <CR>'),
	button('l', '󰒲 ' .. ' Plugins',         '<cmd> lua vim.pack.update(nil, { offline = true }) <CR>'),
	button('q', ' ' .. ' Quit',            '<cmd> qa <CR>'),
	{ type = 'padding', val = 1 },
}
for _, button in ipairs(dashboard.section.buttons.val) do
	if button.on_press then
		button.opts.hl = 'AlphaButtons'
		button.opts.hl_shortcut = 'AlphaShortcut'
	end
end
dashboard.section.header.opts.hl = 'AlphaHeader'
dashboard.section.buttons.opts.hl = 'AlphaButtons'
dashboard.section.buttons.opts.spacing = 0
dashboard.section.footer.opts.hl = 'AlphaFooter'

require('alpha').setup(dashboard.opts)

-- Footer: plugin count once deferred plugins have loaded.
require('rafi.pack').later(function()
	local plugins = vim.pack.get(nil, { info = false })
	local active = #vim.tbl_filter(function(p)
		return p.active
	end, plugins)
	dashboard.section.footer.val = ('⚡ Neovim loaded %d/%d plugins'):format(
		active,
		#plugins
	)
	pcall(vim.cmd.AlphaRedraw)
end)
