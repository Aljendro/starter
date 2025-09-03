-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.node_host_prog = vim.fn.expand("~/.nvm/versions/node/v24.5.0/bin/neovim-node-host")
vim.g.python3_host_prog = vim.fn.expand("/usr/bin/python3")

vim.opt.wrapscan = false

vim.filetype.add({
  pattern = {
    [".*.puml"] = "markdown",
  },
})
