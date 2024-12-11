local M = {}

function M.setup()
  local jest_path = vim.fn.exepath("jest")
  vim.api.nvim_set_keymap(
    "n",
    "<leader>ti",
    "<cmd>lua require('neotest').run.run({ jestCommand = 'node --inspect-brk " .. jest_path .. "' })<cr>",
    {}
  )
end

return M
