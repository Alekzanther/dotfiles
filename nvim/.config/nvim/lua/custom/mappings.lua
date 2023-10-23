---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>m"] = { ":lua require('harpoon.mark').add_file() <CR>", "Harpoon: add file", opts = { nowait = true } },
    ["<leader>h"] = { ":lua require('harpoon.ui').toggle_quick_menu() <CR>", "Harpoon: toggle quick list", opts = { nowait = true } },
    ["<leader>j"] = { ":lua require('harpoon.ui').nav_file(1) <CR>", "harpoon: item 1", opts = { nowait = true } },
    ["<leader>k"] = { ":lua require('harpoon.ui').nav_file(2) <CR>", "harpoon: item 2", opts = { nowait = true } },
    ["<leader>dd"] = { ":lua require('trouble').toggle() <CR>", "Toggle Trouble", opts = { nowait = true } },
    ["<leader>dw"] = { ":lua require('trouble').toggle('workspace_diagnostics') <CR>", "Toggle Workspace Trouble", opts = { nowait = true } },
    ["<leader>df"] = { ":lua require('trouble').toggle('document_diagnostics') <CR>", "Toggle File Trouble", opts = { nowait = true } },
    ["<leader>dq"] = { ":lua require('trouble').toggle('quickfix') <CR>", "QuickfixList Trouble", opts = { nowait = true } },
    ["<leader>s"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace inner word", opts = { nowait = true } },
    ["<C-p>"] = { 'copilot#Accept("<CR>")', "Copilot accept", opts = { expr = true, silent = true, replace_keycodes = false } },
  },
  i = {
    ["<C-p>"] = { 'copilot#Accept("<CR>")', "Copilot accept", opts = { expr = true, silent = true, replace_keycodes = false} },
  }
}

-- more keybinds!
return M
