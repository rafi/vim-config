-- Util: blink.cmp helpers (keymap actions, native snippet expansion)
-- Based on LazyVim's lazyvim.util.cmp

---@class rafi.util.blink
local M = {}

---@alias rafi.util.blink.Action fun():boolean?
-- Named actions for M.map(). Other plugins (e.g. AI completion) may
-- register their own, like `ai_accept` or `ai_nes`.
---@type table<string, rafi.util.blink.Action>
M.actions = {
	-- Native Snippets
	snippet_forward = function()
		if vim.snippet.active({ direction = 1 }) then
			vim.schedule(function()
				vim.snippet.jump(1)
			end)
			return true
		end
	end,
	snippet_stop = function()
		if vim.snippet then
			vim.snippet.stop()
		end
	end,
}

-- Returns a blink.cmp keymap command that runs the first successful action.
---@param actions string[]
---@param fallback? string|fun()
function M.map(actions, fallback)
	return function()
		for _, name in ipairs(actions) do
			if M.actions[name] then
				local ret = M.actions[name]()
				if ret then
					return true
				end
			end
		end
		return type(fallback) == 'function' and fallback() or fallback
	end
end

---@alias Placeholder {n:number, text:string}

---@param snippet string
---@param fn fun(placeholder:Placeholder):string
---@return string
function M.snippet_replace(snippet, fn)
	return snippet:gsub('%$%b{}', function(m)
		local n, name = m:match('^%${(%d+):(.+)}$')
		return n and fn({ n = n, text = name }) or m
	end) or snippet
end

-- Resolves nested placeholders in a snippet.
---@param snippet string
---@return string
function M.snippet_preview(snippet)
	local ok, parsed = pcall(function()
		return vim.lsp._snippet_grammar.parse(snippet)
	end)
	return ok and tostring(parsed)
		or M.snippet_replace(snippet, function(placeholder)
			return M.snippet_preview(placeholder.text)
		end):gsub('%$0', '')
end

-- Replaces nested placeholders in a snippet with LSP placeholders.
---@param snippet string
---@return string
function M.snippet_fix(snippet)
	local texts = {} ---@type table<number, string>
	return M.snippet_replace(snippet, function(placeholder)
		texts[placeholder.n] = texts[placeholder.n]
			or M.snippet_preview(placeholder.text)
		return '${' .. placeholder.n .. ':' .. texts[placeholder.n] .. '}'
	end)
end

-- Expand with vim.snippet, auto-fixing snippets that fail to parse.
---@param snippet string
function M.expand(snippet)
	-- Native sessions don't support nested snippet sessions.
	-- Always use the top-level session.
	-- Otherwise, when on the first placeholder and selecting a new completion,
	-- the nested session will be used instead of the top-level session.
	-- See: https://github.com/LazyVim/LazyVim/issues/3199
	local session = vim.snippet.active() and vim.snippet._session or nil

	local ok, err = pcall(vim.snippet.expand, snippet)
	if not ok then
		local fixed = M.snippet_fix(snippet)
		ok = pcall(vim.snippet.expand, fixed)

		local msg = ok
				and 'Failed to parse snippet,\nbut was able to fix it automatically.'
			or ('Failed to parse snippet.\n' .. err)

		vim.notify(
			('%s\n```%s\n%s\n```'):format(msg, vim.bo.filetype, snippet),
			ok and vim.log.levels.WARN or vim.log.levels.ERROR,
			{ title = 'vim.snippet' }
		)
	end

	-- Restore top-level session when needed
	if session then
		vim.snippet._session = session
	end
end

return M
