-- Highlights other uses of the word under the cursor (regex/treesitter/LSP)
-- When enabled, plugin/snacks.lua turns off Snacks.words (LSP
-- document highlight), so words aren't highlighted twice. That also skips
-- core's LSP `]]`/`[[`/`<a-n>`/`<a-p>` maps (plugin/lspconfig.lua), so
-- this extra's `]]`/`[[` apply in every buffer.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/illuminate.lua
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- Its `plugin/illuminate.vim` starts a global CursorMoved-driven engine
	-- (not FileType-scoped), so it needs no buffer re-attach once installed.
	vim.pack.add({ 'https://github.com/RRethy/vim-illuminate' })
	require('illuminate').configure({
		delay = 200,
		large_file_cutoff = 2000,
		large_file_overrides = {
			providers = { 'lsp' },
		},
		under_cursor = false,
		modes_allowlist = { 'n', 'no', 'nt' },
		filetypes_denylist = {
			'DiffviewFileHistory',
			'DiffviewFiles',
			'fugitive',
			'git',
			'minifiles',
			'neo-tree',
			'Outline',
			'SidebarNvim',
		},
	})

	local function map(key, dir, buffer)
		vim.keymap.set('n', key, function()
			require('illuminate')['goto_' .. dir .. '_reference'](false)
		end, {
			desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference',
			buffer = buffer,
		})
	end

	Snacks.toggle({
		name = 'Illuminate',
		get = function()
			return not require('illuminate.engine').is_paused()
		end,
		set = function(enabled)
			local m = require('illuminate')
			if enabled then
				m.resume()
			else
				m.pause()
			end
		end,
	}):map('<leader>ux')

	map(']]', 'next')
	map('[[', 'prev')

	-- Also set it after loading ftplugins, since a lot overwrite [[ and ]].
	local augroup = vim.api.nvim_create_augroup('rafi.illuminate', {})
	vim.api.nvim_create_autocmd('FileType', {
		group = augroup,
		callback = function()
			local buffer = vim.api.nvim_get_current_buf()
			map(']]', 'next', buffer)
			map('[[', 'prev', buffer)
		end,
	})
	-- The FileType event for the triggering buffer already fired before the
	-- group above existed, so re-fire it.
	pack.refire_filetype('rafi.illuminate')
end

pack.on_event('BufReadPost,BufNewFile', load)

-- `load()` replaces these with the real global map (and a buffer-local one
-- per FileType), so they only run once, before the first trigger fires.
vim.keymap.set('n', ']]', function()
	load()
	require('illuminate').goto_next_reference(false)
end, { desc = 'Next Reference' })
vim.keymap.set('n', '[[', function()
	load()
	require('illuminate').goto_prev_reference(false)
end, { desc = 'Prev Reference' })
