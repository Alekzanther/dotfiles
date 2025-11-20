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
	-- CopilotChat: Chat with GitHub Copilot in Neovim
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		-- build = "make tiktoken", -- Requires 'make', optional for token counting
		opts = {
			model = "claude-sonnet-4",
			window = {
				layout = "vertical",
				width = 0.4,
			},
		},
		keys = {
			-- Chat commands
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat: Toggle chat window" },
			{ "<leader>cr", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat: Reset chat" },
			-- Code actions
			{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "CopilotChat: Explain code" },
			{ "<leader>ct", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "CopilotChat: Generate tests" },
			{ "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "CopilotChat: Fix code" },
			{ "<leader>co", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "CopilotChat: Optimize code" },
			{ "<leader>cd", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "CopilotChat: Generate docs" },
			{ "<leader>cv", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "CopilotChat: Review code" },
			-- Quick chat with selection
			{
				"<leader>cq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				desc = "CopilotChat: Quick chat",
			},
		},
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
