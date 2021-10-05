-- plugin: nvim-cmp
-- see: https://github.com/hrsh7th/nvim-cmp
-- rafi settings

local cmp = require('cmp')

_G.cmp_source_list = function(arr)
	local config = {
		buffer = {
			name = 'buffer',
			-- opts = {
			-- 	-- Use all visible buffers
			-- 	get_bufnrs = function()
			-- 		local bufs = {}
			-- 		for _, win in ipairs(vim.api.nvim_list_wins()) do
			-- 			bufs[vim.api.nvim_win_get_buf(win)] = true
			-- 		end
			-- 		return vim.tbl_keys(bufs)
			-- 	end,
			-- },
		},
		nvim_lsp = { name = 'nvim_lsp' },
		nvim_lua = { name = 'nvim_lua' },
		path  = { name = 'path' },
		emoji = { name = 'emoji' },
		vsnip = { name = 'vsnip' },
		tmux  = { name = 'tmux', opts = { all_panes = true }},
		latex = { name = 'latex_symbols' },
	}
	local sources = {}
	for _, name in ipairs(arr) do
		sources[#sources + 1] = config[name]
	end
	return sources
end

_G.cmp_setup_markdown = function()
	require('cmp').setup.buffer{ sources = cmp_source_list(
		{ 'emoji', 'nvim_lsp', 'buffer', 'path', 'vsnip', 'tmux' })}
end

_G.cmp_setup_lua = function()
	require('cmp').setup.buffer{ sources = cmp_source_list(
		{ 'nvim_lua', 'nvim_lsp', 'buffer', 'path', 'vsnip', 'tmux' })}
end

_G.cmp_setup_org = function()
	require('cmp').setup.buffer{ sources = cmp_source_list(
		{ 'orgmode', 'emoji', 'nvim_lsp', 'buffer', 'path', 'vsnip', 'tmux' })}
end

vim.api.nvim_exec([[
	augroup user_cmp
		autocmd!
		autocmd FileType markdown,text call v:lua.cmp_setup_markdown()
		autocmd FileType lua call v:lua.cmp_setup_lua()
		autocmd FileType org call v:lua.cmp_setup_org()
	augroup END
]], false)

local check_back_space = function()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Setup cmp
cmp.setup {
	sources = cmp_source_list({
		'nvim_lsp',
		'buffer',
		'path',
		'vsnip',
		'tmux',
	}),

	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		['<Tab>'] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(t('<C-n>'), 'n')
			elseif vim.fn['vsnip#available']() == 1 then
				vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
			elseif check_back_space() then
				vim.fn.feedkeys(t('<Tab>'), 'n')
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(t('<C-p>'), 'n')
			elseif vim.fn['vsnip#jumpable'](-1) == 1 then
				vim.fn.feedkeys(t('<Plug>(vsnip-jump-prev)'), '')
			elseif check_back_space() then
				vim.fn.feedkeys(t('<C-h>'), 'n')
			else
				fallback()
			end
		end, { 'i', 's' }),
	},

	documentation = {
		border = 'rounded',
		winhighlight = 'NormalFloat:UserFloat,FloatBorder:UserBorder',
	},

	formatting = {
		format = function(entry, vim_item)
			-- Prepend with a fancy icon
			local symbol = require('lsp_kind').preset()[vim_item.kind]
			if symbol ~= nil then
				vim_item.kind = symbol
					.. (vim.g.global_symbol_padding or ' ') .. vim_item.kind
			end

			-- Set menu source name
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				buffer   = "[Buf]",
				spell    = "[Spell]",
				path     = "[Path]",
				vsnip    = "[VSnip]",
				tmux     = "[Tmux]",
				orgmode  = "[Org]"
			})[entry.source.name]

			vim_item.dup = ({
				nvim_lua = 0,
				buffer = 0,
			})[entry.source.name] or 1

			return vim_item
		end,
	},

	snippet = {
		expand = function(args)
			vim.fn['vsnip#anonymous'](args.body)
		end,
	},

}
