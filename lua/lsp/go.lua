-- gopls
--

local config = {
	settings = {
		gopls = {
			staticcheck = true,
			gofumpt = true,
			linksInHover = false,
			analyses = {
				fillreturns = true,
				nonewvars = true,
				undeclaredname = true,
				unusedparams = false,
				ST1000 = false,
				ST1005 = false,
			},
		}
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
	}
}

return {
	config = function(_) return config end,
}
