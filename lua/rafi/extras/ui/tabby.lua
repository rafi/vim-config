-- Tabpage-based tabline with tab rename, window picker and jump mode
local pack = require('rafi.pack')

-- NOTE: Conflict: ui.bufferline also sets 'tabline'.

-- Neovim's own tabline groups, so the colorscheme decides how tabs look.
local theme = {
	fill = 'TabLineFill',
	current_tab = 'TabLineSel',
	tab = 'TabLine',
	tail = 'TabLine',
	offset = 'TabLineFill',
}

-- Slanted edges between tabs. Defined once per colorscheme, not on
-- every redraw.
---@type table<string, string> tab group -> edge group
local edge_hl = {
	[theme.tab] = 'RafiTabbyEdge',
	[theme.current_tab] = 'RafiTabbyEdgeSel',
}
local edges_stale = true

local function define_edges()
	local function bg(name)
		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		return hl.reverse and hl.fg or hl.bg
	end
	local fill = bg(theme.fill)
	for group, edge in pairs(edge_hl) do
		vim.api.nvim_set_hl(0, edge, { fg = fill, bg = bg(group) })
	end
	edges_stale = false
end

vim.api.nvim_create_autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('rafi.tabby', {}),
	callback = function()
		edges_stale = true
	end,
})

-- Title shown over a sidebar, so tabs start where the editing area starts.
---@type table<string, string>
local offsets = {
	snacks_layout_box = '󰙅  File Explorer',
	['neo-tree'] = '󰙅  Neo-tree',
}

-- Sidebar window at the left edge of the current tab, and its title.
---@return integer? win
---@return string? title
local function find_sidebar()
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
		if offsets[ft] and vim.api.nvim_win_get_position(win)[2] == 0 then
			return win, offsets[ft]
		end
	end
end

-- Whether focus is in the sidebar. Snacks' explorer is floats laid over
-- the sidebar, so the check is by position.
---@param win integer?
---@return boolean
local function sidebar_focused(win)
	if not win then
		return false
	end
	local cur = vim.api.nvim_get_current_win()
	if cur == win then
		return true
	end
	local row, col = unpack(vim.api.nvim_win_get_position(win))
	local cur_row, cur_col = unpack(vim.api.nvim_win_get_position(cur))
	return cur_row >= row
		and cur_row < row + vim.api.nvim_win_get_height(win)
		and cur_col >= col
		and cur_col < col + vim.api.nvim_win_get_width(win)
end

-- Sidebar title centered over its width, with a separator for splits.
---@param win integer?
---@param title string?
---@return TabbyNode
local function left_offset(win, title)
	if not win or not title then
		return ''
	end
	local width = vim.api.nvim_win_get_width(win)
	local pad = math.max(width - vim.fn.strdisplaywidth(title), 0)
	local left = math.floor(pad / 2)
	local text = (' '):rep(left) .. title .. (' '):rep(pad - left)
	return {
		vim.fn.strcharpart(text, 0, width),
		vim.api.nvim_win_get_config(win).relative == '' and '│' or '',
		hl = theme.offset,
	}
end

-- Tab name. While the sidebar has focus, names the file you came from
-- instead of "[Floating]".
---@param tabid integer
---@return string
local function tab_name_fallback(tabid)
	local api = require('tabby.module.api')
	local win = api.get_tab_current_win(tabid)
	if tabid == api.get_current_tab() and sidebar_focused(find_sidebar()) then
		local prev = vim.fn.win_getid(vim.fn.winnr('#'))
		local candidates = { prev, unpack(api.get_tab_wins(tabid)) }
		for _, w in ipairs(candidates) do
			local ft = w > 0
				and vim.api.nvim_win_is_valid(w)
				and vim.bo[vim.api.nvim_win_get_buf(w)].filetype
			if ft and not offsets[ft] and api.is_not_float_win(w) then
				win = w
				break
			end
		end
	end
	return api.is_float_win(win) and '[Floating]'
		or require('tabby.feature.win_name').get(win)
end

-- Window count and modified mark after the tab name. Floats aren't
-- counted, so opening the explorer doesn't change it.
---@param tabid integer
---@return string
local function tab_status(tabid)
	local count, modified = 0, false
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
		if vim.api.nvim_win_get_config(win).relative == '' then
			count = count + 1
		end
		modified = modified or vim.bo[vim.api.nvim_win_get_buf(win)].modified
	end
	return (count > 1 and ' [' .. count .. ']' or '')
		.. (modified and ' 󰏫' or '')
end

-- Tabs on the left. Project name and session mark on the right.
---@param line TabbyLine
local function render(line)
	if edges_stale then
		define_edges()
	end
	local sidebar, title = find_sidebar()
	local focused = sidebar_focused(sidebar)
	local icons = _G.MiniIcons
	return {
		left_offset(sidebar, title),
		line.tabs().foreach(function(tab)
			-- No tab is active while the sidebar has focus.
			local hl = tab.is_current() and not focused and theme.current_tab
				or theme.tab
			local name = tab.name()
			return {
				{ '', hl = edge_hl[hl] },
				tab.in_jump_mode() and tab.jump_key() .. ' ' or '  ',
				icons and icons.get('file', name) .. '  ' or '',
				name,
				tab_status(tab.id),
				'   ',
				{ '', hl = edge_hl[hl] },
				hl = hl,
			}
		end),
		line.spacer(),
		{
			{ '', hl = edge_hl[theme.tail] },
			' ' .. vim.fn.fnamemodify(require('rafi.util.root')(), ':t'),
			vim.v.this_session ~= '' and '  ' or '',
			' ',
			{ '', hl = edge_hl[theme.tail] },
			hl = theme.tail,
		},
		hl = theme.fill,
	}
end

-- Tabby loads after startup. Until then show an empty bar instead of
-- the default tabline.
vim.o.tabline = '%#' .. theme.fill .. '#'
pack.later(function()
	vim.pack.add({ 'https://github.com/nanozuki/tabby.nvim' })
	require('tabby').setup({
		line = render,
		option = { tab_name = { name_fallback = tab_name_fallback } },
	})
end)

vim.keymap.set('n', '<leader><tab>r', function()
	vim.ui.input({ prompt = 'Tab name: ' }, function(name)
		if name then
			vim.cmd({ cmd = 'Tabby', args = { 'rename_tab', name } })
		end
	end)
end, { desc = 'Rename Tab' })

-- stylua: ignore start
vim.keymap.set('n', '<leader><tab>w', '<Cmd>Tabby pick_window<CR>', { desc = 'Pick Window' })
vim.keymap.set('n', '<leader><tab>j', '<Cmd>Tabby jump_to_tab<CR>', { desc = 'Jump to Tab' })
-- stylua: ignore end
