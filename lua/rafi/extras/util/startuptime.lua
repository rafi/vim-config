-- Measure startup time (vim-startuptime)
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.g.startuptime_tries = 10
	vim.pack.add({ 'https://github.com/dstein64/vim-startuptime' })
end

-- The stub only loads the plugin, which defines :StartupTime.
require('rafi.pack').command('StartupTime', load, {
	nargs = '*',
	range = true,
	bang = true,
})
