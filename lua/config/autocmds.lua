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

local autosave_timers = {}
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "FocusLost" }, {
  group = customVim,
  pattern = {
    "*.lua",
    "*.py",
    "*.js",
    "*.ts",
    "*.jsx",
    "*.tsx",
    "*.go",
    "*.rs",
    "*.java",
    "*.c",
    "*.cpp",
    "*.h",
    "*.hpp",
    "*.sh",
    "*.bash",
    "*.zsh",
    "*.vim",
    "*.json",
    "*.yaml",
    "*.yml",
    "*.toml",
    "*.xml",
    "*.html",
    "*.css",
    "*.scss",
    "*.md",
    "*.txt",
    "*.conf",
    "*.config",
  },
  callback = function(args)
    local bufnr = args.buf
    if
      vim.bo[bufnr].modified
      and not vim.bo[bufnr].readonly
      and vim.fn.expand("%") ~= ""
      and vim.bo[bufnr].buftype == ""
    then
      if autosave_timers[bufnr] then
        autosave_timers[bufnr]:stop()
      end
      autosave_timers[bufnr] = vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modified then
          vim.api.nvim_buf_call(bufnr, function()
            vim.cmd("silent! write")
          end)
        end
        autosave_timers[bufnr] = nil
      end, 1500)
    end
  end,
})
