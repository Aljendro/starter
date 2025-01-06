return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      bind_to_cwd = false,
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
        ["<C-s>"] = "open_split",
        ["<C-t>"] = "open_tabnew",
      },
    },
  },
}
