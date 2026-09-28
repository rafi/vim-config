-- TypeScript/JavaScript language server (VSCode's TypeScript extension)
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/typescript/vtsls.lua

-- Whether lang.vue is enabled: vtsls then handles `.vue` script blocks through
-- the `@vue/typescript-plugin` (vue_ls runs in hybrid mode).
local vue = require('rafi.util.lang').servers.vue_ls == true

local mason = vim.fn.stdpath('data') .. '/mason/packages'

local global_plugins = {
	{
		name = 'typescript-svelte-plugin',
		location = mason
			.. '/svelte-language-server/node_modules/typescript-svelte-plugin',
		enableForWorkspaceTypeScriptVersions = true,
	},
}
if vue then
	table.insert(global_plugins, {
		name = '@vue/typescript-plugin',
		location = mason
			.. '/vue-language-server/node_modules/@vue/language-server',
		languages = { 'vue' },
		configNamespace = 'typescript',
		enableForWorkspaceTypeScriptVersions = true,
	})
end

local filetypes = {
	'javascript',
	'javascriptreact',
	'javascript.jsx',
	'typescript',
	'typescriptreact',
	'typescript.tsx',
}
if vue then
	table.insert(filetypes, 'vue')
end

local typescript = {
	updateImportsOnFileMove = { enabled = 'always' },
	suggest = {
		completeFunctionCalls = true,
	},
	inlayHints = {
		enumMemberValues = { enabled = true },
		functionLikeReturnTypes = { enabled = true },
		parameterNames = { enabled = 'literals' },
		parameterTypes = { enabled = true },
		propertyDeclarationTypes = { enabled = true },
		variableTypes = { enabled = false },
	},
}

---@type vim.lsp.Config
return {
	filetypes = filetypes,
	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = {
					enableServerSideFuzzyMatch = true,
				},
			},
			tsserver = { globalPlugins = global_plugins },
		},
		typescript = typescript,
		-- copy typescript settings to javascript
		javascript = vim.deepcopy(typescript),
	},
	commands = {
		['_typescript.moveToFileRefactoring'] = function(command, ctx)
			local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
			---@type string, string, lsp.Range
			local action, uri, range = unpack(command.arguments)

			local function move(newf)
				client:request('workspace/executeCommand', {
					command = command.command,
					arguments = { action, uri, range, newf },
				})
			end

			local fname = vim.uri_to_fname(uri)
			client:request('workspace/executeCommand', {
				command = 'typescript.tsserverRequest',
				arguments = {
					'getMoveToRefactoringFileSuggestions',
					{
						file = fname,
						startLine = range.start.line + 1,
						startOffset = range.start.character + 1,
						endLine = range['end'].line + 1,
						endOffset = range['end'].character + 1,
					},
				},
			}, function(_, result)
				---@type string[]
				local files = result.body.files
				table.insert(files, 1, 'Enter new path...')
				vim.ui.select(files, {
					prompt = 'Select move destination:',
					format_item = function(f)
						return vim.fn.fnamemodify(f, ':~:.')
					end,
				}, function(f)
					if f and f:find('^Enter new path') then
						vim.ui.input({
							prompt = 'Enter move destination:',
							default = vim.fn.fnamemodify(fname, ':h') .. '/',
							completion = 'file',
						}, function(newf)
							return newf and move(newf)
						end)
					elseif f then
						move(f)
					end
				end)
			end)
		end,
	},
}
