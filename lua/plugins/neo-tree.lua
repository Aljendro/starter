return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
      },
      window = {
        mappings = {
          ["/"] = "",
        },
      },
    },
    window = {
      mappings = {
        ["?"] = "",
        ["s"] = "",
        ["S"] = "",
        ["t"] = "",
        ["g?"] = "show_help",
        ["<C-v>"] = "open_vsplit",
        ["<C-x>"] = "open_split",
        ["<C-t>"] = "open_tabnew",
      },
    },
  },
}
