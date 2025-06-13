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
  plenary_api = {
    description = "Includes the documentation for the Plenary API.",
    resolve = function()
      local urls = {
        job = "https://raw.githubusercontent.com/nvim-lua/plenary.nvim/refs/heads/master/lua/plenary/job.lua",
        async = "https://raw.githubusercontent.com/nvim-lua/plenary.nvim/refs/heads/master/lua/plenary/async/async.lua",
      }

      local content = ""
      for name, url in pairs(urls) do
        local context_data = context.get_url(url)
        if context_data and context_data.content then
          content = content .. "#### start " .. name .. " implementation ###\n\n"
          content = content .. context_data.content .. "\n\n"
          content = content .. "### end " .. name .. " implementation ###\n\n"
        end
      end

      return {
        {
          content = content,
          filename = "plenary_api_documentation",
          filetype = "text",
        },
      }
    end,
  },
  fzf_advanced_markdown = {
    description = "Includes content of the Advanced.md file in chat context.",
    resolve = function()
      local filepath = "/Users/alejandroalvarado/Documents/Learning/fzf-lua.wiki/Advanced.md"
      local content = context.get_file(filepath, "markdown")
      return {
        {
          content = content,
          filename = "fzf_advanced_markdown_documentation",
          filetype = "markdown",
        },
      }
    end,
  },
}
