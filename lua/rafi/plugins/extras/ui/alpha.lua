return {

	{ 'nvimdev/dashboard-nvim', optional = true, enabled = false },
	{ 'echasnovski/mini.starter', optional = true, enabled = false },
	{
		'folke/persistence.nvim',
		opts = { autoload = false },
	},

	-- Fast and fully programmable greeter dashboard
	{
		'goolord/alpha-nvim',
		event = 'VimEnter',
		enabled = true,
		init = false,
		opts = function()
			local dashboard = require('alpha.themes.dashboard')
			local theta = require('alpha.themes.theta')
			local cdir = vim.fn.getcwd()
			-- stylua: ignore
			dashboard.section.buttons.val = {
				{
					type = 'group',
					val = {
						{
							type = 'text',
							val = 'Recent files',
							opts = {
								hl = 'SpecialComment',
								shrink_margin = false,
								position = 'center',
							},
						},
						{ type = 'padding', val = 1 },
						{
							type = 'group',
							val = function()
								return { theta.mru(0, cdir, 5) }
							end,
							opts = { shrink_margin = false },
						},
					},
				},
				{ type = 'padding', val = 2 },

				{ type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
				{ type = 'padding', val = 1 },
				dashboard.button('f', ' ' .. ' Find file',       LazyVim.pick()),
				dashboard.button('n', ' ' .. ' New file',        [[<cmd> ene <BAR> startinsert <CR>]]),
				dashboard.button('r', ' ' .. ' Recent files',    LazyVim.pick('oldfiles')),
				dashboard.button('g', ' ' .. ' Find text',       LazyVim.pick('live_grep')),
				{ type = 'text', val = '-------', opts = { hl = 'Comment', position = 'center' } },
				dashboard.button('c', ' ' .. ' Config',          LazyVim.pick.config_files()),
				dashboard.button('s', ' ' .. ' Restore Session', [[<cmd> lua require('persistence').load() <CR>]]),
				dashboard.button('u', ' ' .. ' Update plugins' , '<cmd> Lazy sync <CR>'),
				dashboard.button('x', ' ' .. ' Lazy Extras',     '<cmd> LazyExtras <CR>'),
				dashboard.button('l', '󰒲 ' .. ' Lazy',            '<cmd> Lazy <CR>'),
				dashboard.button('q', ' ' .. ' Quit',            '<cmd> qa <CR>'),
				{ type = 'padding', val = 1 },
			}
			for _, button in ipairs(dashboard.section.buttons.val) do
				if button.on_press then
					button.opts.hl = 'AlphaButtons'
					button.opts.hl_shortcut = 'AlphaShortcut'
				end
			end
			dashboard.section.header.opts.hl = 'AlphaHeader'
			dashboard.section.buttons.opts.hl = 'AlphaButtons'
			dashboard.section.buttons.opts.spacing = 0
			dashboard.section.footer.opts.hl = 'AlphaFooter'
			return dashboard
		end,

		-- Credits: https://github.com/LazyVim/LazyVim
		config = function(_, dashboard)
			-- close Lazy and re-open when the dashboard is ready
			if vim.o.filetype == 'lazy' then
				vim.cmd.close()
				vim.api.nvim_create_autocmd('User', {
					once = true,
					pattern = 'AlphaReady',
					callback = function()
						require('lazy').show()
					end,
				})
			end

			require('alpha').setup(dashboard.opts)

			vim.api.nvim_create_autocmd('User', {
				once = true,
				pattern = 'LazyVimStarted',
				callback = function()
					local stats = require('lazy').stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = '⚡ Neovim loaded '
						.. stats.loaded
						.. '/'
						.. stats.count
						.. ' plugins in '
						.. ms
						.. 'ms'
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},
}
