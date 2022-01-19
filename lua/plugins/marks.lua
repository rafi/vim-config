-- plugin: marks.nvim
-- see: https://github.com/chentau/marks.nvim
-- rafi settings

require'marks'.setup({
	-- whether to map keybinds or not.
	default_mappings = true,
	-- which builtin marks to show. default {}
	-- builtin_marks = { '.', '<', '>', '^' },
	-- whether movements cycle back to the beginning/end of buffer.
	cyclic = true,
	-- whether the shada file is updated after modifying uppercase marks.
	force_write_shada = false,
	-- how often (in ms) to redraw signs/recompute mark positions.
	-- higher values will have better performance but may cause visual lag,
	-- while lower values may cause performance penalties. default 150.
	refresh_interval = 250,
	-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
	-- marks, and bookmarks.
	-- can be either a table with all/none of the keys, or a single number, in which case
	-- the priority applies to all marks.
	sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },

	bookmark_1 = { sign = '⚑', virt_text = '─────────────────' },

	mappings = {
		annotate = "m<Space>",
	}
})
