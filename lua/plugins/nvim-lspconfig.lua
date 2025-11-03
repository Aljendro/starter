return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          -- Add or change a keymap
          { "gh", vim.diagnostic.open_float, desc = "Hover" },
        },
      },
    },
  },
}
