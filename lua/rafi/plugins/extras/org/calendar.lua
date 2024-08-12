-- rafi.plugins.extras.org.calendar
--

return {

	-----------------------------------------------------------------------------
	-- Calendar application
	{
		'itchyny/calendar.vim',
		cmd = 'Calendar',
		init = function()
			vim.g.calendar_google_calendar = 1
			vim.g.calendar_google_task = 1
			vim.g.calendar_cache_directory = vim.fn.stdpath('state') .. '/calendar'
		end,
	},
}
