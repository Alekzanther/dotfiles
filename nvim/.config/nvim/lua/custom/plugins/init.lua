-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	-- Official GitHub Copilot - simplest and most reliable option
	{
		"github/copilot.vim",
		event = "InsertEnter",
	},
	-- nvim-tree: Most popular file tree (8,182+ stars)
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			-- Disable netrw (recommended by nvim-tree)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({
				view = {
					width = 30,
					relativenumber = true,
					number = true,
				},
				renderer = {
					group_empty = true,
					highlight_git = true,
					icons = {
						show = {
							git = true,
							folder = true,
							file = true,
							folder_arrow = true,
						},
					},
				},
				filters = {
					dotfiles = false,
				},
			})

			-- Open nvim-tree on startup
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					require("nvim-tree.api").tree.open()
				end,
			})

			-- Ctrl+N to toggle file tree
			vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle file tree", silent = true })
		end,
	},
}
