local ls = require("luasnip")
local s, t, i, f = ls.snippet, ls.text_node, ls.insert_node, ls.function_node

-- longest-first so "src/main" wins over "src" at the same position
local source_roots = { "src/main", "src/test", "src", "test", "dev", "script" }

local function file_ns()
  local path = vim.fn.expand("%:p:r"):gsub("\\", "/") -- :r strips the extension
  local best_start, best_root, rel = nil, nil, nil

  for _, root in ipairs(source_roots) do
    local needle = "/" .. root .. "/"
    local from, st, en = 1, nil, nil
    while true do -- walk to the *last* occurrence
      local a, b = path:find(needle, from, true)
      if not a then
        break
      end
      st, en, from = a, b, a + 1
    end
    if st and (best_start == nil or st > best_start or (st == best_start and #root > #best_root)) then
      best_start, best_root, rel = st, root, path:sub(en + 1)
    end
  end

  rel = rel or vim.fn.expand("%:t:r") -- fallback: just the file name
  return (rel:gsub("/", "."):gsub("_", "-"))
end

ls.add_snippets("clojure", {
  s("nn", {
    t("(ns "),
    f(file_ns, {}),
    t(")"),
    i(0),
  }),
})
