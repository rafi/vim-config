-- Cmp utilities
-- https://github.com/rafi/vim-config

-- Several cmp mapping helpers to use to your liking.
-- Based on: https://github.com/VonHeikemen/lsp-zero.nvim

---@class rafi.util.cmp
local M = {}

local function get_cmp()
	local ok_cmp, cmp = pcall(require, 'cmp')
	return ok_cmp and cmp or {}
end

---@class rafi.snippet.client
---@field active fun(filter: vim.snippet.ActiveFilter): boolean
---@field jump fun(direction: number): boolean

-- Return luasnip or native vim.snippet.
---@return rafi.snippet.client
local function get_snippet_client()
	local ok, luasnip = pcall(require, 'luasnip')
	if not ok then
		return vim.snippet or nil
	end

	-- Add 'active' method to luasnip to match vim.snippet.active behavior.
	if not luasnip.active then
		luasnip.active = function(filter)
			if filter and filter.direction then
				return luasnip.locally_jumpable(filter.direction)
			end
			LazyVim.error('luasnip.active: opts.direction is required')
		end
	end
	return luasnip
end

-- Enables completion when the cursor is inside a word. If the completion
-- menu is visible it will navigate to the next item in the list. If the
-- line is empty it uses the fallback.
---@param select_opts? cmp.SelectOption
---@return cmp.Mapping
function M.tab_complete(select_opts)
	local cmp = get_cmp()
	return cmp.mapping(function(fallback)
		local col = vim.fn.col('.') - 1

		if cmp.visible() then
			cmp.select_next_item(select_opts)
		elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
			fallback()
		else
			cmp.complete()
		end
	end, { 'i', 's' })
end

-- If the completion menu is visible navigate to the previous item
-- in the list. Else, use the fallback.
---@param select_opts? cmp.SelectOption
---@return cmp.Mapping
function M.select_prev_or_fallback(select_opts)
	local cmp = get_cmp()
	return cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item(select_opts)
		else
			fallback()
		end
	end, { 'i', 's' })
end

-- If the completion menu is visible it cancels the
-- popup. Else, it triggers the completion menu.
---@param opts {modes?: string[]}
function M.toggle_completion(opts)
	opts = opts or {}
	local cmp = get_cmp()

	return cmp.mapping(function()
		if cmp.visible() then
			cmp.abort()
		else
			cmp.complete()
		end
	end, opts.modes)
end

---
-- Snippet related mappings
---

-- If the completion menu is visible it will navigate to the next item in
-- the list. If cursor is on top of the trigger of a snippet it'll expand
-- it. If the cursor can jump to a snippet placeholder, it moves to it.
-- If the cursor is in the middle of a word that doesn't trigger a snippet
-- it displays the completion menu. Else, it uses the fallback.
---@param select_opts? cmp.SelectOption
---@return cmp.Mapping
function M.supertab(select_opts)
	local cmp = get_cmp()
	local snippet = get_snippet_client()
	return {
		i = function(fallback)
			local col = vim.fn.col('.') - 1
			if cmp.visible() then
				cmp.select_next_item(select_opts)
			elseif snippet and snippet.active({ direction = 1 }) then
				snippet.jump(1)
			elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
				fallback()
			else
				cmp.complete()
			end
		end,
		s = function(fallback)
			if snippet and snippet.active({ direction = 1 }) then
				snippet.jump(1)
			else
				fallback()
			end
		end,
	}
end

-- If the completion menu is visible it will navigate to previous item in the
-- list. If the cursor can navigate to a previous snippet placeholder, it
-- moves to it. Else, it uses the fallback.
---@param select_opts? cmp.SelectOption
---@return cmp.Mapping
function M.supertab_shift(select_opts)
	local cmp = get_cmp()
	local snippet = get_snippet_client()
	return {
		i = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item(select_opts)
			elseif snippet and snippet.active({ direction = -1 }) then
				snippet.jump(-1)
			else
				fallback()
			end
		end,
		s = function(fallback)
			if snippet and snippet.active({ direction = -1 }) then
				snippet.jump(-1)
			else
				fallback()
			end
		end,
	}
end

-- If completion menu is visible it will navigate to the next item in the
-- list. If the cursor can jump to a snippet placeholder, it moves to it.
-- Else, it uses the fallback.
---@param select_opts? cmp.SelectOption
---@return cmp.Mapping
function M.snippet_next(select_opts)
	local cmp = get_cmp()
	local snippet = get_snippet_client()

	return cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_next_item(select_opts)
		elseif snippet and snippet.active({ direction = 1 }) then
			snippet.jump(1)
		else
			fallback()
		end
	end, { 'i', 's' })
end

-- Go to the next snippet placeholder.
---@return cmp.Mapping
function M.snippet_jump_forward()
	local cmp = get_cmp()
	local snippet = get_snippet_client()

	return cmp.mapping(function(fallback)
		if snippet and snippet.active({ direction = 1 }) then
			snippet.jump(1)
		else
			fallback()
		end
	end, { 'i', 's' })
end

-- Go to the previous snippet placeholder.
---@return cmp.Mapping
function M.snippet_jump_backward()
	local cmp = get_cmp()
	local snippet = get_snippet_client()

	return cmp.mapping(function(fallback)
		if snippet and snippet.active({ direction = -1 }) then
			snippet.jump(-1)
		else
			fallback()
		end
	end, { 'i', 's' })
end

return M
