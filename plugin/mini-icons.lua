-- Icon provider
if require('rafi.config').disabled('mini-icons') then
	return
end

-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/typescript/init.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/go.lua

-- Eager: setup is cheap, and snacks reads the `MiniIcons` global directly
-- (no `require`), so it must exist before the first picker/explorer.
vim.pack.add({ 'https://github.com/nvim-mini/mini.icons' })
require('mini.icons').setup({
	file = {
		['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
		['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
		-- Go
		['.go-version'] = { glyph = '', hl = 'MiniIconsBlue' },
		-- JavaScript/TypeScript
		['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
		['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
		['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
		['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
		['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
		['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
		['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
		['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
		['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
	},
	filetype = {
		gotmpl = { glyph = '󰟓', hl = 'MiniIconsGrey' },
		dotenv = { glyph = '', hl = 'MiniIconsYellow' },
	},
})

-- Plugins asking for nvim-web-devicons get the mini.icons mock.
package.preload['nvim-web-devicons'] = function()
	require('mini.icons').mock_nvim_web_devicons()
	return package.loaded['nvim-web-devicons']
end
