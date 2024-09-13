-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local customVim = vim.api.nvim_create_augroup("customVim", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = customVim,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end,
})
