return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },

    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },

    { "<leader>sw", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
    { "<leader>sW", LazyVim.pick("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
    { "<leader>sw", LazyVim.pick("grep_string", { root = false }), mode = "v", desc = "Selection (cwd)" },
    { "<leader>sW", LazyVim.pick("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
    {
      "<leader>bc",
      ':lua require(\'telescope.builtin\').git_bcommits({layout_strategy=\'vertical\', git_command = {"git","log","--format=%h %cn %cs %s"} })<cr>',
      mode = "n",
      desc = "Buffer Commits",
    },
    {
      "<leader>bc",
      ':lua require(\'telescope.builtin\').git_bcommits_range({layout_strategy=\'vertical\', git_command = {"git","log","--format=%h %cn %cs %s", "--no-patch", "-L"} })<cr>',
      mode = "v",
      desc = "Buffer Commits Range",
    },
    { "<leader>sp", ":lua require('telescope.builtin').pickers()<cr>", desc = "Pickers History" },
    { "<leader>S", ":lua require('telescope.builtin').spell_suggest()<cr>", desc = "Spell Suggest" },
  },
}
