return {
  "folke/flash.nvim",
  keys = {
    { "s", false, mode = { "n", "x", "o" } },
    { "S", false, mode = { "n", "x", "o" } },
  },
  opts = {
    modes = {
      char = {
        enabled = false,
      },
      search = {
        enabled = false,
      },
    },
  },
}
