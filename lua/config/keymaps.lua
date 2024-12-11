-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Faster shifting
map("n", "<Left>", "zH", { desc = "Shift Left", silent = true })
map("n", "<Right>", "zL", { desc = "Shift Right", silent = true })

-- Smooth Scroll
map({ "n", "x" }, "<C-k>", function()
  local neoscroll = require("neoscroll")
  neoscroll.ctrl_u({ duration = 200 })
end, { silent = true })
map({ "n", "x" }, "<C-j>", function()
  local neoscroll = require("neoscroll")
  neoscroll.ctrl_d({ duration = 200 })
end, { silent = true })
map({ "n", "x" }, "<Up>", function()
  local neoscroll = require("neoscroll")
  neoscroll.scroll(-0.1, { move_cursor = false, duration = 50 })
end, { silent = true })
map({ "n", "x" }, "<Down>", function()
  local neoscroll = require("neoscroll")
  neoscroll.scroll(0.1, { move_cursor = false, duration = 50 })
end, { silent = true })

------------------------------------------------------------------------------------------------------------------------
-- Abbreviations
------------------------------------------------------------------------------------------------------------------------

-- Code signature
vim.cmd("inoreabbrev @@ Alejandro Alvarado <alejandro.alvarado0650144@gmail.com>")
-- Quick Grep and Location/Quickfix List opens
vim.cmd(
  "cnoreabbrev <expr> grep v:lua.CommandAbbreviation('grep', \"silent grep  \\| copen<left><left><left><left><left><left><left><left>\")"
)
vim.cmd(
  "cnoreabbrev <expr> lgrep v:lua.CommandAbbreviation('lgrep', \"silent lgrep  <C-r>=expand('%:p')<cr> \\| lopen<C-b><right><right><right><right><right><right><right><right><right><right><right><right><right>\")"
)
vim.cmd("cnoreabbrev _ml -U")
vim.cmd("cnoreabbrev _mla -U --multiline-dotall")
vim.cmd("cnoreabbrev _r10 <left>.{0,10}?")
vim.cmd("cnoreabbrev _r20 <left>.{0,20}?")
vim.cmd("cnoreabbrev _r50 <left>.{0,50}?")
vim.cmd("cnoreabbrev _r100 <left>.{0,100}?")
-- Non Greedy *
vim.cmd("cnoreabbrev *? <left>\\{-}<C-r>=v:lua.EatChar('\\s')<cr>")
-- Always open help in new tab
vim.cmd("cnoreabbrev <expr> tah v:lua.CommandAbbreviation('tah', 'tab help') . ' '")
-- Change filetype
vim.cmd("cnoreabbrev <expr> ft v:lua.CommandAbbreviation('ft', 'set ft=')")
-- Diff files in window
vim.cmd("cnoreabbrev <expr> wdt v:lua.CommandAbbreviation('wdt', 'windo diffthis')")

------------------------------------------------------------------------------------------------------------------------
-- Options
------------------------------------------------------------------------------------------------------------------------

map("n", "<leader>uv", "<cmd>DiagnosticsToggleVirtualText<cr>", { desc = "Toggle Virtual Text" })
map("n", "<leader>uW", ":set wrapscan!<cr>:set wrapscan?<cr>", { desc = "Toggle Wrap Scan" })

------------------------------------------------------------------------------------------------------------------------
-- Splits/Windows
------------------------------------------------------------------------------------------------------------------------

-- Tab split
map("n", "st", ":tab split<cr>", { desc = "Split Tab", silent = true })

-- Vertical split
map("n", "sv", "<C-w>v", { desc = "Split Vertical", silent = true })

-- Horizontal split
map("n", "ss", "<C-w>s", { desc = "Split Horizontal", silent = true })

-- Close split
map("n", "sc", "<C-w>c", { desc = "Close Split", silent = true })

-- Move between windows easily
map("n", "sk", "<C-w><C-k>", { desc = "Go to Upper Window", silent = true })
map("n", "sj", "<C-w><C-j>", { desc = "Go to Lower Window", silent = true })
map("n", "sl", "<C-w><C-l>", { desc = "Go to Left Window", silent = true })
map("n", "sh", "<C-w><C-h>", { desc = "Go to Right Window", silent = true })

------------------------------------------------------------------------------------------------------------------------
-- Buffers
------------------------------------------------------------------------------------------------------------------------

-- Move between buffers easily
map("n", "su", ":bprevious<cr>", { desc = "Prev Buffer", silent = true })
map("n", "si", ":bnext<cr>", { desc = "Next Buffer", silent = true })

-- Quickly delete buffer
map("n", "sd", ":bdelete<cr>", { desc = "Delete Buffer", silent = true })

------------------------------------------------------------------------------------------------------------------------
-- Tabs
------------------------------------------------------------------------------------------------------------------------

-- Move between tabs easily
map("n", "so", "gt", { desc = "Next Tab", silent = true })
map("n", "sy", "gT", { desc = "Prev Tab", silent = true })
-- Move a window into a new tabpage
map("n", "<leader>!", "<C-w>T", { desc = "Move Window to New Tab", silent = true })
-- Move tabs around
map("n", "<leader>tj", ":-1tabm<cr>", { desc = "Move Tab Left", silent = true })
map("n", "<leader>tk", ":+1tabm<cr>", { desc = "Move Tab Right", silent = true })
-- Create a new tab at the end
map("n", "<leader>tn", ":tabnew<cr>:tabmove<cr>", { desc = "Create New Tab", silent = true })
-- Create a new scratch buffer tab at the end
map(
  "n",
  "<leader>tN",
  ":tabnew +setl\\ buftype=nofile<cr>:tabmove<cr>",
  { desc = "Create New Scratch Tab", silent = true }
)
-- Close the tab
map("n", "<leader>tc", ":tabclose<cr>", { desc = "Close Tab", silent = true })

------------------------------------------------------------------------------------------------------------------------
-- Search
------------------------------------------------------------------------------------------------------------------------

-- Visual mode pressing * or # searches for the current selection
map("x", "*", "mi:call v:lua.GetSelectedText()<cr>/<C-R>=@/<cr><cr>`i", { silent = true })
map("x", "#", "mi:call v:lua.GetSelectedText()<cr>?<C-R>=@/<cr><cr>`i", { silent = true })

-- Maintain position when you hit * or #
map("n", "*", ":keepjumps normal! *N<cr>zz", { silent = true })
map("n", "g*", ":keepjumps normal! g*N<cr>zz", { silent = true })
map("n", "#", ":keepjumps normal! #N<cr>zz", { silent = true })
map("n", "g#", ":keepjumps normal! g#N<cr>zz", { silent = true })

-- Center cursor when searching
map("n", "n", "nzzzv", { silent = true })
map("n", "N", "Nzzzv", { silent = true })
