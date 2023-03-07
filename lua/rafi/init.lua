local M = {}

---@param opts? RafiConfig
function M.setup(opts)
	require('rafi.config').setup(opts)
end

return M
