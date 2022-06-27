vim.api.nvim_exec([[
augroup badge_lua_cache
	autocmd!
	autocmd BufWritePre,FileChangedShellPost,TextChanged,InsertLeave * unlet! b:badge_cache_trails
	autocmd BufReadPost,BufFilePost,BufNewFile,BufWritePost * unlet! b:badge_cache_filepath | unlet! b:badge_cache_icon
augroup END
]], false)

local M = {}

function M.filepath(max_dirs, dir_max_chars)
	return function()
		local msg = ''
		-- local ft = vim.bo.filetype
		local name = vim.fn.expand('%:~:.')
		local cache_key = 'badge_cache_filepath' -- _'..ft
		local cache_ok, cache = pcall(vim.api.nvim_buf_get_var, 0, cache_key)

		if cache_ok then
			return cache
		elseif name:len() < 1 then
			return 'N/A'
		end

		local i = 0
		local parts = {}
		local iter = string.gmatch(name, '([^/]+)')
		for dir in iter do
			table.insert(parts, dir)
		end
		while #parts > 1 do
			local dir = table.remove(parts, 1)
			if #parts <= max_dirs then
				dir = string.sub(dir, 0, dir_max_chars)
				if i > 0 then
					msg = msg .. '/'
				end
				msg = msg .. dir
				i = i + 1
			end
		end
		if i > 0 then
			msg = msg .. '/'
		end
		msg = msg .. table.concat(parts, '/')
		vim.api.nvim_buf_set_var(0, cache_key, msg)

		return msg
	end
end

function M.filemode(normal_symbol, readonly_symbol, zoom_symbol)
	return function()
		local msg = ''
		if not (vim.bo.readonly or vim.t.zoomed) then
			msg = msg .. normal_symbol
		end
		if vim.bo.buftype == '' and vim.bo.readonly then
			msg = msg .. readonly_symbol
		end
		if vim.t.zoomed then
			msg = msg .. zoom_symbol
		end
		return msg
	end
end

function M.filemedia(separator)
	return function()
		local parts = {}
		if vim.bo.fileformat ~= '' and vim.bo.fileformat ~= 'unix' then
			table.insert(parts, vim.bo.fileformat)
		end
		if vim.bo.fileencoding ~= '' and vim.bo.fileencoding ~= 'utf-8' then
			table.insert(parts, vim.bo.fileencoding)
		end
		if vim.bo.filetype ~= '' then
			table.insert(parts, vim.bo.filetype)
		end
		return table.concat(parts, separator)
	end
end

function M.modified(symbol)
	return function()
		if vim.bo.modified then
			return symbol
		end
		return ''
	end
end

function M.icon()
	return function()
		local ft = vim.bo.filetype
		if #ft < 1 then
			return ''
		end

		local cache_key = 'badge_cache_icon' -- _'..ft
		local cache_ok, cache = pcall(vim.api.nvim_buf_get_var, 0, cache_key)
		if cache_ok then
			return cache
		end

		local icon = ''
		-- TODO: Add general utilities icons
		-- Try kyazdani42/nvim-web-devicons
		local ok, devicons = pcall(require, 'nvim-web-devicons')
		if ok then
			local f_name, f_extension = vim.fn.expand('%:t'), vim.fn.expand('%:e')
			icon, _ = devicons.get_icon(f_name, f_extension)
		else
			-- Try ryanoasis/vim-devicons
			ok = vim.fn.exists('*WebDevIconsGetFileTypeSymbol')
			if ok ~= 0 then
				icon = vim.fn.WebDevIconsGetFileTypeSymbol()
			else
				-- Try lambdalisue/nerdfont.vim
				ok = vim.fn.exists('*nerdfont#find')
				if ok ~= 0 then
					icon = vim.fn['nerdfont#find'](vim.fn.bufname())
				end
			end
		end
		if icon == nil then
			icon = ''
		end
		vim.api.nvim_buf_set_var(0, cache_key, icon)

		return icon
	end
end

-- Detect trailing whitespace and cache result per buffer
function M.trails(symbol)
	return function()
		local cache_key = 'badge_cache_trails'
		local cache_ok, cache = pcall(vim.api.nvim_buf_get_var, 0, cache_key)
		if cache_ok then
			return cache
		end

		local msg = ''
		if
			not vim.bo.readonly
			and vim.bo.modifiable
			and vim.fn.line('$') < 9000
		then
			local trailing = vim.fn.search('\\s$', 'nw')
			if trailing > 0 then
				local label = symbol or 'WS:'
				msg = msg .. label .. trailing
			end
		end
		vim.api.nvim_buf_set_var(0, cache_key, msg)

		return msg
	end
end

function M.progress()
	return function()
		return '%l/%2c%4p%%'
	end
end

function M.session(symbol)
	return function()
		if vim.v.this_session then
			return symbol
		end
		return ''
	end
end

function M.utility_title()
	return function()
		local icons = {
			Trouble = '',
			DiffviewFiles = '',
			NeogitStatus = '',
			NvimTree = '',
			Outline = '',
			['lsp-installer'] = '',
			spectre_panel = '',
			['neo-tree-popup'] = ''
		}
		local padding = vim.g.global_symbol_padding or ' '
		return icons[vim.bo.filetype] .. padding .. '%y'
	end
end

return M
