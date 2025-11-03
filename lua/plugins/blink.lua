return {
  "saghen/blink.cmp",
  dependencies = {
    { "rafamadriz/friendly-snippets", dev = true },
  },
  build = "cargo build --release",
  opts = {
    cmdline = { enabled = false },
  },
}
