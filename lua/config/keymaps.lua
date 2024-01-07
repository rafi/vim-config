-- Sergio's Keymaps
-- github.com/sergiopatini/vim-config
-- ===

local map = vim.keymap.set

-- Tabs: Navigate through tabs
map('n', 'fl', '<cmd>:tabnext<CR>', { desc = 'Next tab' })
map('n', 'fh', '<cmd>:tabprevious<CR>', { desc = 'Previous tab' })
map('n', 'fd', '<cmd>:tabclose<CR>', { desc = 'Close tab' })

-- Tabs: Move tabs
map('n', 'f]', '<cmd>:tabmove +1<CR>', { desc = 'Move tab right' })
map('n', 'f[', '<cmd>:tabmove -1<CR>', { desc = 'Move tab left' })

-- Scroll: Remap jk to use accelerated-jk
vim.api.nvim_set_keymap('n', 'j', '<Plug>(accelerated_jk_gj)', {})
vim.api.nvim_set_keymap('n', 'k', '<Plug>(accelerated_jk_gk)', {})

-- New split with empty buffer
map('n', 'sV', '<cmd>:new<CR>', {})
map('n', 'sG', '<cmd>:vnew<CR>', {})

