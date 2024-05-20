-- Source: https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/themes/auto.lua
-- Copyright (c) 2020-2021 shadmansaleh
-- MIT license, see LICENSE for more details.

---@class rafi.util.color
local M = {}

-- Turns #rrggbb -> { red, green, blue }
function M.rgb_str2num(rgb_color_str)
	if rgb_color_str == nil then
		return {}
	end
	if rgb_color_str:find('#') == 1 then
		rgb_color_str = rgb_color_str:sub(2, #rgb_color_str)
	end
	local red = tonumber(rgb_color_str:sub(1, 2), 16)
	local green = tonumber(rgb_color_str:sub(3, 4), 16)
	local blue = tonumber(rgb_color_str:sub(5, 6), 16)
	return { red = red, green = green, blue = blue }
end

-- Turns { red, green, blue } -> #rrggbb
function M.rgb_num2str(rgb_color_num)
	local rgb_color_str = string.format(
		'#%02x%02x%02x',
		rgb_color_num.red,
		rgb_color_num.green,
		rgb_color_num.blue
	)
	return rgb_color_str
end

-- Returns brightness level of color in range 0 to 1
-- arbitrary value it's basically an weighted average
function M.get_color_brightness(rgb_color)
	local color = M.rgb_str2num(rgb_color)
	local brightness = (color.red * 2 + color.green * 3 + color.blue) / 6
	return brightness / 256
end

-- returns average of colors in range 0 to 1
-- used to determine contrast level
function M.get_color_avg(rgb_color)
	local color = M.rgb_str2num(rgb_color)
	return (color.red + color.green + color.blue) / 3 / 256
end

-- Clamps the val between left and right
function M.clamp(val, left, right)
	if val > right then
		return right
	end
	if val < left then
		return left
	end
	return val
end

-- Changes brightness of rgb_color by percentage
function M.brightness_modifier(rgb_color, parcentage)
	if rgb_color == nil then
		return {}
	end
	local color = M.rgb_str2num(rgb_color)
	color.red = M.clamp(color.red + (color.red * parcentage / 100), 0, 255)
	color.green = M.clamp(color.green + (color.green * parcentage / 100), 0, 255)
	color.blue = M.clamp(color.blue + (color.blue * parcentage / 100), 0, 255)
	return M.rgb_num2str(color)
end

-- Changes contrast of rgb_color by amount
function M.contrast_modifier(rgb_color, amount)
	local color = M.rgb_str2num(rgb_color)
	color.red = M.clamp(color.red + amount, 0, 255)
	color.green = M.clamp(color.green + amount, 0, 255)
	color.blue = M.clamp(color.blue + amount, 0, 255)
	return M.rgb_num2str(color)
end

-- Changes brightness of foreground color to achieve contrast
-- without changing the color
function M.apply_contrast(highlight, threshold)
	local hightlight_bg_avg = M.get_color_avg(highlight.bg)
	local contrast_threshold_config = M.clamp(threshold, 0, 0.5)
	local contranst_change_step = 5
	if hightlight_bg_avg > 0.5 then
		contranst_change_step = -contranst_change_step
	end

	-- Don't waste too much time here max 25 iteration should be more than enough
	local iteration_count = 1
	while
		math.abs(M.get_color_avg(highlight.fg) - hightlight_bg_avg)
			< contrast_threshold_config
		and iteration_count < 25
	do
		highlight.fg = M.contrast_modifier(highlight.fg, contranst_change_step)
		iteration_count = iteration_count + 1
	end
end

-- Change brightness of colors
-- Darken if light theme (or) Lighten if dark theme
function M.apply_brightness(color, base_color, brightness_modifier_parameter)
	if base_color ~= nil then
		if M.get_color_brightness(base_color) > 0.5 then
			brightness_modifier_parameter = -brightness_modifier_parameter
		end
		return M.brightness_modifier(color, brightness_modifier_parameter)
	end
end

return M
