return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.diagnostics.virtual_text = false
    opts.inlay_hints.enabled = false

    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    keys[#keys + 1] = { "gh", "<cmd>lua vim.diagnostic.open_float()<cr>" }
  end,
}
