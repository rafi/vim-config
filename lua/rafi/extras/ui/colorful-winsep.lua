-- Colorful and animated window separators
local pack = require('rafi.pack')

pack.on_event('WinLeave,BufNewFile', function()
	vim.pack.add({ 'https://github.com/nvim-zh/colorful-winsep.nvim' })
	-- Only non-default values.
	require('colorful-winsep').setup({
		-- 'single', 'rounded', 'bold' or 'double'.
		border = 'rounded',
		animate = {
			shift = {
				delay = 10, -- about 60fps
				frames = 12, -- how many frames are required to complete the animation
			},
		},
		indicator_for_2wins = {
			-- Only works when there are exactly two windows.
			position = false, -- false to disable or choose between 'center', 'start', 'end' and 'both'
			symbols = {
				-- left, down, up, right are the separator's position.
				start_left = '▸',
				end_left = '▸',
				start_down = '▴',
				end_down = '▴',
				start_up = '▾',
				end_right = '◂',
			},
		},
	})
end)
