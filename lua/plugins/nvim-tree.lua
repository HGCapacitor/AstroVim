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

		local function on_attach(bufnr)
			local api = require("nvim-tree.api")

			vim.keymap.set("n", "<CR>", function()
				local node = api.tree.get_node_under_cursor()
				-- Only customize file opening, let directories expand normally
				if node and node.type == "file" then
					local tree_win = vim.api.nvim_get_current_win()
					local tree_col = vim.fn.win_screenpos(tree_win)[2]
					local target_win = nil

					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
						local buf = vim.api.nvim_win_get_buf(win)
						if
							vim.api.nvim_win_get_config(win).relative == ""
							and vim.bo[buf].filetype ~= "NvimTree"
							and vim.bo[buf].buftype == ""
							and vim.fn.win_screenpos(win)[2] > tree_col
						then
							target_win = win
							break
						end
					end

					if target_win then
						vim.api.nvim_set_current_win(target_win)
						vim.cmd("edit " .. node.absolute_path)
						-- Only restore focus if tree window still exists
						if vim.api.nvim_win_is_valid(tree_win) then
							vim.api.nvim_set_current_win(tree_win)
						end
					else
						api.node.open.edit()
					end
				else
					-- Default behavior for directories (expand/collapse)
					api.node.open.edit()
				end
			end, { noremap = true, buffer = bufnr })
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
					quit_on_open = false,
					window_picker = {
						enable = false,
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
			on_attach = on_attach,
		})

		-- Custom keymap to open files as tabs
		vim.keymap.set("n", "<CR>", function()
			local api = require("nvim-tree.api")
			local node = api.tree.get_node_under_cursor()
			-- Only customize file opening, let directories expand normally
			if node and node.type == "file" then
				local tree_win = vim.api.nvim_get_current_win()
				local tree_col = vim.fn.win_screenpos(tree_win)[2]
				local target_win = nil

				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
					local buf = vim.api.nvim_win_get_buf(win)
					if
						vim.api.nvim_win_get_config(win).relative == ""
						and vim.bo[buf].filetype ~= "NvimTree"
						and vim.bo[buf].buftype == ""
						and vim.fn.win_screenpos(win)[2] > tree_col
					then
						target_win = win
						break
					end
				end

				if target_win then
					vim.api.nvim_set_current_win(target_win)
					vim.cmd("edit " .. node.absolute_path)
					-- Only restore focus if tree window still exists
					if vim.api.nvim_win_is_valid(tree_win) then
						vim.api.nvim_set_current_win(tree_win)
					end
				else
					api.node.open.edit()
				end
			else
				-- Default behavior for directories (expand/collapse)
				api.node.open.edit()
			end
		end, { noremap = true, buffer = true })
	end,
}
