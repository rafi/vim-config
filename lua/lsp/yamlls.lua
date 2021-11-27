-- yaml-language-server settings
--

local config = {
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
					'helm/*.yaml',
					'kube/*.yaml',
				},
				['http://json.schemastore.org/github-workflow'] = '.github/workflows/*.{yml,yaml}',
				['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
				['http://json.schemastore.org/ansible-stable-2.9'] = 'roles/tasks/*.{yml,yaml}',
				['http://json.schemastore.org/ansible-playbook'] = 'playbook.{yml,yaml}',
				['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
				['http://json.schemastore.org/stylelintrc'] = '.stylelintrc.{yml,yaml}',
				['http://json.schemastore.org/circleciconfig'] = '.circleci/**/*.{yml,yaml}',
				['http://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
				['http://json.schemastore.org/helmfile'] = 'helmfile.{yml,yaml}',
				['http://json.schemastore.org/gitlab-ci'] = '/*lab-ci.{yml,yaml}',
				['https://raw.githubusercontent.com/awslabs/goformation/v5.2.11/schema/sam.schema.json'] = 'template.{yml,yaml}',
							},
							customTags = {
							 "!And scalar",
							 "!And mapping",
							 "!And sequence",
							 "!If scalar",
							 "!If mapping",
							 "!If sequence",
							 "!Not scalar",
							 "!Not mapping",
							 "!Not sequence",
							 "!Equals scalar",
							 "!Equals mapping",
							 "!Equals sequence",
							 "!Or scalar",
							 "!Or mapping",
							 "!Or sequence",
							 "!FindInMap scalar",
							 "!FindInMap mappping",
							 "!FindInMap sequence",
							 "!Base64 scalar",
							 "!Base64 mapping",
							 "!Base64 sequence",
							 "!Cidr scalar",
							 "!Cidr mapping",
							 "!Cidr sequence",
							 "!Ref scalar",
							 "!Ref mapping",
							 "!Ref sequence",
							 "!Sub scalar",
							 "!Sub mapping",
							 "!Sub sequence",
							 "!GetAtt scalar",
							 "!GetAtt mapping",
							 "!GetAtt sequence",
							 "!GetAZs scalar",
							 "!GetAZs mapping",
							 "!GetAZs sequence",
							 "!ImportValue scalar",
							 "!ImportValue mapping",
							 "!ImportValue sequence",
							 "!Select scalar",
							 "!Select mapping",
							 "!Select sequence",
							 "!Split scalar",
							 "!Split mapping",
							 "!Split sequence",
							 "!Join scalar",
							 "!Join mapping",
							 "!Join sequence",
							},
			}
		}
	}
}

return {
	config = function(_) return config end,
}
