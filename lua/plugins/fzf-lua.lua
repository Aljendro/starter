return {
  "ibhagwan/fzf-lua",
  opts = {
    winopts = {
      preview = {
        hidden = true,
      },
    },
    keymap = {
      builtin = {
        ["<c-p>"] = "toggle-preview",
      },
    },
  },
  keys = {
    { "<leader>/", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    { "<leader>sG", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },

    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },

    { "<leader>sw", LazyVim.pick("grep_cword", { root = false }), desc = "Word (cwd)" },
    { "<leader>sW", LazyVim.pick("grep_cword"), desc = "Word (Root Dir)" },
    { "<leader>sw", LazyVim.pick("grep_visual", { root = false }), mode = "v", desc = "Selection (cwd)" },
    { "<leader>sW", LazyVim.pick("grep_visual"), mode = "v", desc = "Selection (Root Dir)" },

    { "<leader>bc", ":lua require('fzf-lua').git_bcommits()<cr>", mode = "n", desc = "Buffer Commits" },
    { "<leader>sp", ":lua require('fzf-lua').builtin()<cr>", desc = "Pickers History" },
    { "<leader>S", ":lua require('fzf-lua').spell_suggest()<cr>", desc = "Spell Suggest" },
  },
}
