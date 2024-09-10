-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map({ "n", "x" }, "<Up>", function()
  local neoscroll = require("neoscroll")
  neoscroll.ctrl_u({ duration = 200 })
end)
map({ "n", "x" }, "<Down>", function()
  local neoscroll = require("neoscroll")
  neoscroll.ctrl_d({ duration = 200 })
end)
map({ "n", "x" }, "<C-y>", function()
  local neoscroll = require("neoscroll")
  neoscroll.scroll(-0.1, { move_cursor = false, duration = 50 })
end)
map({ "n", "x" }, "<C-e>", function()
  local neoscroll = require("neoscroll")
  neoscroll.scroll(0.1, { move_cursor = false, duration = 50 })
end)
