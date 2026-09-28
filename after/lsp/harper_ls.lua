-- Harper grammar/prose checker, restricted to Markdown documents only
---@type vim.lsp.Config
return {
	filetypes = { 'markdown', 'markdown.mdx' },
	settings = {
		['harper-ls'] = {
			-- userDictPath = '~/.config/harper-ls/dict.txt',
			linters = {
				sentence_capitalization = false,
				spell_check = false,
				-- spelled_numbers = false,
				-- an_a = true,
				-- unclosed_quotes = true,
				-- wrong_quotes = false,
				-- long_sentences = true,
				-- repeated_words = true,
				-- spaces = true,
				-- matcher = true,
				-- correct_number_suffix = true,
				-- number_suffix_capitalization = true,
				-- multiple_sequential_pronouns = true,
				-- linking_verbs = false,
				-- avoid_curses = true,
				-- terminating_conjunctions = true
			},
		},
	},
}
