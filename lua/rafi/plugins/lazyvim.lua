return {

	-- LazyVim framework.
	{
		'LazyVim/LazyVim',
		version = '*',
		priority = 10000,
		lazy = false,
		cond = true,
		config = function(_, opts)
			-- Load lua/rafi/config/*
			require('rafi.config').setup()

			-- Setup lazyvim, but don't load any lazyvim/config/* files.
			package.loaded['lazyvim.config.options'] = true
			require('lazyvim.config').setup(vim.tbl_deep_extend('force', opts, {
				defaults = { autocmds = false, keymaps = false },
				news = { lazyvim = false },
			}))
		end,
		opts = {
			-- String like `habamax` or a function that will load the colorscheme.
			-- Disabled by default to allow theme-loader.nvim to manage the colorscheme.
			---@type string|fun()
			colorscheme = function() end,

			-- icons used by other plugins
			-- stylua: ignore
			icons = {
				misc = {
					dots = '󰇘',
					git = ' ',
				},
				ft = {
					octo = '',
				},
				dap = {
					Stopped             = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
					Breakpoint          = ' ',
					BreakpointCondition = ' ',
					BreakpointRejected  = { ' ', 'DiagnosticError' },
					LogPoint            = '.>',
				},
				diagnostics = {
					-- Error = '', --   ✘
					-- Warn  = '', --  󰀪 󰳤 󱗓 
					-- Info  = '', --    󰋼 󰋽 ⁱ
					Error = '✘', --   ✘
					Warn  = '󰀪', --  󰀪 ▲󰳤 󱗓 
					Info  = 'ⁱ', --    󰋼 󰋽 ⚑ⁱ
					Hint  = '', --  󰌶 
				},
				status = {
					git = {
						added    = '₊', --  ₊
						modified = '∗', --  ∗
						removed  = '₋', --  ₋
					},
					diagnostics = {
						error = ' ',
						warn  = ' ',
						info  = ' ',
						hint  = ' ',
					},
					filename = {
						modified = '+',
						readonly = '🔒',
						zoomed   = '🔎',
					},
				},
				-- Default completion kind symbols.
				kinds = {
					Array         = '󰅪 ', --  󰅪 󰅨 󱃶
					Boolean       = '󰨙 ', --  ◩ 󰔡 󱃙 󰟡 󰨙
					Class         = '󰌗 ', --  󰌗 󰠱 𝓒
					Codeium       = '󰘦 ', -- 󰘦
					Collapsed     = ' ', -- 
					Color         = '󰏘 ', -- 󰸌 󰏘
					Constant      = '󰏿 ', --   󰏿
					Constructor   = ' ', --  󰆧   
					Control       = ' ', -- 
					Copilot       = ' ', --  
					Enum          = '󰕘 ', --  󰕘  ℰ 
					EnumMember    = ' ', --  
					Event         = ' ', --  
					Field         = ' ', --  󰄶  󰆨  󰀻 󰃒 
					File          = ' ', --    󰈔 󰈙
					Folder        = ' ', --   󰉋
					Function      = '󰊕 ', --  󰊕 
					Interface     = ' ', --    
					Key           = ' ', -- 
					Keyword       = ' ', --   󰌋 
					Method        = '󰊕 ', --  󰆧 󰊕 ƒ
					Module        = ' ', --   󰅩 󰆧 󰏗
					Namespace     = '󰦮 ', -- 󰦮   󰅩
					Null          = ' ', --  󰟢
					Number        = '󰎠 ', --  󰎠 
					Object        = ' ', --   󰅩
					Operator      = '󰃬 ', --  󰃬 󰆕 +
					Package       = ' ', --   󰏖 󰏗 󰆧
					Property      = ' ', --   󰜢   󰖷
					Reference     = '󰈝 ', --  󰈝 󰈇
					Snippet       = ' ', --  󰘌 ⮡   
					String        = ' ', --   󰅳
					Struct        = '󰆼 ', -- 󰆼   𝓢 󰙅 󱏒
					Supermaven    = ' ',
					TabNine       = '󰏚 ', -- 󰏚
					Text          = ' ', --   󰉿 𝓐
					TypeParameter = ' ', --  󰊄 𝙏
					Unit          = ' ', --   󰑭 
					Value         = ' ', --   󰀬 󰎠
					Variable      = ' ', --   󰀫 
				},
			},
		},
	},
}
