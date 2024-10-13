return {
  "nvim-cmp",
  opts = function(_, opts)
    local compare = require("cmp.config.compare")

    opts.experimental = opts.experimental or {}
    opts.experimental.ghost_text = false

    opts.matching = opts.matching or {}
    opts.matching.disallow_fuzzy_matching = false

    local replacements = {
      nvim_lsp = {
        name = "nvim_lsp",
        preselect = true,
        keyword_length = 3,
        group_index = 1,
      },
      snippets = {
        name = "snippets",
        preselect = true,
        keyword_length = 1,
        group_index = 1,
      },
      buffer = {
        name = "buffer",
        preselect = true,
        keyword_length = 4,
        max_item_count = 20,
        option = { keyword_pattern = "\\k\\k\\k\\+" },
        group_index = 3,
      },
      path = {
        name = "path",
        group_index = 5,
      },
    }

    for i, source in ipairs(opts.sources) do
      local name = source.name
      if replacements[name] then
        opts.sources[i] = replacements[name]
      end
    end

    opts.sorting = {
      priority_weight = 2,
      comparators = {
        compare.offset,
        compare.exact,
        compare.scopes,
        compare.score,
        compare.recently_used,
        compare.locality,
        compare.kind,
        compare.sort_text,
        compare.length,
        compare.order,
      },
    }

    return opts
  end,
}
