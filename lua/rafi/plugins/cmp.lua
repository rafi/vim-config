-- plugin: nvim-cmp
-- :h cmp
-- see: https://github.com/hrsh7th/nvim-cmp
-- rafi settings

local cmp = require('cmp')

-- Source setup. Helper function for cmp source presets.
_G.cmp_get_sources = function(arr)
	local config = {
		buffer = { name = 'buffer' },
		nvim_lsp = { name = 'nvim_lsp' },
		nvim_lua = { name = 'nvim_lua' },
		path  = { name = 'path' },
		emoji = { name = 'emoji' },
		vsnip = { name = 'vsnip' },
		tmux  = { name = 'tmux', option = { all_panes = true }},
		latex = { name = 'latex_symbols' },
	}
	local sources = {}
	for _, name in ipairs(arr) do
		sources[#sources + 1] = config[name]
	end
	return sources
end

--     
--    ⮡
-- Labels for completion candidates.
local completion_labels = {
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	-- buffer   = "[Buf]",
	spell    = "[Spell]",
	path     = "[Path]",
	-- vsnip    = "[VSnip]",
	tmux     = "[Tmux]",
}

-- Detect if words are before cursor position.
local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

-- Feed proper terminal codes
local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

-- For LSP integration, see lspconfig.lua

-- :h cmp
cmp.setup {

	-- Set default cmp sources
	sources = cmp_get_sources({
		'nvim_lsp',
		'buffer',
		'path',
		'vsnip',
		'tmux',
	}),

	snippet = {
		expand = function(args)
			-- Using https://github.com/hrsh7th/vim-vsnip for snippets.
			vim.fn['vsnip#anonymous'](args.body)
		end,
	},

	mapping = cmp.mapping.preset.insert({
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-u>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
		['<C-d>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
		['<C-c>'] = function(fallback)
			cmp.close()
			fallback()
		end,
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn['vsnip#available']() == 1 then
				feedkey('<Plug>(vsnip-expand-or-jump)', '')
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn['vsnip#jumpable'](-1) == 1 then
				feedkey('<Plug>(vsnip-jump-prev)', '')
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),

	window = {
		completion = cmp.config.window.bordered({
			border = 'none',
			winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
		}),
		documentation = cmp.config.window.bordered({
			border = 'none',
			winhighlight = 'FloatBorder:NormalFloat',
		}),
	},

	-- window = {
	-- 	completion = {
	-- 		border = { '', '', '', '', '', '', '', '' },
	-- 		winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
	-- 	},
	-- 	documentation = {
	-- 		max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
	-- 		max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
	-- 		border = { '', '', '', ' ', '', '', '', ' ' },
	-- 		winhighlight = 'FloatBorder:NormalFloat',
	-- 	},
	-- },

	-- view = {
	-- 	entries = 'native',
	-- },

	formatting = {
		format = function(entry, vim_item)
			-- Prepend with a fancy icon
			-- See lua/lsp_kind.lua
			local symbol = require('lsp_kind').preset()[vim_item.kind]
			if symbol ~= nil then
				vim_item.kind = symbol
					.. (vim.g.global_symbol_padding or ' ') .. vim_item.kind
			end

			-- Set menu source name
			if completion_labels[entry.source.name] then
				vim_item.menu = completion_labels[entry.source.name]
			end

			vim_item.dup = ({
				nvim_lua = 0,
				buffer = 0,
			})[entry.source.name] or 1

			return vim_item
		end,
	},
}

-- Completion sources according to specific file-types.
cmp.setup.filetype({ 'markdown', 'help', 'text' }, {
	sources = cmp_get_sources(
		{'emoji', 'nvim_lsp', 'buffer', 'path', 'vsnip', 'tmux'}
	)
})

cmp.setup.filetype({ 'lua' }, {
	sources = cmp_get_sources(
		{'nvim_lua', 'nvim_lsp', 'buffer', 'path', 'vsnip', 'tmux'}
	)
})
