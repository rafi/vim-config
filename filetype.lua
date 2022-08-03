-- Filetype detection
--

-- Enable neovim runtime filetype.lua
vim.g.do_filetype_lua = 1

vim.filetype.add({
	filename = {
		Brewfile = 'ruby',
		justfile = 'just',
		Justfile = 'just',
		Tmuxfile = 'tmux',
		['go.sum'] = 'go',
		['yarn.lock'] = 'yaml',
		['.buckconfig'] = 'toml',
		['.flowconfig'] = 'ini',
		['.tern-project'] = 'json',
		['.jsbeautifyrc'] = 'json',
		['.jscsrc'] = 'json',
		['.watchmanconfig'] = 'json',
	},
	pattern = {
		['.*%.js%.map'] = 'json',
		['.*%.postman_collection'] = 'json',
		['Jenkinsfile.*'] = 'groovy',
		['%.kube/config'] = 'yaml',
		['%.config/git/users/.*'] = 'gitconfig',
		['.*/templates/.*%.yaml'] = 'helm',
		['.*/templates/.*%.yml'] = 'helm',
		['.*/templates/.*%.tpl'] = 'helm',
		['.*/playbooks/.*%.yaml'] = 'yaml.ansible',
		['.*/playbooks/.*%.yml'] = 'yaml.ansible',
		['.*/roles/.*%.yaml'] = 'yaml.ansible',
		['.*/roles/.*%.yml'] = 'yaml.ansible',
		['.*/inventory/.*%.ini'] = 'ansible_hosts',
	},
})
