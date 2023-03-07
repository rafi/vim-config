-- Telescope helper library
-- https://github.com/rafi/vim-config

local M = {}

M.root_patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn' }

-- Credits: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua
-- this will return a function that calls telescope.
-- cwd will default to M.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts
		opts = vim.tbl_deep_extend('force', { cwd = M.get_root() }, opts or {})
		if builtin == 'files' then
			if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. '/.git') then
				opts.show_untracked = true
				builtin = 'git_files'
			else
				builtin = 'find_files'
			end
		end
		require('telescope.builtin')[builtin](opts)
	end
end

-- Credits: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua
-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
	---@type string?
	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= '' and vim.loop.fs_realpath(path) or nil
	---@type string[]
	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace
					and vim.tbl_map(function(ws)
						return vim.uri_to_fname(ws.uri)
					end, workspace)
				or client.config.root_dir and { client.config.root_dir }
				or {}
			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p)
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	---@type string?
	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.loop.cwd()
		---@type string?
		root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
		root = root and vim.fs.dirname(root) or vim.loop.cwd()
	end
	---@cast root string
	return root
end

M.actions = {}

return M
