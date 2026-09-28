-- Calendar application with Google Calendar/Tasks sync (calendar.vim)

vim.g.calendar_google_calendar = 1
vim.g.calendar_google_task = 1
vim.g.calendar_cache_directory = vim.fn.stdpath('state') .. '/calendar'

-- Stub until the plugin's own plugin/calendar.vim redefines it.
require('rafi.pack').command('Calendar', function()
	vim.pack.add({ 'https://github.com/itchyny/calendar.vim' })
end)
