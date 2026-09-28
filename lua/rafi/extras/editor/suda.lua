-- Read or write files with sudo (:SudaRead, :SudaWrite)
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/lambdalisue/vim-suda' })
end)
