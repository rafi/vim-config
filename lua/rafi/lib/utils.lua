-- General utilities
-- https://github.com/rafi/vim-config

local root_patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn' }

local M = {}

-- Find the root directory by searching for the version-control dir
---@return string
function M.get_root()
	local cwd = vim.loop.cwd()
	if cwd == '' or cwd == nil then
		return ''
	end
	local ok, cache = pcall(vim.api.nvim_buf_get_var, 0, 'project_dir')
	if ok and cache then
		local _, last_cwd =
			pcall(vim.api.nvim_buf_get_var, 0, 'project_dir_last_cwd')
		if cwd == last_cwd then
			return cache
		end
	end

	local root = vim.fs.find(root_patterns, { path = cwd, upward = true })[1]
	root = root and vim.fs.dirname(root) or vim.loop.cwd()
	vim.api.nvim_buf_set_var(0, 'project_dir', root)
	vim.api.nvim_buf_set_var(0, 'project_dir_last_cwd', cwd)
	return root
end

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyCmdOptions|{interactive?:boolean, esc_esc?:false}
function M.float_term(cmd, opts)
	opts = vim.tbl_deep_extend('force', {
		size = { width = 0.9, height = 0.9 },
	}, opts or {})
	local float = require('lazy.util').float_term(cmd, opts)
	if opts.esc_esc == false then
		vim.keymap.set('t', '<esc>', '<esc>', { buffer = float.buf, nowait = true })
	end
end

return M
