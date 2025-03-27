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
}
