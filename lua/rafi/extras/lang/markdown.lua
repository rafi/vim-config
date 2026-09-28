-- Markdown: filetypes, panache, render-markdown.nvim and
-- markdown-preview.nvim (with live-server.nvim)
-- Buffer settings and the <C-Return> link key are in
-- after/ftplugin/markdown.lua.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/markdown.lua
local pack = require('rafi.pack')

-- $VIMRUNTIME/ftplugin/markdown.vim
vim.g.markdown_recommended_style = 0

vim.filetype.add({
	extension = {
		mdc = 'markdown',
		mdx = 'markdown.mdx',
	},
	filename = {
		PULLREQ_EDITMSG = 'markdown.ghpull',
		ISSUE_EDITMSG = 'markdown.ghissue',
		RELEASE_EDITMSG = 'markdown.ghrelease',
	},
})

require('rafi.util.lang').add({
	servers = { panache = true },
})

-- render-markdown.nvim
-------------------------------------------------------------------------------

-- Read by its plugin/ file, which calls setup() on load.
vim.g.render_markdown_config = {
	code = {
		sign = false,
		width = 'block',
		right_pad = 1,
	},
	heading = {
		sign = false,
		icons = {},
	},
	checkbox = {
		enabled = false,
	},
}

-- Its plugin/ file runs setup and requires the core, so add it on the first
-- buffer that needs it.
pack.on_filetype('markdown,norg,rmd,org,codecompanion', function()
	vim.pack.add({
		'https://github.com/MeanderingProgrammer/render-markdown.nvim',
	})
	-- Setup attaches the current buffer only, attach others already open.
	pack.refire_filetype('RenderMarkdown')
	local rm = require('render-markdown')
	Snacks.toggle({
		name = 'Render Markdown',
		get = rm.get,
		set = rm.set,
	}):map('<leader>um')
end)

-- markdown-preview.nvim
-------------------------------------------------------------------------------

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		-- Its plugin/ file requires the core eagerly.
		'https://github.com/selimacerbas/live-server.nvim',
		'https://github.com/selimacerbas/markdown-preview.nvim',
	})
	require('markdown_preview').setup({
		default_theme = 'light',
		debounce_ms = 300,
	})
end

-- Stubs until the plugin defines the real commands.
pack.command({
	'MarkdownPreview',
	'MarkdownPreviewRefresh',
	'MarkdownPreviewStop',
}, load, { desc = 'Markdown Preview' })

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi.lang.markdown', {}),
	pattern = { 'markdown', 'mermaid' },
	callback = function(ev)
		vim.keymap.set(
			'n',
			'<leader>cp',
			'<cmd>MarkdownPreview<cr>',
			{ buffer = ev.buf, desc = 'Markdown Preview' }
		)
	end,
})
