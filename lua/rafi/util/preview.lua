-- Util: Preview (requires telescope)
-- https://github.com/rafi/vim-config

---@class rafi.util.preview
local M = {}

local opts = {}

local default_opts = {
	popup = {
		enter = false,
		-- moved = 'any',  -- doesn't work.
		focusable = true,
		noautocmd = true,
		relative = 'cursor',
		line = 'cursor',
		col = 'cursor+31',
		minwidth = math.ceil(vim.o.columns / 2),
		minheight = math.ceil(vim.o.lines / 1.5),
		border = true,
		borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
		highlight = 'Normal',
		borderhighlight = 'FloatBorder',
		titlehighlight = 'Title',
		zindex = 100,
	},
}

opts = vim.deepcopy(default_opts)

---@param popup_state table
---@param augroup integer
local function close(popup_state, augroup)
	vim.schedule(function()
		local utils = require('telescope.utils')
		pcall(vim.api.nvim_del_augroup_by_id, augroup)
		utils.win_delete('preview_border_win', popup_state.win_id, true, true)
		if popup_state.border and popup_state.border.win_id then
			utils.win_delete(
				'preview_border_win',
				popup_state.border.win_id,
				true,
				true
			)
		end
	end)
end

---@param user_opts table
function M.setup(user_opts)
	user_opts = vim.F.if_nil(user_opts, {})
	opts = vim.tbl_deep_extend('keep', user_opts, default_opts)
end

--- Open file preview with optional line/column position.
---@param path string
---@param lnum number?
---@param column number?
function M.open(path, lnum, column)
	local bufnr = vim.api.nvim_get_current_buf()
	local popup = require('plenary.popup')
	opts.popup.title = path
	local winid, popup_state = popup.create('', opts.popup)
	local popup_bufnr = vim.api.nvim_win_get_buf(winid)

	-- Ensure best viewing options are toggled.
	local scope = { scope = 'local', win = winid }
	vim.api.nvim_set_option_value('number', true, scope)
	vim.api.nvim_set_option_value('relativenumber', false, scope)
	vim.api.nvim_set_option_value('wrap', false, scope)
	vim.api.nvim_set_option_value('spell', false, scope)
	vim.api.nvim_set_option_value('list', false, scope)
	vim.api.nvim_set_option_value('foldenable', false, scope)
	vim.api.nvim_set_option_value('cursorline', false, scope)
	vim.api.nvim_set_option_value('signcolumn', 'no', scope)
	vim.api.nvim_set_option_value('colorcolumn', '', scope)
	vim.api.nvim_set_option_value(
		'winhighlight',
		'Normal:NormalFloat,CursorLine:TelescopePreviewMatch',
		scope
	)

	-- Jump to line number if provided.
	local previewer_opts = {}
	if lnum ~= nil and lnum > 0 then
		vim.api.nvim_set_option_value('cursorline', true, scope)
		local colstart = column or 0
		previewer_opts.callback = function()
			pcall(vim.api.nvim_win_set_cursor, winid, { lnum, colstart })
		end
	end

	-- Run telescope preview.
	local previewer = require('telescope.config').values.buffer_previewer_maker
	previewer(path, popup_bufnr, previewer_opts)

	-- Setup close events
	local augroup = vim.api.nvim_create_augroup('preview_window_' .. winid, {})

	-- Close the preview window when entered a buffer that is not
	-- the floating window buffer or the buffer that spawned it.
	vim.api.nvim_create_autocmd('BufEnter', {
		group = augroup,
		callback = function()
			-- close preview unless we're in original window or popup window
			local bufnrs = { popup_bufnr, bufnr }
			if not vim.tbl_contains(bufnrs, vim.api.nvim_get_current_buf()) then
				close(popup_state, augroup)
			end
		end,
	})

	-- Create autocommands to close a preview window when events happen.
	local events = { 'CursorMoved', 'BufUnload', 'InsertCharPre', 'ModeChanged' }
	vim.api.nvim_create_autocmd(events, {
		group = augroup,
		buffer = bufnr,
		once = true,
		callback = function()
			close(popup_state, augroup)
		end,
	})
end

return M
