return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = function()
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)
    return {
      auto_insert_mode = true,
      question_header = "  " .. user .. " ",
      answer_header = "  Copilot ",
      contexts = require("copilot.contexts"),
      prompts = require("copilot.prompts"),
      model = "claude-3.7-sonnet-thought",
    }
  end,
  keys = {
    {
      "<leader>am",
      function()
        return require("CopilotChat").select_model()
      end,
      desc = "Models (CopilotChat)",
      mode = { "n" },
    },
  },
}
