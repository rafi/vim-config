-- Tmux: Tmuxfile filetype, and `gK` opens `man tmux` at the word

vim.filetype.add({ filename = { Tmuxfile = 'tmux' } })

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('rafi.ftplugin.tmux', {}),
	pattern = 'tmux',
	callback = function(ev)
		-- Open 'man tmux' with the word under cursor.
		local function open_doc()
			local cword = vim.fn.expand('<cword>')
			require('man').open_page(0, { silent = true }, { 'tmux' })
			vim.fn.search(cword)
		end

		vim.opt_local.iskeyword:append('-')

		vim.b[ev.buf].undo_ftplugin = (vim.b[ev.buf].undo_ftplugin or '')
			.. '\nsetlocal iskeyword<'
			.. '\nsil! nunmap <buffer> gK'

		-- stylua: ignore start
		vim.keymap.set('n', 'gK', open_doc, { buffer = ev.buf, desc = 'Tmux Man Page' })
		-- stylua: ignore end
	end,
})
