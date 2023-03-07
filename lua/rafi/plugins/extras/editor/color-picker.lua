return {

	{
		'ziontee113/color-picker.nvim',
		event = 'FileType',
		opts = {
			-- :h colorizer.lua
			['icons'] = { '', '' },
			-- ['icons'] = { 'ﱢ', '' },
			-- ['icons'] = { 'ﮊ', '' },
			-- ['icons'] = { '', 'ﰕ' },
			-- ['icons'] = { '', '' },
			-- ['icons'] = { '', '' },
			['keymap'] = {
				['U'] = '<Plug>ColorPickerSlider5Decrease',
				['O'] = '<Plug>ColorPickerSlider5Increase',
			},
		},
	}

}
