-- json-language-server settings
--

local config = {
	settings = {
		json = {
			format = { enable = true },
			schemas = {
				{
					fileMatch = { '.babelrc.json', '.babelrc', 'babel.config.json' },
					url = 'http://json.schemastore.org/babelrc.json'
				},
				{
					fileMatch = { '.csslintrc' },
					url = 'http://json.schemastore.org/csslintrc.json'
				},
				{
					fileMatch = { '.eslintrc.json', '.eslintrc' },
					url = 'http://json.schemastore.org/eslintrc'
				},
				{
					fileMatch = { '.golangci.json' },
					url = 'http://json.schemastore.org/golangci-lint.json'
				},
				{
					fileMatch = { 'graphql.config.json', '.graphqlrc', '.graphqlrc.json' },
					url = 'http://unpkg.com/graphql-config/config-schema.json'
				},
				{
					fileMatch = { '.jshintrc' },
					url = 'http://json.schemastore.org/jshintrc.json'
				},
				{
					fileMatch = { 'lerna.json' },
					url = 'http://json.schemastore.org/lerna'
				},
				{
					fileMatch = {
						'.markdownlintrc', '.markdownlint.json', '.markdownlint.jsonc'
					},
					url = 'http://json.schemastore.org/markdownlint.json'
				},
				{
					fileMatch = { 'now.json', 'vercel.json' },
					url = 'http://json.schemastore.org/now'
				},
				{
					fileMatch = { 'package.json' },
					url = 'http://json.schemastore.org/package.json'
				},
				{
					fileMatch = { 'packer.json' },
					url = 'http://json.schemastore.org/packer.json'
				},
				{
					fileMatch = { '.postcssrc', '.postcssrc.json' },
					url = 'http://json.schemastore.org/postcssrc.json'
				},
				{
					fileMatch = {
						'.prettierrc', '.prettierrc.json', 'prettier.config.json'
					},
					url = 'http://json.schemastore.org/prettierrc',
				},
				{
					fileMatch = { 'resume.json' },
					url = 'http://json.schemastore.org/resume.json',
				},
				{
					fileMatch = { '.solidarity', '.solidarity.json' },
					url = 'http://json.schemastore.org/solidaritySchema.json'
				},
				{
					fileMatch = {
						'.stylelintrc', '.stylelintrc.json', 'stylelint.config.json'
					},
					url = 'http://json.schemastore.org/stylelintrc.json'
				},
				{
					fileMatch = { 'swagger.json' },
					url = 'http://json.schemastore.org/swagger-2.0.json'
				},
				{
					fileMatch = { 'tsconfig.json' },
					url = 'http://json.schemastore.org/tsconfig.json'
				},
				{
					fileMatch = { 'tslint.json' },
					url = 'http://json.schemastore.org/tslint.json'
				}
			}
		}
	}
}

return {
	config = function(_) return config end,
}
