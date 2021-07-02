-- plugin: todo-comments.nvim
-- see: https://github.com/folke/todo-comments.nvim
-- rafi settings

require('todo-comments').setup{
	signs = false,
	-- keywords = {
	--   FIX = {
	--     icon = " ",
	--     color = "error", -- can be a hex color, or a named color (see below)
	--     alt = { "FIXME", " BUG", "FIXIT", "FIX", "ISSUE" },
	--     -- signs = false, -- configure signs for some keywords individually
	--   },
	--   TODO = { icon = " ", color = "info" },
	--   HACK = { icon = " ", color = "warning" },
	--   WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
	--   PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
	--   NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
	-- },
	-- colors = {
	--   error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
	--   warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
	--   info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
	--   hint = { "LspDiagnosticsDefaultHint", "#10B981" },
	--   default = { "Identifier", "#7C3AED" },
	-- },
}
