return {
  "saghen/blink.cmp",
  dependencies = {
    { "rafamadriz/friendly-snippets", dev = true },
  },
  opts = {
    fuzzy = {
      sorts = {
        -- put “;” items first
        function(a, b)
          local a_has = a.label and a.label:find(";", 1, true) and a.source_id == "snippets"
          local b_has = b.label and b.label:find(";", 1, true) and b.source_id == "snippets"
          if a_has and not b_has then
            return true -- a before b
          elseif not a_has and b_has then
            return false -- b before a
          end -- else keep going
        end,
        "score",
        "sort_text",
      },
    },
  },
}
