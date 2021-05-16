-- plugin: telescope.nvim
-- see: https://github.com/nvim-telescope/telescope.nvim
-- rafi settings

local api = vim.api
local actions = require('telescope.actions')
local telescope = require('telescope')

telescope.setup{
	defaults = {
		prompt_position = "bottom",
		prompt_prefix = ' ❯ ',
		selection_caret = '▷ ',
		-- prompt_prefix = " ",
		-- prompt_prefix = "  ",
		-- selection_caret = " ",

		-- scroll_strategy = 'cycle',
		-- selection_strategy = 'follow',
		-- sorting_strategy = 'ascending',

		file_ignore_patterns = {},

		find_command = {'rg', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'},

		-- layout_strategy = 'flex',
		winblend = 7,
		color_devicons = true,
		set_env = { COLORTERM = 'truecolor' },

		mappings = {
			i = {
			  ["<Tab>"] = actions.move_selection_next,
			  ["<C-Tab>"] = actions.move_selection_previous,
			  ["jj"] = actions.close,
				["<C-q>"] = actions.send_to_qflist,

				-- insert_value
				-- insert_symbol
				-- run_builtin
				-- add_selected_to_qflist
				-- send_selected_to_qflist
				-- add_to_qflist
				-- send_to_qflist
				-- smart_send_to_qflist
				-- smart_add_to_qflist
				-- complete_tag
				-- open_qflist
			},
			n = {
				["q"] = actions.close,
				["<Space>"] = actions.toggle_selection,
				["Q"] = actions.send_to_qflist + actions.open_qflist,
				["a"] = actions.add_to_qflist,
				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,
				["sv"] = actions.select_horizontal,
				["sg"] = actions.select_vertical,
				["st"] = actions.select_tab,
				["!"] = actions.edit_command_line,
				["?"] = actions.edit_search_line,
			},
		},
	}
}

telescope.load_extension('session-lens')

-- Helper function to set the keymaps for telescope functions
local function map(modes, lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = opts.noremap == nil and true or opts.noremap
	if type(modes) == "string" then
		modes = { modes }
	end
	for _, mode in ipairs(modes) do
		api.nvim_set_keymap(mode, lhs, rhs, opts)
	end
end

local function tele_map(key, funcname, module)
	module = module or "telescope.builtin"
	map("n", key, '<Cmd>lua require("' .. module .. '").' .. funcname .. "()<CR>")
end

-- tele_map('<localleader>f', 'find_files')
-- tele_map('<leader>ff', 'find_files')
-- tele_map('<leader>fg', 'live_grep')
-- tele_map('<leader>fb', 'buffers')
-- tele_map('<leader>fh', 'help_tags')

-- vim.api.nvim_set_keymap('n', '<leader>pw', ':lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })<CR>', {noremap = true, silent = true})


-- local M = {}
-- 
-- function M.setup()
--   local options = {
--     shorten_path = false,
--     height = 10,
--     layout_strategy = 'horizontal',
--     layout_config = { preview_width = 0.65 },
--   }
--   function _G.__telescope_files()
--     -- Launch file search using Telescope
--     -- if vim.fn.isdirectory(".git") then
--     --     -- if in a git project, use :Telescope git_files
--     --     require'telescope.builtin'.git_files(options)
--     -- else
--     -- otherwise, use :Telescope find_files
--     require 'telescope.builtin'.find_files(options)
--     -- end
--   end
--   function _G.__telescope_buffers()
--     require 'telescope.builtin'.buffers {
--       sort_lastused = true,
--       ignore_current_buffer = true,
--       sorter = require 'telescope.sorters'.get_substr_matcher(),
--       shorten_path = true,
--       height = 10,
--       layout_strategy = 'horizontal',
--       layout_config = { preview_width = 0.65 },
--       show_all_buffers = true,
--       color_devicons = true,
--     }
--   end
--   function _G.__telescope_grep()
--     require 'telescope.builtin'.live_grep {
--       shorten_path = false,
--       height = 10,
--       layout_strategy = 'horizontal',
--       layout_config = { preview_width = 0.4 },
--     }
--   end
--   function _G.__telescope_commits()
--     require 'telescope.builtin'.git_commits {
--       height = 10,
--       layout_strategy = 'horizontal',
--       layout_config = { preview_width = 0.55 },
--     }
--   end
--   local opts = { noremap = true, silent = true }
--   vim.api.nvim_set_keymap(
--     'n',
--     '<Space>b',
--     '<cmd>lua __telescope_buffers()<CR>',
--     opts
--   )
--   vim.api.nvim_set_keymap(
--     'n',
--     '<C-f>',
--     '<cmd>lua __telescope_files()<CR>',
--     opts
--   )
--   vim.api.nvim_set_keymap('n', '<C-g>', '<cmd>Telescope git_status<CR>', opts)
--   -- vim.api.nvim_set_keymap('n', '<Space>s',
--   --                         "<cmd>lua require('telescope').extensions.frecency.frecency({layout_strategy = 'vertical'})<CR>",
--   --    opts)
--   vim.api.nvim_set_keymap(
--     'n',
--     '<Space>/',
--     '<cmd>lua __telescope_grep()<CR>',
--     opts
--   )
--   -- vim.api.nvim_set_keymap('n', '<Space>/',
--   --                         '<cmd>lua require("telescope.builtin").grep_string { search = vim.fn.expand("<cword>") }<CR>',
--   --                         opts)  -- grep for word under the cursor
--   vim.api.nvim_set_keymap(
--     'n',
--     '<Space>h',
--     '<cmd>lua require "telescope.builtin".help_tags(options)<CR>',
--     opts
--   )
--   vim.api.nvim_set_keymap(
--     'n',
--     '<Space>c',
--     '<cmd>lua __telescope_commits()<CR>',
--     opts
--   )
--   vim.api.nvim_set_keymap(
--     'n',
--     ',pr',
--     '<cmd>lua require "telescope.builtin".extensions.pull_request()<CR>',
--     opts
--   )
-- end
-- 
-- function M.config()
--     local actions = require 'telescope.actions'
--     local sorters = require 'telescope.sorters'
--     local previewers = require 'telescope.previewers'
-- 
--     require 'telescope'.setup {
--       defaults = {
--         prompt_prefix = ' ❯ ',
--         mappings = {
--           i = {
--             ['<ESC>'] = actions.close,
--             ['<C-j>'] = actions.move_selection_next,
--             ['<C-k>'] = actions.move_selection_previous,
--           },
--           n = { ['<ESC>'] = actions.close },
--         },
--         file_ignore_patterns = {
--           '%.jpg',
--           '%.jpeg',
--           '%.png',
--           '%.svg',
--           '%.otf',
--           '%.ttf',
--         },
--         file_sorter = sorters.get_fzy_sorter,
--         generic_sorter = sorters.get_fzy_sorter,
--         file_previewer = previewers.vim_buffer_cat.new,
--         grep_previewer = previewers.vim_buffer_vimgrep.new,
--         qflist_previewer = previewers.vim_buffer_qflist.new,
--         layout_strategy = 'flex',
--         winblend = 7,
--         set_env = { COLORTERM = 'truecolor' },
--         color_devicons = true,
--       },
--     }
-- end
-- 
-- M.setup()
-- -- return M
