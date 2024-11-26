return {
  "nvim-cmp",
  opts = function(_, opts)
    local compare = require("cmp.config.compare")

    -- opts.experimental = opts.experimental or {}
    -- opts.experimental.ghost_text = false
    --
    -- opts.matching = opts.matching or {}
    -- opts.matching.disallow_fuzzy_matching = false
    --
    -- local replacements = {
    --   snippets = {
    --     name = "snippets",
    --     preselect = true,
    --     keyword_length = 1,
    --   },
    --   nvim_lsp = {
    --     name = "nvim_lsp",
    --     preselect = true,
    --   },
    --   copilot = {
    --     name = "copilot",
    --     preselect = true,
    --   },
    --   buffer = {
    --     name = "buffer",
    --     preselect = true,
    --     keyword_length = 3,
    --     max_item_count = 20,
    --     option = { keyword_pattern = "\\k\\k\\k\\+" },
    --   },
    --   path = {
    --     name = "path",
    --   },
    -- }
    --
    -- for i, source in ipairs(opts.sources) do
    --   local name = source.name
    --   if replacements[name] then
    --     opts.sources[i] = replacements[name]
    --   end
    -- end

    opts.sorting = {
      priority_weight = 2,
      comparators = {
        compare.score,
        compare.kind,
        compare.offset,
        compare.exact,
        --  NOTE: Causing hang issues 
        -- compare.scopes,
        compare.recently_used,
        compare.locality,
        compare.sort_text,
        compare.length,
        compare.order,
      },
    }

    return opts
  end,
}
