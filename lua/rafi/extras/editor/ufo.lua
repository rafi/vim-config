-- Make folds look modern and keep a high performance
local pack = require('rafi.pack')

pack.on_event('BufReadPost,BufNewFile', function()
	-- promise-async and treesitter/lsp fold providers are nvim-ufo deps.
	vim.pack.add({
		'https://github.com/kevinhwang91/promise-async',
		'https://github.com/kevinhwang91/nvim-ufo',
	})

	---@param bufnr integer
	---@return table
	local function customizeSelector(bufnr)
		local function handleFallbackException(err, providerName)
			if type(err) == 'string' and err:match('UfoFallbackException') then
				return require('ufo').getFolds(bufnr, providerName)
			else
				return require('promise').reject(err)
			end
		end

		return require('ufo')
			.getFolds(bufnr, 'lsp')
			:catch(function(err)
				return handleFallbackException(err, 'treesitter')
			end)
			:catch(function(err)
				return handleFallbackException(err, 'indent')
			end)
	end

	local ft_providers = {
		vim = 'indent',
		python = { 'indent' },
		git = '',
		help = '',
		qf = '',
		fugitive = '',
		fugitiveblame = '',
		['neo-tree'] = '',
	}

	require('ufo').setup({
		open_fold_hl_timeout = 0,
		preview = {
			win_config = {
				border = { '', '─', '', '', '', '─', '', '' },
				winhighlight = 'Normal:Folded',
				winblend = 10,
			},
			mappings = {
				scrollU = '<C-u>',
				scrollD = '<C-d>',
				jumpTop = '[',
				jumpBot = ']',
			},
		},

		-- Select the fold provider.
		provider_selector = function(_, filetype, _)
			return ft_providers[filetype] or customizeSelector
		end,

		-- Display text for folded lines.
		---@param text table
		---@param lnum integer
		---@param endLnum integer
		---@param width integer
		---@return table
		fold_virt_text_handler = function(text, lnum, endLnum, width)
			local suffix = ' 󰇘 '
			local lines = (' 󰁂 %d '):format(endLnum - lnum)

			local cur_width = 0
			for _, section in ipairs(text) do
				cur_width = cur_width + vim.fn.strdisplaywidth(section[1])
			end

			suffix = suffix
				.. (' '):rep(width - cur_width - vim.fn.strdisplaywidth(lines) - 3)

			table.insert(text, { suffix, 'UfoFoldedEllipsis' })
			table.insert(text, { lines, 'Folded' })
			return text
		end,
	})
end)

-- Call ufo's `fn` once it's loaded, else the built-in `key`. Before the first
-- file read there are no ufo folds, and require('ufo') would fail.
---@param fn string
---@param key string
local function ufo_or(fn, key)
	return function()
		if package.loaded.ufo then
			require('ufo')[fn]()
		else
			vim.cmd('normal! ' .. key)
		end
	end
end

-- stylua: ignore start
vim.keymap.set('n', 'zR', ufo_or('openAllFolds', 'zR'), { desc = 'Open All Folds' })
vim.keymap.set('n', 'zM', ufo_or('closeAllFolds', 'zM'), { desc = 'Close All Folds' })
-- stylua: ignore end
