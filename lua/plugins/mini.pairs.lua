return {
  "nvim-mini/mini.pairs",
  opts = {
    modes = { insert = true, command = false, terminal = false },
    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    skip_unbalanced = false,
  },
}
