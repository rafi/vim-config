-- Visualize keyboard mappings for a prefix on a keyboard layout
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/meznaric/key-analyzer.nvim' })
	-- Setup creates the :KeyAnalyzer command, replacing the stub below.
	require('key-analyzer').setup({})
end

require('rafi.pack').command('KeyAnalyzer', load, {
	nargs = '+',
	desc = 'Analyze keyboard mappings for a specific prefix and mode',
	complete = true,
})
