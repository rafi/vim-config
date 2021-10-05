-- LSP kind items
-- github.com/rafi/vim-config

-- Default completion kind symbols.
local kind_presets = {
	default = {
		Text = '', --   𝓐
		Method = '', --  ƒ
		Function = '', -- 
		Constructor = '', --   
		Field = '', --  ﴲ ﰠ   
		Variable = '', --   
		Class = '', --  ﴯ 𝓒
		Interface = '', -- ﰮ    
		Module = '', --   
		Property = '襁', -- ﰠ 襁
		Unit = '', --  塞
		Value = '',
		Enum = '練', -- 練 ℰ 
		Keyword = '', --   🔐
		Snippet = '⮡', -- ﬌  ⮡ 
		Color = '',
		File = '', --  
		Reference = '', --  
		Folder = '', --  
		EnumMember = '',
		Constant = '', --  
		Struct = '', --   𝓢 פּ
		Event = '', --  🗲
		Operator = '', --   +
		TypeParameter = '', --  𝙏
	},
}

-- Default preset name.
local preset_name = 'default'

-- Initialize vim.lsp.protocol completion item kinds.
local function init(opts)
	local with_text = opts == nil or opts['with_text']
	local lsp_protocol_items = require('vim.lsp.protocol').CompletionItemKind
	preset_name = opts ~= nil and opts['preset'] or 'default'

	for key, label in pairs(kind_presets[preset_name]) do
		local index = lsp_protocol_items[key]
		if index == nil then
			print('Error: Unable to find index of CompletionItemKind: ' .. key)
		else
			if with_text or with_text == nil then
				if label ~= nil then
					label = label .. (vim.g.global_symbol_padding or ' ')
				end
				label = string.format('%s%s', label, key)
			end
			lsp_protocol_items[index] = label
		end
	end
end

-- Return initialized preset.
local function preset()
	return kind_presets[preset_name]
end

return {
	init = init,
	preset = preset,
}
