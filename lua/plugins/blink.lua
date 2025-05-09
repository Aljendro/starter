return {
  "saghen/blink.cmp",
  dependencies = {
    { "rafamadriz/friendly-snippets", dev = true },
  },
  opts = function(_, opts)
    for name, provider in pairs(opts.sources.providers) do
      if name == "copilot" then
        provider.score_offset = 10
      end
    end
  end,
}
