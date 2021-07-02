-- plugin: nvim-compe
-- see: https://github.com/hrsh7th/nvim-compe
-- rafi settings

require'compe'.setup({
  source = {
    path = true,
    buffer = {kind = '⌯', true},  -- ﬘,
    -- spell = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = {kind = '*'},  -- ﬌
    orgmode = true,
    -- tmux = true,
    -- tmux = { all_panes = true }
  },
})

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

local npairs = require('nvim-autopairs')

_G.confirm_completion = function()
  if vim.fn.pumvisible() == 0 then
    return npairs.autopairs_cr()
    -- return t '<Plug>delimitMateCR'
  elseif vim.fn.complete_info()['selected'] ~= -1 then
      return vim.fn['compe#confirm'](npairs.esc('<cr>'))
  -- elseif vim.fn.complete_info()['selected'] ~= -1 then
  --   return vim.fn['compe#confirm']({ keys = t '<Plug>delimitMateCR', mode = '' })
  else
    return npairs.esc('<cr>')
    -- return t '<C-e><Plug>delimitMateCR'
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

local remap = vim.api.nvim_set_keymap
remap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
remap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
remap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
remap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

remap("i", "<CR>", "v:lua.confirm_completion()", {expr = true, noremap=true})

local args = {expr = true, noremap = true, silent = true}
remap("i", "<C-e>", "compe#close('<C-e>')", args)
remap("i", "<C-u>", "compe#scroll({'delta': 4})", args)
remap("i", "<C-d>", "compe#scroll({'delta': -4})", args)

-- vim: set ts=2 sw=2 tw=80 et :
