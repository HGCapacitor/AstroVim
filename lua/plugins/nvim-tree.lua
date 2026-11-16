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
			view = {
				width = 35,
			},
			filters = {
				dotfiles = false,
			},
		})
	end,
}
