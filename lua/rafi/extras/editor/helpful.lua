-- Display vim version numbers in docs (:HelpfulVersion)
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/tweekmonster/helpful.vim' })
end)
