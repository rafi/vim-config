-- Browse synonyms and definitions (snacks picker)

-- editor.telescope adds the same plugin with the telescope picker and maps
-- the same key, so this file steps aside.
if require('rafi.config').enabled('editor.telescope') then
	return
end

-- dictionaryapi.com, the plugin's default, needs a key. Without one, use
-- the free API.
if vim.g.thesaurus == nil and not vim.env.DICTIONARY_API_KEY then
	vim.g.thesaurus = { provider = 'freedictionaryapi' }
end

-- Its plugin/ only defines :Thesaurus and the <Plug> map. The picker is
-- snacks, picked by its 'auto' default.
require('rafi.pack').dev(
	'telescope-thesaurus.nvim',
	'https://github.com/rafi/telescope-thesaurus.nvim'
)

vim.keymap.set(
	'n',
	'<localleader>k',
	'<Plug>(ThesaurusLookup)',
	{ desc = 'Thesaurus' }
)
