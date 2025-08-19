return {
  "julienvincent/nvim-paredit",
  dependencies = {
    { "PaterJason/nvim-treesitter-sexp", enabled = false },
  },
  config = function()
    require("nvim-paredit").setup()
  end,
}
