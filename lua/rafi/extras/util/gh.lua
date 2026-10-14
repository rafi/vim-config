-- GitHub code review inside Neovim (gh.nvim, needs the `gh` CLI)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/util/gh.lua

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({
		'https://github.com/ldelossa/litee.nvim',
		'https://github.com/ldelossa/gh.nvim',
	})
	require('litee.lib').setup()
	require('litee.gh').setup({})
end

-- Commands come from setup(), so keys load the plugin first.
local function map(lhs, cmd, desc)
	vim.keymap.set('n', lhs, function()
		load()
		vim.cmd(cmd)
	end, { desc = desc })
end

-- stylua: ignore start
map('<leader>Gcc', 'GHCloseCommit',    'Close')
map('<leader>Gce', 'GHExpandCommit',   'Expand')
map('<leader>Gco', 'GHOpenToCommit',   'Open To')
map('<leader>Gcp', 'GHPopOutCommit',   'Pop Out')
map('<leader>Gcz', 'GHCollapseCommit', 'Collapse')
map('<leader>Gip', 'GHPreviewIssue',   'Preview')
map('<leader>Gio', 'GHOpenIssue',      'Open')
map('<leader>Glt', 'LTPanel',          'Toggle Panel')
map('<leader>Gpc', 'GHClosePR',        'Close')
map('<leader>Gpd', 'GHPRDetails',      'Details')
map('<leader>Gpe', 'GHExpandPR',       'Expand')
map('<leader>Gpo', 'GHOpenPR',         'Open')
map('<leader>Gpp', 'GHPopOutPR',       'PopOut')
map('<leader>Gpr', 'GHRefreshPR',      'Refresh')
map('<leader>Gpt', 'GHOpenToPR',       'Open To')
map('<leader>Gpz', 'GHCollapsePR',     'Collapse')
map('<leader>Grb', 'GHStartReview',    'Begin')
map('<leader>Grc', 'GHCloseReview',    'Close')
map('<leader>Grd', 'GHDeleteReview',   'Delete')
map('<leader>Gre', 'GHExpandReview',   'Expand')
map('<leader>Grs', 'GHSubmitReview',   'Submit')
map('<leader>Grz', 'GHCollapseReview', 'Collapse')
map('<leader>Gtc', 'GHCreateThread',   'Create')
map('<leader>Gtn', 'GHNextThread',     'Next')
map('<leader>Gtt', 'GHToggleThread',   'Toggle')
-- stylua: ignore end

require('rafi.util.mini').on_which_key(function()
	require('which-key').add({
		{ '<leader>G', group = 'Github' },
		{ '<leader>Gc', group = 'Commits' },
		{ '<leader>Gi', group = 'Issues' },
		{ '<leader>Gl', group = 'Litee' },
		{ '<leader>Gp', group = 'Pull Request' },
		{ '<leader>Gr', group = 'Review' },
		{ '<leader>Gt', group = 'Threads' },
	})
end)
