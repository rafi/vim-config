-- Plugins: Git
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	{
		'lewis6991/gitsigns.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		-- See: https://github.com/lewis6991/gitsigns.nvim#usage
		opts = {
			signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
			numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			attach_to_untracked = true,
			watch_gitdir = {
				interval = 1000,
				follow_files = true
			},
			preview_config = {
				border = 'rounded',
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				---@return string
				map('n', ']g', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.next_hunk() end)
					return '<Ignore>'
				end, { expr = true, desc = 'Git hunk forward'  })

				map('n', '[g', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gs.prev_hunk() end)
					return '<Ignore>'
				end, { expr = true, desc = 'Git hunk last' })

				local silent = { silent = true }

				-- Actions
				map({'n', 'x'}, '<leader>hs', ':Gitsigns stage_hunk<CR>', silent)
				map({'n', 'x'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', silent)
				map('n', '<leader>hS', gs.stage_buffer, { silent = true, desc = 'Stage buffer' })
				map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo staged hunk' })
				map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
				map('n', 'gs', gs.preview_hunk, { desc = 'Preview hunk' })
				map('n', '<leader>hp', gs.preview_hunk_inline, { desc = 'Preview hunk inline' })
				map('n', '<leader>hb', function() gs.blame_line({ full=true }) end, { desc = 'Show blame commit' })
				map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle Git line blame' })
				-- map('n', '<leader>tw', gs.toggle_word_diff)
				map('n', '<leader>hd', gs.diffthis, { desc = 'Diff against the index' })
				map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Diff against the last commit' })
				map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle Git deleted' })
				map('n', '<leader>hl', function()
					if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'qf' then
						require('gitsigns').setqflist(0, { use_location_list = true })
					end
				end, { desc = 'Send to location list' })

				-- Text object
				map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { silent = true, desc = 'Select hunk'})

			end,
		},
	},

	-----------------------------------------------------------------------------
	{
		'TimUntersberger/neogit',
		dependencies = { 'sindrets/diffview.nvim' },
		cmd = 'Neogit',
		keys = {
			{ '<Leader>mg', '<cmd>Neogit<CR>', desc = 'Neogit' }
		},
		-- See: https://github.com/TimUntersberger/neogit#configuration
		opts = {
			disable_signs = false,
			disable_context_highlighting = false,
			disable_commit_confirmation = false,
			signs = {
				section = { '>', 'v' },
				item = { '>', 'v' },
				hunk = { '', '' },
			},
			integrations = {
				diffview = true,
			},
		},
	},

	-----------------------------------------------------------------------------
	{
		'tpope/vim-fugitive',
		cmd = { 'G', 'Git', 'GBrowse', 'Gfetch', 'Gpush', 'Gclog', 'Gdiffsplit' },
		keys = {
			{ '<leader>gd', '<cmd>Gdiffsplit<CR>', desc = 'Git diff' },
			{ '<leader>gb', '<cmd>Git blame<CR>', desc = 'Git blame' },
		},
		config = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_fugitive', {}),
				pattern = 'fugitiveblame',
				callback = function()
					vim.schedule(function()
						vim.cmd.normal('A')
					end)
				end
			})
		end
	},

	-----------------------------------------------------------------------------
	{
		'junegunn/gv.vim',
		dependencies = { 'tpope/vim-fugitive' },
		cmd = 'GV'
	},

	-----------------------------------------------------------------------------
	{
		'ruifm/gitlinker.nvim',
		keys = {
			{
				'<leader>go', function()
					require('gitlinker').get_buf_range_url('n')
				end,
				silent = true,
				desc = 'Git open in browser',
			},
			{
				'<leader>go', function()
					require('gitlinker').get_buf_range_url('v')
				end,
				mode = 'x',
				desc = 'Git open in browser',
			},
		},
		opts = {
			mappings = nil,
			opts = {
				add_current_line_on_normal_mode = true,
				print_url = false,
				action_callback = function(...)
					return require('gitlinker.actions').open_in_browser(...)
				end
			}
		},
	},

	-----------------------------------------------------------------------------
	{
		'rhysd/committia.vim',
		event = 'BufReadPre COMMIT_EDITMSG',
		init = function()
			-- See: https://github.com/rhysd/committia.vim#variables
			vim.g.committia_min_window_width = 30
			vim.g.committia_edit_window_width = 75
		end,
		config = function()
			vim.g.committia_hooks = {
				edit_open = function()
					vim.cmd.resize(10)
					local opts = {
						buffer = vim.api.nvim_get_current_buf(),
						silent = true,
					}
					local function imap(lhs, rhs)
						vim.keymap.set('i', lhs, rhs, opts)
					end
					imap('<C-d>', '<Plug>(committia-scroll-diff-down-half)')
					imap('<C-u>', '<Plug>(committia-scroll-diff-up-half)')
					imap('<C-f>', '<Plug>(committia-scroll-diff-down-page)')
					imap('<C-b>', '<Plug>(committia-scroll-diff-up-page)')
					imap('<C-j>', '<Plug>(committia-scroll-diff-down)')
					imap('<C-k>', '<Plug>(committia-scroll-diff-up)')
				end,
			}
		end,
	},

}
