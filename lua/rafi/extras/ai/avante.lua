-- Cursor-like AI chat and edit sidebar (avante.nvim)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/avante.lua
local pack = require('rafi.pack')

require('rafi.util.mini').on_which_key(function()
	require('which-key').add({
		{ '<leader>a', group = 'ai', mode = { 'n', 'x' } },
	})
end)

-- Build avante's native libraries, from source with cargo or from the
-- prebuilt release. Reruns on update and when the libraries are missing.
pack.build('avante.nvim', {
	deps = {
		'plenary.nvim',
		'nui.nvim',
		'mega.logging',
		'mega.cmdparse',
		'img-clip.nvim',
	},
	build = function(path)
		local cmd = { 'make' }
		if vim.fn.has('win32') ~= 0 then
			cmd = {
				'powershell',
				'-ExecutionPolicy',
				'Bypass',
				'-File',
				'Build.ps1',
				'-BuildFromSource',
				'false',
			}
		elseif vim.fn.executable('cargo') ~= 1 then
			cmd = { 'bash', 'build.sh' }
		end
		local out = vim.system(cmd, { cwd = path }):wait()
		if out.code ~= 0 then
			vim.notify(
				'avante.nvim build failed:\n' .. (out.stderr or ''),
				vim.log.levels.ERROR
			)
		end
	end,
	is_built = function(path)
		return vim.fn.glob(path .. '/lua/avante_templates.*') ~= ''
	end,
})

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true

	-- Let render-markdown (lang.markdown) render Avante buffers too.
	local markdown = pack.has('render-markdown.nvim')
	if markdown then
		local config = vim.g.render_markdown_config or {}
		config.file_types = { 'markdown', 'Avante' }
		vim.g.render_markdown_config = config
		if package.loaded['render-markdown'] then
			require('render-markdown').setup(config)
		else
			vim.pack.add({
				'https://github.com/MeanderingProgrammer/render-markdown.nvim',
			})
			pack.refire_filetype('RenderMarkdown')
		end
	end

	vim.pack.add({
		'https://github.com/nvim-lua/plenary.nvim',
		'https://github.com/MunifTanjim/nui.nvim',
		'https://github.com/ColinKennedy/mega.logging',
		'https://github.com/ColinKennedy/mega.cmdparse',
		-- Image pasting, wired by avante's plugin/ file.
		'https://github.com/HakonHarnes/img-clip.nvim',
		-- blink.cmp source for avante's input buffer and @-mentions.
		'https://github.com/Kaiser-Yang/blink-cmp-avante',
		{
			src = 'https://github.com/avante-corp/avante.nvim',
			version = 'main',
		},
	})

	require('img-clip').setup({
		-- recommended settings
		default = {
			embed_image_as_base64 = false,
			prompt_for_file_name = false,
			drag_and_drop = {
				insert_mode = true,
			},
			-- required for Windows users
			use_absolute_path = true,
		},
	})

	require('avante').setup({
		provider = 'copilot',
		selection = {
			hint_display = 'none',
		},
		behaviour = {
			auto_set_keymaps = false,
		},
	})
end

-- Only in avante's prompt buffer, which exists once avante loaded.
require('rafi.util.blink').add_source(
	'avante',
	{ module = 'blink-cmp-avante', name = 'Avante' },
	{ 'AvanteInput' }
)

-- Load avante on first use of its commands.
pack.command({
	'Avante',
	'AvanteACPModels',
	'AvanteAsk',
	'AvanteBuild',
	'AvanteChat',
	'AvanteChatNew',
	'AvanteClear',
	'AvanteEdit',
	'AvanteFocus',
	'AvanteHistory',
	'AvanteModels',
	'AvanteRefresh',
	'AvanteShowRepoMap',
	'AvanteStop',
	'AvanteSwitchProvider',
	'AvanteToggle',
}, load, { complete = true })

---@param lhs string
---@param cmd string
---@param desc string
local function map(lhs, cmd, desc)
	vim.keymap.set('n', lhs, function()
		vim.cmd(cmd)
	end, { desc = desc })
end

-- NOTE: Conflict: ai.copilot-chat, ai.claudecode and ai.sidekick map it too.
map('<leader>aa', 'AvanteAsk', 'Ask Avante')
-- NOTE: Conflict: ai.claudecode maps it too.
map('<leader>ac', 'AvanteChat', 'Chat with Avante')
map('<leader>ae', 'AvanteEdit', 'Edit Avante')
-- NOTE: Conflict: ai.claudecode and ai.sidekick map it too.
map('<leader>af', 'AvanteFocus', 'Focus Avante')
map('<leader>ah', 'AvanteHistory', 'Avante History')
map('<leader>am', 'AvanteModels', 'Select Avante Model')
map('<leader>an', 'AvanteChatNew', 'New Avante Chat')
-- NOTE: Conflict: ai.copilot-chat and ai.sidekick map it too.
-- Only changes the provider for this session. `--save` would persist it and
-- then override `provider` in the setup options at startup.
map('<leader>ap', 'AvanteSwitchProvider', 'Switch Avante Provider')
-- NOTE: Conflict: ai.claudecode maps it too.
map('<leader>ar', 'AvanteRefresh', 'Refresh Avante')
-- NOTE: Conflict: ai.sidekick maps it too.
map('<leader>as', 'AvanteStop', 'Stop Avante')
map('<leader>at', 'AvanteToggle', 'Toggle Avante')
