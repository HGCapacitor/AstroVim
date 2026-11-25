return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				separator_style = "slant",
				show_buffer_close_button = true,
				show_close_icon = true,
				color_icons = true,
				custom_filter = function(buf_number, buf_numbers)
					-- Only show editor buffers in tabline, hide terminal and NvimTree
					local filetype = vim.bo[buf_number].filetype
					if filetype == "terminal" or filetype == "NvimTree" then
						return false
					end
					return true
				end,
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "left",
						separator = true,
					},
				},
			},
		})

		-- Smart buffer cycle that only affects current window
		local function cycle_editor_buffers(direction)
			local current_ft = vim.bo.filetype
			-- Only cycle if in editor window (not terminal or NvimTree)
			if current_ft == "terminal" or current_ft == "NvimTree" then
				return
			end

			local listed_bufs = vim.fn.getbufinfo({ buflisted = 1 })
			local editor_bufs = {}

			-- Collect only editor buffers (skip terminal and NvimTree)
			for _, buf_info in ipairs(listed_bufs) do
				local filetype = vim.bo[buf_info.bufnr].filetype
				if filetype ~= "terminal" and filetype ~= "NvimTree" then
					table.insert(editor_bufs, buf_info.bufnr)
				end
			end

			if #editor_bufs == 0 then
				return
			end

			local current_buf = vim.api.nvim_get_current_buf()
			local current_idx = 1

			-- Find current buffer in editor list
			for i, bufnr in ipairs(editor_bufs) do
				if bufnr == current_buf then
					current_idx = i
					break
				end
			end

			-- Calculate next index
			local next_idx
			if direction == "next" then
				next_idx = current_idx % #editor_bufs + 1
			else
				next_idx = (current_idx - 2) % #editor_bufs + 1
			end

			vim.api.nvim_set_current_buf(editor_bufs[next_idx])
		end

		-- Smart buffer close that only affects current window
		local function close_current_buffer()
			local current_ft = vim.bo.filetype
			-- Only close if in editor window
			if current_ft == "terminal" or current_ft == "NvimTree" then
				return
			end

			local bufnr = vim.api.nvim_get_current_buf()
			local listed_bufs = vim.fn.getbufinfo({ buflisted = 1 })
			local editor_bufs = {}

			-- Count only editor buffers
			for _, buf_info in ipairs(listed_bufs) do
				local filetype = vim.bo[buf_info.bufnr].filetype
				if filetype ~= "terminal" and filetype ~= "NvimTree" then
					table.insert(editor_bufs, buf_info.bufnr)
				end
			end

			if #editor_bufs > 1 then
				vim.cmd("bprevious")
				vim.cmd("bdelete " .. bufnr)
			else
				vim.cmd("enew")
				vim.cmd("bdelete " .. bufnr)
			end
		end

		-- Keymaps to switch buffers (window-aware)
		vim.keymap.set("n", "<Tab>", function()
			cycle_editor_buffers("next")
		end, { noremap = true, desc = "Next buffer in editor" })

		vim.keymap.set("n", "<S-Tab>", function()
			cycle_editor_buffers("prev")
		end, { noremap = true, desc = "Previous buffer in editor" })

		vim.keymap.set("n", "<leader>c", close_current_buffer, { noremap = true, desc = "Close buffer" })
	end,
}
