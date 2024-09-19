return {
  "garymjr/nvim-snippets",
  opts = {
    search_paths = {
      vim.fn.stdpath("config") .. "/snippets",
      vim.fn.stdpath("config") .. "/nvim/snippets",
    },
  },
}
