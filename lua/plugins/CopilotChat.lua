local utils = require("CopilotChat.utils")

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = function()
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)
    return {
      auto_insert_mode = true,
      question_header = "  " .. user .. " ",
      answer_header = "  Copilot ",
      window = {
        layout = "float",
        width = 0.9,
        height = 0.8,
      },
      contexts = {
        -- Add custom context to extract ticket ID from branch name
        git_branch = {
          description = "Extracts the current git branch name and any ticket IDs (like AOPS-123456).",
          resolve = function(_, source)
            local cmd = {
              "git",
              "-C",
              source.cwd(),
              "branch",
              "--show-current",
            }
            local out = utils.system(cmd)

            local branch = out.stdout:gsub("[\r\n]", "")
            local ticket = branch:match("(%w+%-%d+)")

            return {
              {
                content = "Git branch: " .. branch .. (ticket and "\nTicket ID: " .. ticket or ""),
                filename = "git_branch_info",
                filetype = "text",
              },
            }
          end,
        },
      },
      prompts = {
        -- Add custom prompt for conventional commits
        CBCommit = {
          prompt = "Write a conventional commit message for the staged changes. If a ticket ID (like AOPS-123456) is found in the branch name, include it in the commit message. Do not include a scope. Format as: type: TICKET-ID: message. Keep the title under 50 characters and wrap body text at 72 characters. Format as a gitcommit code block.",
          context = { "git:staged", "git_branch" },
        },
      },
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
