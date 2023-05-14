-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-P>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.opt.relativenumber = true
