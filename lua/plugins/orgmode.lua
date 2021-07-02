-- plugin: orgmode.nvim
-- see: https://github.com/kristijanhusak/orgmode.nvim
-- rafi settings

require('orgmode').setup({
	-- org_agenda_files = {'~/docs/org/*', '~/my-orgs/**/*'},
	org_agenda_files = {'~/docs/org/*'},
	org_default_notes_file = '~/docs/org/refile.org',
	-- mappings = {
	-- 	disable_all = false,
	-- 	global = {
	-- 		org_agenda = '<Leader>p',
	-- 		org_capture = '<Leader>oc',
	-- 	},
	-- },
})
