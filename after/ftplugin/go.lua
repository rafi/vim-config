-- Go utilities
--

-- Convert a JSON string to a Go struct.
local function json_to_struct(args)
	local range = args.line1 .. ',' .. args.line2
	local fname = vim.api.nvim_buf_get_name(0)
	local cmd = { '!json-to-struct' }
	table.insert(cmd, '-name ' .. vim.fn.fnamemodify(fname, ':t:r'))
	table.insert(cmd, '-pkg ' .. vim.fn.fnamemodify(fname, ':h:t:r'))
	vim.cmd(range .. ' ' .. table.concat(cmd, ' '))
end

vim.api.nvim_buf_create_user_command(0, 'JsonToStruct', json_to_struct,
	{ bar = true, nargs = 0, range = true })
