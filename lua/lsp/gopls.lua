-- gopls
--

local config = {
	settings = {
		-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
		gopls = {
			staticcheck = true,
			gofumpt = true,
			linksInHover = true,

			-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
			analyses = {
				fillreturns = true,
				nonewvars = true,
				undeclaredname = true,
				unusedparams = false,
				ST1000 = false,
				ST1005 = false,
			},
		},
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
	},
}

return {
	config = function(_)
		return config
	end,
}
