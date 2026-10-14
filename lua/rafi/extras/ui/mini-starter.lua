-- Start screen (mini.starter), alternative to ui.alpha
-- Does nothing when ui.alpha is enabled, since both open a dashboard.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ui/mini-starter.lua
if require('rafi.config').enabled('ui.alpha') then
	vim.schedule(function()
		vim.notify(
			'ui.mini-starter is skipped: it cannot run together with ui.alpha.'
				.. ' Disable one of them in :RafiExtras.',
			vim.log.levels.WARN
		)
	end)
	return
end

local pick = require('rafi.util.pick')

-- Loads at startup so the start screen opens on VimEnter.
vim.pack.add({ 'https://github.com/nvim-mini/mini.starter' })

local logo = table.concat({
	'███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
	'████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
	'██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
	'██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
	'██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
	'╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
}, '\n')
local pad = string.rep(' ', 22)

local function new_section(name, action, section)
	return { name = name, action = action, section = pad .. section }
end

-- Opens :Packman when available, else vim.pack's update buffer.
local function plugins()
	if vim.fn.exists(':Packman') == 2 then
		vim.cmd.Packman()
	else
		vim.pack.update(nil, { offline = true })
	end
end

local starter = require('mini.starter')

-- Picker entries use the picker set in rafi.util.pick.
-- stylua: ignore
local items = {
	new_section('Find file',     pick(),                       'Picker'),
	new_section('New file',      'ene | startinsert',          'Built-in'),
	new_section('Recent files',  pick('oldfiles'),             'Picker'),
	new_section('Find text',     pick('live_grep'),            'Picker'),
	new_section('Config',        pick.config_files(),          'Config'),
}
if require('rafi.config').enabled('editor.auto-session') then
	table.insert(
		items,
		new_section('Restore session', 'AutoSession restore', 'Session')
	)
end
vim.list_extend(items, {
	new_section('Rafi Extras', 'RafiExtras', 'Config'),
	new_section('Plugins', plugins, 'Config'),
	new_section('Quit', 'qa', 'Built-in'),
})

starter.setup({
	evaluate_single = true,
	header = logo,
	items = items,
	content_hooks = {
		starter.gen_hook.adding_bullet(pad .. '░ ', false),
		starter.gen_hook.aligning('center', 'center'),
	},
})

-- Footer shows the plugin count.
require('rafi.pack').later(function()
	local all = vim.pack.get(nil, { info = false })
	local active = #vim.tbl_filter(function(p)
		return p.active
	end, all)
	starter.config.footer = string.rep(' ', 8)
		.. ('⚡ Neovim loaded %d/%d plugins'):format(active, #all)
	if vim.bo.filetype == 'ministarter' then
		pcall(starter.refresh)
	end
end)
