-- Harper: grammar and prose checker LSP for Markdown (after/lsp/harper_ls.lua)
require('rafi.util.lang').add({
	servers = { harper_ls = true },
	tools = { 'harper-ls' },
})
