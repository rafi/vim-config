return {

	-- Search, select, and edit sandwich text objects
	{
		'machakann/vim-sandwich',
		-- stylua: ignore
		keys = {
			-- See https://github.com/machakann/vim-sandwich/blob/master/macros/sandwich/keymap/surround.vim
			{ 'ds', '<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)', silent = true },
			{ 'dss', '<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)', silent = true },
			{ 'cs', '<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)', silent = true },
			{ 'css', '<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)', silent = true },
			{ 'sa', '<Plug>(operator-sandwich-add)', silent = true, mode = { 'n', 'x', 'o' }},
			{ 'ir', '<Plug>(textobj-sandwich-auto-i)', silent = true, mode = { 'x', 'o' }},
			{ 'ab', '<Plug>(textobj-sandwich-auto-a)', silent = true, mode = { 'x', 'o' }},
		},
		init = function()
			vim.g.sandwich_no_default_key_mappings = 1
		end,
	},
}
