return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader>bc", ":lua require('fzf-lua').git_bcommits()<cr>", mode = "n", desc = "Buffer Commits" },
    { "<leader>sp", ":lua require('fzf-lua').builtin()<cr>", desc = "Pickers History" },
    { "<leader>S", ":lua require('fzf-lua').spell_suggest()<cr>", desc = "Spell Suggest" },
  },
}
