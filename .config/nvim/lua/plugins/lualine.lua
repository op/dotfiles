-- https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets#using-external-source-for-branch
local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed
		}
	end
end

require('lualine').setup({
	options = {
		component_separators = '',
		section_separators = '',
		icons_enabled = false,
	},
	sections = {
		-- use gitsigns as source
		lualine_b = {
			{ 'b:gitsigns_head' },
			{ 'diff', source = diff_soruce },
		},
		-- show relative path
		lualine_c = { { 'filename', path = 1 } },
		-- disable encoding, fileformat and filetype
		lualine_x = {},
		-- disable progress
		lualine_y = {},
	},
	inactive_sections = {
		-- show relative path
		lualine_c = { { 'filename', path = 1 } },
		-- disable progress
		lualine_y = {},
	},
})
