-- Vue: vue_ls (hybrid mode) plus vtsls with @vue/typescript-plugin
-- The vtsls plugin and `vue` filetype are set in after/lsp/vtsls.lua. Enable
-- lang.typescript too for vtsls keymaps.
require('rafi.util.lang').add({
	servers = {
		vue_ls = true,
		vtsls = true,
	},
	tools = { 'vue-language-server' },
})
