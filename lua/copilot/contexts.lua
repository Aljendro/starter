local context = require("CopilotChat.context")
local utils = require("CopilotChat.utils")

return {
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
  copilot_plugin_config = {
    description = "Includes the documentation for the Copilot Chat plugin.",
    resolve = function()
      local urls = {
        default_config = "https://raw.githubusercontent.com/CopilotC-Nvim/CopilotChat.nvim/refs/heads/main/lua/CopilotChat/config.lua",
        contexts = "https://raw.githubusercontent.com/CopilotC-Nvim/CopilotChat.nvim/refs/heads/main/lua/CopilotChat/config/contexts.lua",
        prompts = "https://raw.githubusercontent.com/CopilotC-Nvim/CopilotChat.nvim/refs/heads/main/lua/CopilotChat/config/prompts.lua",
      }

      local content = ""
      for name, url in pairs(urls) do
        local context_data = context.get_url(url)
        if context_data and context_data.content then
          content = content .. "#### start " .. name .. " documentation ###\n\n"
          content = content .. context_data.content .. "\n\n"
          content = content .. "### end " .. name .. " documentation ###\n\n"
        end
      end

      return {
        {
          content = content,
          filename = "copilot_chat_documentation",
          filetype = "text",
        },
      }
    end,
  },
}
