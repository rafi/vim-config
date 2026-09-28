-- Neovim in the browser
-- Firenvim's browser extension can only ever set `g:started_by_firenvim`
-- *after* the plugin is installed and its native-messaging manifest is
-- registered, so installing/building must NOT be gated behind that variable
-- (that would make the very first bootstrap impossible). Always installed and
-- built, but only loaded (its `plugin/` Vimscript glue sourced) when actually
-- embedded in a browser.
--
-- firenvim#install() writes the launcher script the browser runs, at
-- $XDG_DATA_HOME/firenvim/firenvim (else next to stdpath('data')). It runs
-- on install and update, or at startup when that script is missing.
require('rafi.pack').build('firenvim', {
	build = function()
		vim.fn['firenvim#install'](0)
	end,
	is_built = function()
		local data_home = vim.env.XDG_DATA_HOME
		if not data_home or data_home == '' then
			data_home = vim.fn.fnamemodify(vim.fn.stdpath('data'), ':h')
		end
		local script = vim.fn.has('win32') == 1 and 'firenvim.bat' or 'firenvim'
		return vim.uv.fs_stat(data_home .. '/firenvim/' .. script) ~= nil
	end,
})
-- The browser extension launches nvim directly into firenvim's UI, so when
-- embedded, its `plugin/` must be sourced eagerly, before any deferred
-- `pack.later`/event trigger would run. Otherwise `load = false` behaves
-- like `:packadd!` (installed and on 'runtimepath' for :packadd, but its
-- plugin/ftdetect files not sourced).
vim.pack.add(
	{ 'https://github.com/glacambre/firenvim' },
	{ load = vim.g.started_by_firenvim == true }
)

-- Only does real work embedded in a browser (started_by_firenvim) or under
-- Neovide. Everywhere else the options below are skipped.
if not vim.g.started_by_firenvim and not vim.g.neovide then
	return
end

-- vim.g.neovide_scale_factor = 1
vim.opt.guifont = 'PragmataPro:h24'
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
vim.opt.laststatus = 1
-- vim.opt.showtabline = 1
vim.opt.signcolumn = 'no'
-- vim.opt.background = 'light'
vim.g.firenvim_config = {
	globalSettings = {
		alt = 'all',
	},
	localSettings = {
		['.*'] = {
			cmdline = 'neovim',
			content = 'text',
			priority = 0,
			selector = 'textarea',
			takeover = 'never',
		},
	},
}
