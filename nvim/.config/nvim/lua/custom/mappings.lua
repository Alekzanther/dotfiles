---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>m"] = { ":lua require('harpoon.mark').add_file() <CR>", "Harpoon: add file", opts = { nowait = true } },
    ["<leader>h"] = { ":lua require('harpoon.ui').toggle_quick_menu() <CR>", "Harpoon: toggle quick list", opts = { nowait = true } },
    ["<leader>j"] = { ":lua require('harpoon.ui').nav_file(1) <CR>", "harpoon: item 1", opts = { nowait = true } },
    ["<leader>k"] = { ":lua require('harpoon.ui').nav_file(2) <CR>", "harpoon: item 2", opts = { nowait = true } },
    ["<leader>l"] = { ":lua require('harpoon.ui').nav_file(3) <CR>", "Harpoon: item 3", opts = { nowait = true } },
    ["<C-p>"] = { 'copilot#Accept("<CR>")', "Copilot accept", opts = { expr = true, silent = true, replace_keycodes = false } },
  },
  i = {
    ["<C-p>"] = { 'copilot#Accept("<CR>")', "Copilot accept", opts = { expr = true, silent = true, replace_keycodes = false} },
  }
}

-- more keybinds!
return M
