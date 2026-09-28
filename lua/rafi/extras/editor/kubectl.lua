-- Browse and manage Kubernetes resources
-- A release tag lets blink.lib fetch the prebuilt kubectl_client
-- library on first setup (restart after it downloads), so no cargo build.
local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/saghen/blink.lib',
		{
			src = 'https://github.com/ramilito/kubectl.nvim',
			version = vim.version.range('2.*'),
		},
	})
	-- Setup creates the commands, replacing the stubs below.
	require('kubectl').setup({})
end

require('rafi.pack').command(
	{ 'Kubectl', 'Kubectx', 'Kubens' },
	load,
	{ complete = true }
)

-- stylua: ignore start
vim.keymap.set('n', '<leader>8', function() load() vim.cmd.tabnew() require('kubectl').open() end, { desc = 'Kubectl' })
-- stylua: ignore end
