-- Util: Preview (requires snacks.nvim)
-- https://github.com/rafi/vim-config

---@class rafi.util.preview
local M = {}

--- Open file preview with optional line/column position.
---@param opts string|{ file: string, lnum: number?, lcol: number? }
function M.open(opts)
	local defaults = {
		enter = false,
		backdrop = false,
		border = 'rounded',
		title_pos = 'center',
		position = 'float',
		width = 0.7,
		height = 0.8,
		wo = {
			cursorline = false,
			foldenable = false,
			number = true,
		},
		on_close = function(self)
			if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
				vim.api.nvim_buf_delete(self.buf, { force = true })
			end
		end,
	}
	if type(opts) == 'string' then
		opts = { file = opts }
	end
	opts = vim.tbl_deep_extend('force', defaults, opts or {})
	opts.title = vim.fn.fnamemodify(opts.file, ':~')

	-- Jump to line number if provided.
	if opts.lnum ~= nil and opts.lnum > 0 then
		opts.wo.cursorline = true
		opts.on_win = function(self)
			local col = opts.lcol or 0
			pcall(vim.api.nvim_win_set_cursor, self.win, { opts.lnum, col })
		end
	end

	-- Open preview and wait for keystroke.
	local win = Snacks.win.new(opts)
	local key = vim.fn.getcharstr()
	win:close({ buf = true })
	local keycode = vim.fn.keytrans(key)
	keycode = vim.api.nvim_replace_termcodes(keycode, true, false, true)
	vim.api.nvim_feedkeys(keycode, 'n', false)
end

return M
