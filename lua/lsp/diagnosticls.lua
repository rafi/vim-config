-- diagnostic-languageserver
-- see: https://github.com/iamcco/diagnostic-languageserver
-- rafi settings

local config = {
	filetypes = {
		'dockerfile',
		'go',
		'javascript',
		'javascriptreact',
		'typescript',
		'typescriptreact',
		'css',
		'scss',
		'html',
		'yaml',
		'lua',
		'vue',
		'markdown',
		'sh',
		'vim',
	},
	init_options = {
		linters = {
			shellcheck = {
				command = "shellcheck",
				debounce = 100,
				args = { "--format", "json", "-" },
				sourceName = "shellcheck",
				parseJson = {
					line = "line",
					column = "column",
					endLine = "endLine",
					endColumn = "endColumn",
					message = "${message} [${code}]",
					security = "level"
				},
				securities = {
					error = "error",
					warning = "warning",
					info = "info",
					style = "hint"
				}
			},
			-- shellcheck = {
			--   sourceName = "shellcheck",
			--   command = "shellcheck",
			--   debounce = 100,
			--   args = {"--format=gcc", "-"},
			--   offsetLine = 0,
			--   offsetColumn = 0,
			--   formatLines = 1,
			--   formatPattern = {
			--     "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
			--     { line = 1, column = 2, message = 4, security = 3 }
			--   },
			--   securities = {error = "error", warning = "warning", note = "info"}
			-- },
			eslint = {
				command = './node_modules/.bin/eslint',
				rootPatterns = {'.git'},
				debounce = 100,
				args = {'--stdin', '--stdin-filename', '%filepath', '--format', 'json'},
				sourceName = 'eslint',
				parseJson = {
					errorsRoot = '[0].messages',
					line = 'line',
					column = 'column',
					endLine = 'endLine',
					endColumn = 'endColumn',
					message = '[eslint] ${message} [${ruleId}]',
					security = 'severity'
				},
				securities = {[2] = 'error', [1] = 'warning'}
			},
			fish = {
				command = "fish",
				args = {"-n", "%file"},
				isStdout = false,
				isStderr = true,
				sourceName = 'fish',
				formatLines = 1,
				formatPattern = {
					"^.*\\(line (\\d+)\\): (.*)$",
					{ line = 1, message = 2 }
				},
				securities = { undefined = "warning" },
			},
			['golangci-lint'] = {
				command = "golangci-lint",
				rootPatterns = { '.git', 'go.mod' },
				debounce = 100,
				args = { 'run', '--out-format', 'json' },
				sourceName = "golangci-lint",
				parseJson = {
					sourceName = 'Pos.Filename',
					sourceNameFilter = true,
					errorsRoot = 'Issues',
					line = 'Pos.Line',
					column = 'Pos.Column',
					message = '${Text} [${FromLinter}]',
				},
				securities = { undefined = "info" },
			},
			revive = {
				command = "revive",
				rootPatterns = { ".git", "go.mod" },
				debounce = 100,
				args = { "%file" },
				sourceName = "revive",
				formatPattern = {
					"^[^:]+:(\\d+):(\\d+):\\s+(.*)$",
					{ line = 1, column = 2, message = {3} }
				},
				securities = { undefined = "info" }
			},
			hadolint = {
				command = "hadolint",
				sourceName = "hadolint",
				args = { "-f", "json", "-" },
				rootPatterns = {'.hadolint.yaml'},
				parseJson = {
					line = "line",
					column = "column",
					security = "level",
					message = "${message} [${code}]",
				},
				securities = {
					error = "error",
					warning = "warning",
					info = "info",
					style = "hint",
				}
			},
			languagetool = {
				command = 'languagetool',
				debounce = 200,
				args = {'-'},
				offsetLine = 0,
				offsetColumn = 0,
				sourceName = 'languagetool',
				formatLines = 2,
				formatPattern = {
					'^\\d+?\\.\\)\\s+Line\\s+(\\d+),\\s+column\\s+(\\d+),\\s+([^\\n]+)\nMessage:\\s+(.*)(\\r|\\n)*$',
					{ line = 1, column = 2, message = {4, 3} }
				},
				securities = { undefined = "hint" },
			},
			markdownlint = {
				command = 'markdownlint',
				rootPatterns = {'.git'},
				isStderr = true,
				debounce = 100,
				args = {'--stdin'},
				offsetLine = 0,
				offsetColumn = 0,
				sourceName = 'markdownlint',
				formatLines = 1,
				formatPattern = {
					'^.*?:\\s?(\\d+)(:(\\d+)?)?\\s(MD\\d{3}\\/[A-Za-z0-9-/]+)\\s(.*)$',
					{line = 1, column = 3, message = {4}},
				},
				securities = { undefined = "hint" },
			},
			vint = {
				command = "vint",
				debounce = 100,
				args = { "--enable-neovim", "-" },
				offsetLine = 0,
				offsetColumn = 0,
				sourceName = "vint",
				formatLines = 1,
				formatPattern = {
					'[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$',
					{ line = 1, column = 2, message = 3 }
				}
			},
			['write-good'] = {
				command = "write-good",
				debounce = 100,
				args = { "--text=%text" },
				offsetLine = 0,
				offsetColumn = 1,
				sourceName = "write-good",
				formatLines = 1,
				formatPattern = {
					"(.*)\\s+on\\s+line\\s+(\\d+)\\s+at\\s+column\\s+(\\d+)\\s*$",
					{ line = 2, column = 3, message = 1 }
				},
				securities = { undefined = "hint" },
			},
		},
		filetypes = {
			-- go = 'revive',
			dockerfile = 'hadolint',
			javascript = 'eslint',
			javascriptreact = 'eslint',
			typescript = 'eslint',
			typescriptreact = 'eslint',
			markdown = {'markdownlint'},
			-- markdown = {'markdownlint', 'write-good', 'languagetool'},
			scss = 'scsslint',
			sh = 'shellcheck',
			vim = 'vint',
		},
		formatters = {
			prettierEslint = {command = 'prettier-eslint', args = {'--stdin'}, rootPatterns = {'.git'}},
			eslint = {command = 'eslint', args = {'--stdin', '--fix'}, rootPatterns = {'.git'}},
			prettier = {command = 'prettier', args = {'--stdin-filepath', '%file'}},
			luaformat = {command = 'lua-format', args = {'%file', '-i'}, doesWriteToFile = true},
		},
		formatFiletypes = {
			javascript = 'eslint',
			javascriptreact = 'eslint',
			json = 'prettier',
			typescript = 'eslint',
			typescriptreact = 'eslint',
			markdown = 'prettier',
			scss = 'prettier',
			css = 'prettier',
			html = 'prettier',
			lua = 'luaformat',
			yaml = 'prettier',
			vue = 'prettier',
		},
	}
}

return {
	config = function(_) return config end,
}

-- vim: set ts=2 sw=2 tw=80 noet :
