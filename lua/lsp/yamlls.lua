-- yaml-language-server settings
--

local config = {
	filetypes = {
		'yaml',
		'yaml.ansible',
		'yaml.docker-compose',
		'helm',
	},
	settings = {
		yaml = {
			format = { enable = true, singleQuote = true },
			validate = true,
			hover = true,
			completion = true,
			schemaStore = {
				enable = true,
				url = 'https://www.schemastore.org/api/json/catalog.json',
			},
			schemas = {
				kubernetes = {
					'helm/**/templates/**/*.yaml',
					'kube/**/*.yaml',
				},
				['https://json.schemastore.org/github-workflow.json'] = '.github/workflows/*.{yml,yaml}',
				['https://json.schemastore.org/github-action.json'] = '.github/action.{yml,yaml}',
				['https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json'] = '/*lab-ci.{yml,yaml}',
				['https://raw.githubusercontent.com/ansible-community/schemas/main/f/ansible-tasks.json'] = 'roles/tasks/**/*.{yml,yaml}',
				['https://raw.githubusercontent.com/ansible-community/schemas/main/f/ansible-playbook.json'] = 'playbook{s,}/**/*.{yml,yaml}',
				['https://raw.githubusercontent.com/ansible-community/schemas/main/f/ansible-inventory.json'] = 'inventory/*.{ini,yml}',
				['https://json.schemastore.org/prettierrc.json'] = '.prettierrc.{yml,yaml}',
				['https://json.schemastore.org/stylelintrc.json'] = '.stylelintrc.{yml,yaml}',
				['https://json.schemastore.org/circleciconfig'] = '.circleci/**/*.{yml,yaml}',
				['https://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
				['https://json.schemastore.org/helmfile'] = 'helmfile.{yml,yaml}',
			}
		}
	}
}

return {
	config = function(_) return config end,
}
