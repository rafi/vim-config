-- Every Lua file compiles, and plugin files follow the layout conventions
-- rafi.config and :RafiExtras rely on.

local H = require('helpers')

local T = MiniTest.new_set()

T['lua files compile'] = MiniTest.new_set({
	parametrize = vim.tbl_map(
		function(path)
			return { path }
		end,
		H.glob('init.lua', 'plugin/**/*.lua', 'after/**/*.lua', 'lua/rafi/**/*.lua')
	),
})

T['lua files compile']['loadfile'] = function(path)
	local chunk, err = loadfile(H.root .. '/' .. path)
	H.eq(err, nil)
	H.expect.no_equality(chunk, nil)
end

-- Core files: line 1 describes the plugin, line 2 is the disabled() guard
-- named after the file (plugin/mason.lua is 'mason').
T['core plugin'] = MiniTest.new_set({
	parametrize = vim.tbl_map(function(path)
		return { path }
	end, H.glob('plugin/*.lua')),
})

T['core plugin']['has description and guard'] = function(path)
	local lines = vim.fn.readfile(H.root .. '/' .. path, '', 2)
	local name = path:match('([^/]+)%.lua$')
	H.expect.no_equality(lines[1]:match('^%-%- %S'), nil)
	H.eq(lines[2], ("if require('rafi.config').disabled('%s') then"):format(name))
end

-- A disabled core file returns before doing anything: with its name in
-- rafi.json `disabled`, sourcing it with the usual side-effect APIs
-- stubbed to throw must not error.
T['core plugin']['does nothing when disabled'] = function(path)
	local config = require('rafi.config')
	local name = path:match('([^/]+)%.lua$')
	local stubbed = {
		{ vim.pack, 'add' },
		{ vim.keymap, 'set' },
		{ vim.api, 'nvim_create_autocmd' },
		{ vim.api, 'nvim_create_user_command' },
	}
	local originals = {}
	for i, s in ipairs(stubbed) do
		originals[i] = s[1][s[2]]
		s[1][s[2]] = function()
			error(s[2] .. ' ran')
		end
	end
	config._cache = { extras = {}, disabled = { name } }
	local ok, err = pcall(dofile, H.root .. '/' .. path)
	config._cache = nil
	for i, s in ipairs(stubbed) do
		s[1][s[2]] = originals[i]
	end
	H.eq(err, nil)
	H.eq(ok, true)
end

-- Extras: line 1 is the description :RafiExtras shows, and there is no
-- guard for the extra itself (rafi.json `extras` enables it instead).
T['extra'] = MiniTest.new_set({
	parametrize = vim.tbl_map(function(path)
		return { path }
	end, H.glob('lua/rafi/extras/*/*.lua')),
})

T['extra']['has description and no self guard'] = function(path)
	local src = table.concat(vim.fn.readfile(H.root .. '/' .. path), '\n')
	local cat, name = path:match('/([^/]+)/([^/]+)%.lua$')
	H.expect.no_equality(src:match('^%-%- %S'), nil)
	local guard = ("disabled('%s.%s')"):format(cat, name)
	H.eq(src:find(guard, 1, true), nil)
end

return T
