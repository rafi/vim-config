-- Util: blink.cmp helpers (keymap actions, native snippet expansion)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/cmp.lua

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

-- Sources that other extras add to blink.cmp (AI completion, dadbod).
-- Register them at the top level of the extra file: coding.blink reads
-- them once, when blink loads on the first InsertEnter or CmdlineEnter.
---@class rafi.blink.Source
---@field id string
---@field provider blink.cmp.SourceProviderConfigPartial
---@field filetypes? string[] Enable only for these filetypes, not by default
---@type rafi.blink.Source[]
M.sources = {}
-- Filetypes per source id where that source is turned off.
---@type table<string, string[]>
M.disabled = {}

-- Warn when an extra registers after blink loaded, so it's not lost quietly.
---@param what string
local function warn_if_loaded(what)
	if package.loaded['blink.cmp'] then
		vim.notify(
			('%s registered after blink.cmp loaded, it has no effect'):format(what),
			vim.log.levels.WARN
		)
	end
end

-- Register a completion source. Does nothing when coding.blink is off.
---@param id string Provider id, e.g. 'copilot'
---@param provider blink.cmp.SourceProviderConfigPartial
---@param filetypes? string[] Enable only for these filetypes
function M.add_source(id, provider, filetypes)
	warn_if_loaded(('blink.cmp source %q'):format(id))
	table.insert(M.sources, {
		id = id,
		provider = provider,
		filetypes = filetypes,
	})
end

-- Turn off a source, e.g. 'path', in some filetypes.
---@param id string Provider id
---@param filetypes string[]
function M.disable_source(id, filetypes)
	warn_if_loaded(('blink.cmp source %q filter'):format(id))
	M.disabled[id] = vim.list_extend(M.disabled[id] or {}, filetypes)
end

-- Merge the registered sources into blink.cmp opts, before setup.
---@param opts blink.cmp.Config
function M.apply_sources(opts)
	opts.sources = opts.sources or {}
	local sources = opts.sources
	sources.default = sources.default or {}
	sources.providers = sources.providers or {}
	sources.per_filetype = sources.per_filetype or {}
	for _, source in ipairs(M.sources) do
		sources.providers[source.id] = source.provider
		if source.filetypes then
			for _, ft in ipairs(source.filetypes) do
				local list = sources.per_filetype[ft]
				if list == nil then
					list = { inherit_defaults = true }
					sources.per_filetype[ft] = list
				end
				if type(list) == 'table' and not vim.list_contains(list, source.id) then
					table.insert(list, source.id)
				end
			end
		elseif
			type(sources.default) == 'table'
			and not vim.list_contains(sources.default, source.id)
		then
			table.insert(sources.default, source.id)
		end
	end
	-- Wrap each filtered provider's `enabled`, keeping any check it had.
	for id, filetypes in pairs(M.disabled) do
		local provider = sources.providers[id] or {}
		local enabled = provider.enabled
		provider.enabled = function()
			if vim.list_contains(filetypes, vim.bo.filetype) then
				return false
			end
			if type(enabled) == 'function' then
				return enabled()
			end
			return enabled ~= false
		end
		sources.providers[id] = provider
	end
end

-- Whether a non-blank character is right before the cursor.
---@return boolean
function M.has_words_before()
	local col = vim.fn.col('.') - 1
	return col > 0 and vim.fn.getline('.'):sub(col, col):match('%s') == nil
end

-- Runs fn only in insert mode, so select mode gets just the snippet jumps.
---@param fn fun(cmp: blink.cmp.API): boolean?
---@return fun(cmp: blink.cmp.API): boolean?
local function insert_only(fn)
	return function(cmp)
		if vim.fn.mode():sub(1, 1) == 'i' then
			return fn(cmp)
		end
	end
end

-- Supertab <Tab>/<S-Tab>: menu item, snippet jump, AI, show, fallback.
-- Snippet commands stay strings so blink.cmp also maps them in select mode.
---@return table<string, blink.cmp.KeymapCommand[]>
function M.supertab()
	return {
		['<Tab>'] = {
			insert_only(function(cmp)
				return cmp.is_menu_visible() and cmp.select_next()
			end),
			'snippet_forward',
			insert_only(M.map({ 'ai_nes', 'ai_accept' })),
			insert_only(function(cmp)
				return M.has_words_before() and cmp.show()
			end),
			'fallback',
		},
		['<S-Tab>'] = {
			insert_only(function(cmp)
				return cmp.is_menu_visible() and cmp.select_prev()
			end),
			'snippet_backward',
			'fallback',
		},
	}
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
	-- Keep the top-level session. vim.snippet can't nest sessions.
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
