return {
  "karb94/neoscroll.nvim",
  config = function()
    local neoscroll = require("neoscroll")
    neoscroll.setup({ mappings = {} })
    local keymap = {
      ["<C-i>"] = function()
        neoscroll.ctrl_u({ duration = 200 })
      end,
      ["<C-u>"] = function()
        neoscroll.ctrl_d({ duration = 200 })
      end,
      ["<C-y>"] = function()
        neoscroll.scroll(-0.1, { move_cursor = false, duration = 50 })
      end,
      ["<C-e>"] = function()
        neoscroll.scroll(0.1, { move_cursor = false, duration = 50 })
      end,
    }
    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
}
