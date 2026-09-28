-- YAML: yamlls with SchemaStore and Kubernetes schemas (after/lsp/yamlls.lua)
-- SchemaStore.nvim is added with lspconfig, jsonls needs it too.
require('rafi.util.lang').add({ servers = { yamlls = true } })
