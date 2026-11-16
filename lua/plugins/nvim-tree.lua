return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
		{ "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal current file in explorer" },
	},
	config = function()
		vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { fg = "#ffb86c", bold = true })

		local function pick_file_window()
			local tree_win = vim.api.nvim_get_current_win()
			local tree_col = vim.fn.win_screenpos(tree_win)[2]
			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local buf = vim.api.nvim_win_get_buf(win)
				if
					vim.api.nvim_win_get_config(win).relative == ""
					and vim.bo[buf].filetype ~= "NvimTree"
					and vim.bo[buf].buftype == ""
					and vim.fn.win_screenpos(win)[2] > tree_col
				then
					return win
				end
			end
			vim.cmd("belowright vsplit")
			vim.api.nvim_win_set_width(tree_win, math.floor(vim.o.columns * 0.2))
			return vim.api.nvim_get_current_win()
		end

		require("nvim-tree").setup({
			update_focused_file = {
				enable = true,
				update_root = false,
			},
			git = {
				enable = true,
			},
			renderer = {
				highlight_git = "name",
				highlight_opened_files = "name",
				icons = {
					git_placement = "before",
				},
			},
			actions = {
				open_file = {
					window_picker = {
						picker = pick_file_window,
					},
				},
			},
			view = {
				width = function()
					return math.floor(vim.o.columns * 0.2)
				end,
			},
			filters = {
				dotfiles = false,
			},
		})
	end,
}
