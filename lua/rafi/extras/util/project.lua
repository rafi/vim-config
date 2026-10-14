-- Recent projects list and root detection (project.nvim)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/util/project.lua
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/ahmedkhalf/project.nvim' })
	-- Manual mode. Add projects with :ProjectRoot or :AddProject.
	require('project_nvim').setup({ manual_mode = true })
end

pack.later(load)

-- Recent projects in a snacks picker. Selecting one changes the directory
-- and opens the file picker there.
local function pick_project()
	load()
	local history = require('project_nvim.utils.history')
	local items = {}
	local recent = history.get_recent_projects()
	for i = #recent, 1, -1 do
		items[#items + 1] = { text = recent[i], file = recent[i], dir = true }
	end
	Snacks.picker.pick({
		title = 'Projects',
		items = items,
		format = 'file',
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end
			require('project_nvim.project').set_pwd(item.file, 'snacks')
			require('rafi.util.pick').open('files', { cwd = item.file, root = false })
		end,
	})
end

-- Stubs load the plugin first, setup() defines these commands.
pack.command({ 'ProjectRoot', 'AddProject' }, load, { nargs = 0 })

-- NOTE: Conflict: project wins over snacks <leader>fp (Projects) when enabled
vim.keymap.set('n', '<leader>fp', pick_project, { desc = 'Projects' })

-- Add a "Projects" button to the alpha dashboard, after "Find text".
local function add_alpha_button()
	local ok, dashboard = pcall(require, 'alpha.themes.dashboard')
	if not ok or not package.loaded['alpha'] then
		return false
	end
	local buttons = dashboard.section.buttons.val
	local at = #buttons + 1
	for i, el in ipairs(buttons) do
		if el.type == 'button' and el.opts and el.opts.shortcut == 'g' then
			at = i + 1
		end
	end
	local el = dashboard.button('P', ' ' .. ' Projects (util.project)')
	el.on_press = pick_project
	el.opts.hl = 'AlphaButtons'
	el.opts.hl_shortcut = 'AlphaShortcut'
	table.insert(buttons, at, el)
	return true
end

if package.loaded['alpha.themes.dashboard'] then
	add_alpha_button()
else
	pack.later(function()
		if package.loaded['alpha.themes.dashboard'] and add_alpha_button() then
			pcall(vim.cmd.AlphaRedraw)
		end
	end)
end
